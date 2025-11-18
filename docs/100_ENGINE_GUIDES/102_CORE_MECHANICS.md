> START OF ./docs/100_ENGINE_GUIDES/102_CORE_MECHANICS.md
>
> **OVHL ENGINE V1.0.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** ENGINE ENGINEERS
> **PURPOSE:** Menjelaskan detail teknis Boot Sequence, Data Flow, dan 4-Phase Lifecycle untuk keperluan debug dan rebuild.

---

# ⚙️ 102_CORE_MECHANICS.md (V1.0.0 - Deep Dive)

---

## 1. THE BOOT SEQUENCE (4-FASE LIFECYCLE - ADR-004)

OVHL V1.0.0 mengimplementasikan **4-Fase Lifecycle Deterministik**, menghilangkan race condition selamanya.

### **OVERVIEW - Urutan Nyala Engine**

```
[1] Game Start
    ↓
[2] ServerRuntime.server.lua OR ClientRuntime.client.lua executed
    ↓
[3] Bootstrap:Initialize() called
    ├─→ Scan Systems via *Manifest.lua files
    ├─→ Create SystemRegistry
    ├─→ Detect environment (Server/Client)
    └─→ Return OVHL gateway
    ↓
[4] Kernel scans Modules/ folder
    ├─→ Find *Service.lua (server) / *Controller.lua (client)
    └─→ Prepare untuk Knit
    ↓
[5] Knit.Start() called
    ├─→ All Services/Controllers KnitInit() + KnitStart()
    └─→ SystemRegistry triggers 4-Phase
    ↓
[READY] Game ready untuk gameplay
    ↓
[6] game:BindToClose() triggered (shutdown)
    └─→ SystemRegistry:Shutdown() triggers Fase 4 (Destroy)
    ↓
[END] Game closed
```

---

### **DETAILED 4-PHASE BREAKDOWN**

#### **FASE 1: INITIALIZE (Construction)**

**What happens:**

- SystemRegistry looping semua system dalam **Topological Order** (dependencies resolved)
- Untuk setiap system:
  1. `require(systemModule)` → load Lua code
  2. `.new()` → create instance
  3. `:Initialize(logger)` → setup logger + basic variables

**Constraints (MANDATORY):**

- ❌ **JANGAN** panggil `OVHL:GetSystem()` (tidak terdaftar yet)
- ❌ **JANGAN** hubung event dengan `.Connect()`
- ❌ **JANGAN** spawn task dengan `task.spawn()`

**Why?** Jika system A depend system B, dan A coba `GetSystem("B")` sebelum B di-init, hasilnya nil → crash.

**Code Example (Correct):**

```lua
function DataManager:Initialize(logger)
    self._logger = logger  -- OK: simpan logger
    self._dataStore = nil  -- OK: init variable kosong
    -- JANGAN: self._ds = DataStoreService:GetDataStore(...) di sini
end
```

---

#### **FASE 2: REGISTER (Registration)**

**What happens:**

- SystemRegistry diam-diam register semua system ke OVHL gateway
- Ini **NOT visible** dari system perspective
- Setelah fase ini, `OVHL:GetSystem(name)` **aman dipanggil**

**Code flow (internal):**

```lua
-- SystemRegistry doing this internally
for systemName, systemInstance in pairs(self._systems) do
    self._ovhl:RegisterSystem(systemName, systemInstance)
end
```

**Why separate dari Fase 1?** Karena ada systems dengan circular reference (A depend B, B depend A via OVHL gateway). Fase 2 ensure semua sudah exist di registry sebelum Fase 3.

---

#### **FASE 3: START (Activation)**

**What happens:**

- SystemRegistry looping semua system lagi, **dalam urutan yg sama**
- Untuk setiap system: panggil `:Start()`
- **NOW `OVHL:GetSystem()` AMAN dipanggil**

**Constraints (NOW OK):**

- ✅ **BOLEH** panggil `OVHL:GetSystem()` (sudah terdaftar)
- ✅ **BOLEH** hubung event dengan `.Connect()`
- ✅ **BOLEH** spawn task dengan `task.spawn()`

**Code Example (Correct):**

```lua
function PlayerManager:Start()
    local OVHL = require(...)

    -- NOW SAFE: DataManager sudah exist
    self._dataManager = OVHL:GetSystem("DataManager")

    -- OK: Connect events
    self._connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
        self:_onPlayerAdded(player)
    end)

    -- OK: Spawn background task
    self._isRunning = true
    task.spawn(function()
        while self._isRunning do
            task.wait(300)
            self:_cleanupOldData()
        end
    end)
end
```

**Why separate dari Fase 1?** Agar **dependensi resolved aman**. `PlayerManager:Start()` bisa safely call `DataManager:Start()` via `OVHL:GetSystem("DataManager")` karena DataManager sudah fully initialize (Fase 1) + registered (Fase 2).

---

#### **FASE 4: DESTROY (Cleanup)**

**What happens (triggered by `game:BindToClose()`):**

- SystemRegistry looping sistem dalam **REVERSE order** (terbalik)
- Untuk setiap system: panggil `:Destroy()`
- Memberikan kesempatan cleanup sebelum server/client shutdown

**Why REVERSE order?** Karena Logger dependency-nya banyak system. Jika Logger di-destroy duluan, system lain yang panggil logger di Destroy() mereka bakal crash. Reverse order ensure Logger destroy **paling akhir**.

**Example flow:**

```
LoadOrder: [ConfigLoader, SmartLogger, DataManager, PlayerManager]

Destroy order (reverse): [PlayerManager, DataManager, SmartLogger, ConfigLoader]
                         └─ Last system destroy first
                         └─ Logger destroy last (safe)
```

**Code Example (Correct):**

```lua
function PlayerManager:Destroy()
    self._logger:Info("PLAYERMANAGER", "Shutdown phase triggered")

    -- 1. Stop loop
    self._isRunning = false

    -- 2. Disconnect events
    for name, connection in pairs(self._connections) do
        pcall(function() connection:Disconnect() end)
    end

    -- 3. Save critical data
    for _, player in ipairs(Players:GetPlayers()) do
        self:_onPlayerRemoving(player)  -- Save their data
    end

    self._logger:Info("PLAYERMANAGER", "Cleanup complete")
end
```

---

## 2. DATA FLOW & SECURITY PIPELINE

Ini alur standar **Client → Server** untuk Modul Gameplay yg patuh pattern:

```
┌─────────────────────────────────────────────────────────────┐
│                     CLIENT SIDE                             │
│                                                             │
│  [UI Button Click]                                         │
│         ↓                                                   │
│  [MinimalController:DoAction(actionData)]                  │
│         ↓                                                   │
│  [self.Service:ProcessAction(actionData)]  ← Knit Remote  │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                     SERVER SIDE                             │
│                                                             │
│  [MinimalService:ProcessAction(player, actionData)]       │
│         ↓                                                   │
│   ┌─────────────────────────────────┐                      │
│   │  SECURITY PIPELINE (3 PILAR)    │                      │
│   │                                 │                      │
│   │ [1] InputValidator:Validate()   │ Check schema         │
│   │         ↓ FAIL → Return error    │                      │
│   │         ↓ OK → Continue          │                      │
│   │                                 │                      │
│   │ [2] RateLimiter:Check()          │ Check spam          │
│   │         ↓ FAIL → Return error    │                      │
│   │         ↓ OK → Continue          │                      │
│   │                                 │                      │
│   │ [3] PermissionCore:Check()       │ Check rank/access   │
│   │         ↓ FAIL → Return error    │                      │
│   │         ↓ OK → Continue          │                      │
│   └─────────────────────────────────┘                      │
│         ↓                                                   │
│  [Business Logic] ← Semua checks passed                   │
│         ↓                                                   │
│  [Log + Return success]                                    │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                     CLIENT SIDE                             │
│                                                             │
│  [Result returned via Knit Remote]                         │
│         ↓                                                   │
│  [MinimalController handles result]                        │
│         ↓                                                   │
│  [Update UI / Show notification]                           │
└─────────────────────────────────────────────────────────────┘
```

### **Security Configuration Example**

Semua 3 pilar validate dari **SharedConfig.lua**:

```lua
-- SharedConfig.lua (Shared antara client + server)
return {
    Security = {
        ValidationSchemas = {
            ActionData = {
                type = "table",
                fields = {
                    action = { type = "string", min = 1, max = 50 },
                    data = { type = "table", optional = true }
                }
            }
        },
        RateLimits = {
            DoAction = { max = 10, window = 60 }  -- 10x per 60 detik
        }
    },
    Permissions = {
        test = { Rank = "NonAdmin" },      -- Everyone bisa
        admin = { Rank = "Admin" }         -- Hanya admin
    }
}
```

### **Service Implementation**

```lua
function MinimalService:ProcessAction(player, actionData)
    -- 1. VALIDATE
    local valid, err = self.InputValidator:Validate("ActionData", actionData)
    if not valid then
        self.Logger:Warn("SECURITY", "Validation failed", {player=player.Name, err=err})
        return false, err
    end

    -- 2. RATE LIMIT
    if not self.RateLimiter:Check(player, "DoAction") then
        return false, "Spam detected"
    end

    -- 3. PERMISSION
    local permNode = "MinimalModule." .. actionData.action
    if not self.PermissionCore:Check(player, permNode) then
        return false, "No permission"
    end

    -- 4. EXECUTE
    return self:_executeLogic(player, actionData)
end
```

---

## 3. UI RENDERING PIPELINE (FUSION 0.3 SCOPED)

Paling kritikal untuk avoid memory leak dan scope errors.

### **Step-by-step: UI Creation**

```
[1] MinimalController:SetupUI()
    ↓
[2] UIEngine:CreateScreen("MainUI", config)
    ├─→ local scope = Fusion.scoped(Fusion)  ← CREATE SCOPE
    ├─→ screenGui = scope:New "ScreenGui" {} ← SEMUA child create dengan scope
    ├─→ Attach scope ke instance: _activeScreens["MainUI"] = {Instance, Scope}
    └─→ Return screenGui
    ↓
[3] UIManager:RegisterScreen("MainUI", screenGui)
    ├─→ Store reference
    └─→ Ready untuk Show/Hide
    ↓
[4] MinimalController:_setupUIComponents(screen)
    ├─→ Find button: UIManager:FindComponent("MainUI", "ActionButton")
    ├─→ Bind click: UIManager:BindEvent(button, "Activated", callback)
    └─→ Callback closure capture variables safely dalam scope
    ↓
[READY] UI siap untuk interact
```

### **Why Scope Important (Memory Safety)**

```lua
-- WRONG (Memory leak):
local screenGui = Instance.new("ScreenGui")
local button = Instance.new("TextButton", screenGui)
button.Activated:Connect(function()
    print("Clicked")  -- Connection never cleanup
end)
-- Saat UI dihapus, connection masih exist → memory leak

-- RIGHT (Fusion scoped - auto cleanup):
local scope = Fusion.scoped(Fusion)
local screenGui = scope:New "ScreenGui" {
    [Fusion.Children] = {
        scope:New "TextButton" {
            [OnEvent "Activated"] = function()
                print("Clicked")  -- Connection auto cleanup when scope destroyed
            end
        }
    }
}
-- Saat scope:destroy() dipanggil, semua connection + instance di-cleanup otomatis
```

### **Cleanup Pipeline (Inverse)**

```
[Game closing]
    ↓
[ServerRuntime: game:BindToClose() fires]
    ↓
[SystemRegistry:Shutdown()]
    ├─→ Fase 4 (Destroy) dimulai
    ├─→ For each system (REVERSE order):
    │   ├─→ Call :Destroy()
    │   └─→ SystemRegistry log hasil
    └─→ Done
    ↓
[Client cleanup]
    ├─→ UIEngine screens destroy (via scope:destroy())
    ├─→ AssetLoader disconnect keybinds
    └─→ All connections cleanup
    ↓
[Server + Client terminate safely]
```

---

## 4. MANIFEST SYSTEM & ENVIRONMENT AWARENESS

### **How Manifest Works**

Setiap system punya companion file `*Manifest.lua`:

```lua
-- SmartLoggerManifest.lua
return {
    name = "SmartLogger",
    dependencies = { "ConfigLoader" },
    context = "Shared"  -- Atau "Server" / "Client"
}
```

**Context values:**

- `"Shared"`: Load di server DAN client
- `"Server"`: Load hanya di server
- `"Client"`: Load hanya di client

### **Bootstrap Scanning Process**

```
[1] Bootstrap:DetectEnvironment()
    └─→ Detect Server atau Client
    ↓
[2] Bootstrap:_ScanManifests(environment)
    ├─→ PASS 1: Index semua *Manifest.lua files
    ├─→ PASS 2: Match manifest dengan main file
    ├─→ Check context (skip jika beda environment)
    ├─→ Validasi manifest structure
    └─→ Return list manifests sesuai environment
    ↓
[3] Bootstrap:_GetLegacySystems() (fallback)
    ├─→ Jika ada system lama tanpa manifest
    ├─→ Use hardcoded dependencies
    └─→ Return list legacy systems
    ↓
[4] Gabung manifest + legacy
    ↓
[5] Pass ke SystemRegistry:RegisterAndStartFromManifests()
    ├─→ Topological sort
    ├─→ Run 4-Phase
    └─→ Done
```

### **Example: Server vs Client**

**Manifest SmartLogger:**

```lua
return {
    name = "SmartLogger",
    dependencies = {},
    context = "Shared"  -- Load di kedua
}
```

**Manifest UIEngine:**

```lua
return {
    name = "UIEngine",
    dependencies = {"SmartLogger", "ConfigLoader"},
    context = "Client"  -- Load hanya di client
}
```

**Bootstrap behavior:**

- Server: SmartLogger ✅, UIEngine ❌ (skip)
- Client: SmartLogger ✅, UIEngine ✅

---

## 5. ERROR SCENARIOS & RECOVERY

### **Scenario 1: Circular Dependency**

```
System A depends B
System B depends A
        ↓
Bootstrap scan: OK
SystemRegistry topological sort: ❌ CRASH (circular detected)
        ↓
Error log: "Circular Dependency: A → B → A"
        ↓
Engine tidak boot
        ↓
Fix: Remove one dependency
```

### **Scenario 2: Missing Dependency**

```
System A depends B
System B tidak exist
        ↓
Bootstrap scan: ❌ B not found
        ↓
Error log: "Missing Dependency: B not found"
        ↓
SystemRegistry: Stop boot
        ↓
Fix: Create System B atau remove A's dependency
```

### **Scenario 3: Manifest Rusak**

```
*Manifest.lua missing "name" field
        ↓
Bootstrap validate: ❌ Invalid manifest
        ↓
Error log: "Manifest Corrupt: SmartLogger"
        ↓
Skip sistem, continue boot (degraded mode)
        ↓
Fix: Fix manifest structure
```

### **Scenario 4: System :Initialize() Fail**

```
DataManager:Initialize() throw error
        ↓
SystemRegistry Fase 1: ❌ Catch error
        ↓
Error log: "Startup GAGAL: DataManager - [error message]"
        ↓
failedCount++
        ↓
If failedCount > 0: Critical("FATAL BOOT ERROR")
        ↓
Fix: Debug DataManager:Initialize()
```

---

## 6. PERFORMANCE IMPLICATIONS

### **Boot Time Breakdown (Approximate)**

```
Phase 1 (Initialize):    ~200ms (50 systems × 4ms avg)
Phase 2 (Register):      ~10ms
Phase 3 (Start):         ~300ms (background tasks spawn)
Knit.Start():            ~100ms (service/controller load)
─────────────────────────────────
TOTAL:                   ~600ms (0.6 detik)
```

### **Memory Overhead Per System**

- Empty system: ~2KB (minimal)
- System dengan background task: ~5-10KB (task + connections)
- System dengan DataStore connection: ~3KB (plus DataStore overhead)

**Optimization tips:**

- Lazy load modules (jangan load semua di boot)
- Use `task.spawn()` untuk long-running tasks, jangan block Fase 3
- Cleanup connections di `:Destroy()`

---

## 7. DEBUGGING & MONITORING

### **Useful APIs**

```lua
local OVHL = require(...)

-- Check system health
local health = OVHL:GetSystemsHealth()
-- Returns: {SmartLogger = {Status: "READY", Dependencies: [...]}, ...}

-- Check system status
local status = OVHL:GetSystemStatus("DataManager")
-- Returns: "READY" atau "ERROR_INIT" atau "ERROR_START" dll

-- Check load order
local order = OVHL:GetSystemsLoadOrder()
-- Returns: ["ConfigLoader", "SmartLogger", "DataManager", ...]
```

### **Common Debug Logs**

```lua
-- Boot complete
Logger:Info("BOOTSTRAP", "Bootstrap V1.0.0 complete", {
    environment = "Server",
    systems_loaded = 15,
    systems_failed = 0
})

-- Fase 3 complete
Logger:Info("SYSTEMREGISTRY", "Fase 3 (Start) complete", {
    started = 14,
    failed = 0
})

-- Shutdown initiated
Logger:Critical("SERVER", "Game closing. Initiating OVHL Fase 4...", {})
```

---

> END OF ./docs/100_ENGINE_GUIDES/102_CORE_MECHANICS.md
