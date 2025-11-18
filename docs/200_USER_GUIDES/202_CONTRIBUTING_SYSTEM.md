> START OF ./docs/200_USER_GUIDES/202_CONTRIBUTING_SYSTEM.md
>
> **OVHL ENGINE V1.0.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** ENGINE ENGINEERS, CORE DEVELOPERS
> **PURPOSE:** Panduan teknis untuk menambahkan Sistem Engine baru yang patuh 4-Phase Lifecycle dan OVHL standards.

---

# 🛠️ 202_CONTRIBUTING_SYSTEM.md (V1.0.0)

> **PENTING:** Pahami perbedaan **System** vs **Module** sebelum baca doc ini.

---

## 1. ⚠️ ATURAN EMAS (FUNDAMENTAL)

### **System vs Module - Bedanya Apa?**

| Aspek            | **System**                                     | **Module**                           |
| ---------------- | ---------------------------------------------- | ------------------------------------ |
| **Purpose**      | Teknologi inti (Logger, Security, UI)          | Fitur gameplay (Shop, Inventory)     |
| **Location**     | `Systems/[Category]/`                          | `Modules/[ModuleName]/`              |
| **Framework**    | Standalone (native Lua)                        | Knit Service/Controller              |
| **Lifecycle**    | 4-Phase (Initialize, Register, Start, Destroy) | Knit lifecycle (KnitInit, KnitStart) |
| **Dependencies** | Declared via `*Manifest.lua`                   | Declared via `self.OVHL:GetSystem()` |
| **Contoh**       | SmartLogger, DataManager, UIEngine             | MinimalModule, InventoryModule       |

**PENTING:** Jangan tukar! System = Core infrastructure. Module = Gameplay logic.

---

## 2. KONSEP: 4-PHASE LIFECYCLE (ADR-004)

Semua system **WAJIB** implement 4-fase ini. Ini mandatory pattern.

### **FASE 1: Initialize(logger)**

**Purpose:** Konstruksi objek + siapkan variabel.

**Constraints:**

- ✅ BOLEH: Simpan logger, init variables, setup internal state
- ❌ TIDAK BOLEH: `OVHL:GetSystem()` (sistem lain belum terdaftar)
- ❌ TIDAK BOLEH: `.Connect()` events
- ❌ TIDAK BOLEH: `task.spawn()` background task

**Why?** Karena pada fase ini, sistem lain baru di-init juga. Jika lu panggil `GetSystem("B")` sebelum B di-init, hasilnya nil.

**Code Template:**

```lua
function MySystem:Initialize(logger)
    self._logger = logger  -- ✅ OK
    self._data = {}        -- ✅ OK
    self._connections = {} -- ✅ OK

    -- ❌ JANGAN:
    -- self._dependency = OVHL:GetSystem("OtherSystem")
    -- self._connections.event = game.Something:Connect(function() end)
    -- task.spawn(function() ... end)
end
```

---

### **FASE 2: Register (Internal)**

**Purpose:** SystemRegistry diam-diam register sistem ke OVHL gateway.

**What happens (automatic, tidak perlu implement):**

- Semua sistem yg sudah di-Initialize sekarang terdaftar di OVHL
- `OVHL:GetSystem(name)` mulai aman dipanggil

**Hidden dari system perspective** - lu tidak usah implement ini.

---

### **FASE 3: Start()**

**Purpose:** Aktivasi - resolve dependensi, hubung event, mulai task.

**Constraints (NOW SAFE):**

- ✅ BOLEH: `OVHL:GetSystem()` (semua sudah terdaftar)
- ✅ BOLEH: `.Connect()` events
- ✅ BOLEH: `task.spawn()` background tasks
- ✅ BOLEH: Load external services (DataStore, API, etc)

**Why split dari Fase 1?** Agar **resolve dependensi aman**. Contoh:

- `PlayerManager:Start()` bisa safely call `OVHL:GetSystem("DataManager")`
- Karena DataManager sudah fully initialize (Fase 1) + registered (Fase 2)

**Code Template:**

```lua
function MySystem:Start()
    local OVHL = require(...)

    -- ✅ OK: Sekarang aman ambil dependensi
    self._logger = OVHL:GetSystem("SmartLogger")
    self._dataManager = OVHL:GetSystem("DataManager")

    -- ✅ OK: Hubung events
    self._connections = {}
    self._connections.playerAdded = game:GetService("Players").PlayerAdded:Connect(function(player)
        self:_onPlayerAdded(player)
    end)

    -- ✅ OK: Mulai background task
    self._isRunning = true
    task.spawn(function()
        while self._isRunning do
            task.wait(300)
            self:_cleanupOldData()
        end
    end)
end
```

---

### **FASE 4: Destroy() (Optional tapi RECOMMENDED)**

**Purpose:** Cleanup sebelum shutdown.

**When triggered:** `game:BindToClose()` → `SystemRegistry:Shutdown()`

**Important:** SystemRegistry panggil `:Destroy()` dalam **REVERSE ORDER**.

- Kenapa? Karena Logger dependency-nya banyak system. Jika destroy duluan, sistem lain crash.
- Reverse order ensure Logger destroy paling akhir.

**Constraints (Must cleanup):**

- ✅ BOLEH: Stop background tasks
- ✅ BOLEH: Disconnect events
- ✅ BOLEH: Save data
- ✅ BOLEH: Log cleanup status

**Code Template:**

```lua
function MySystem:Destroy()
    self._logger:Info("MYSYSTEM", "Fase 4 (Destroy) triggered")

    -- 1. Stop background task
    self._isRunning = false

    -- 2. Disconnect events
    for name, connection in pairs(self._connections) do
        pcall(function() connection:Disconnect() end)
    end
    self._connections = {}

    -- 3. Save data (jika ada)
    self:_saveCriticalData()

    self._logger:Info("MYSYSTEM", "Cleanup complete")
end
```

**PENTING:** Wrap `:Disconnect()` dalam `pcall()` jika tidak pasti connection ada.

---

## 3. STEP-BY-STEP: MEMBUAT SYSTEM BARU

Mari kita bikin **SoundManager** system sebagai contoh.

### **Step 1: Tentukan Kategori**

Pilih folder di `Systems/`:

- `Foundation/` - Sangat dasar (Logger, Config)
- `Security/` - Keamanan (Validator, RateLimiter)
- `Networking/` - Transport (Router, RemoteBuilder)
- `UI/` - UI frameworks (UIEngine, UIManager)
- `Advanced/` - Complex stuff (DataManager, PlayerManager, NotificationService)

**Keputusan:** SoundManager → `Systems/Advanced/` (karena complex)

---

### **Step 2: Buat Main File + Manifest**

**File 1: `SoundManager.lua`**

```lua
--[[
OVHL ENGINE V1.0.0
@Component: SoundManager (Core System)
@Path: ReplicatedStorage.OVHL.Systems.Advanced.SoundManager
@Purpose: Centralized sound playback + management
@Stability: BETA
--]]

local SoundManager = {}
SoundManager.__index = SoundManager

function SoundManager.new()
    local self = setmetatable({}, SoundManager)
    self._logger = nil
    self._sounds = {}        -- {soundId = Instance}
    self._volumes = {}       -- {category = volume}
    self._connections = {}
    self._isRunning = false
    return self
end

-- FASE 1: Initialize (construction only)
function SoundManager:Initialize(logger)
    self._logger = logger
    self._logger:Info("SOUNDMANAGER", "Sound Manager initialized")
end

-- FASE 3: Start (activation)
function SoundManager:Start()
    self._isRunning = true
    self._logger:Info("SOUNDMANAGER", "Sound Manager started")
end

-- FASE 4: Destroy (cleanup)
function SoundManager:Destroy()
    self._logger:Info("SOUNDMANAGER", "Shutting down...")

    self._isRunning = false

    -- Stop semua sound
    for _, sound in pairs(self._sounds) do
        pcall(function() sound:Destroy() end)
    end
    self._sounds = {}

    self._logger:Info("SOUNDMANAGER", "Shutdown complete")
end

-- PUBLIC API
function SoundManager:PlaySound(soundId, parent, volume)
    if not self._isRunning then return nil end

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Volume = volume or 0.5
    sound.Parent = parent or workspace
    sound:Play()

    self._sounds[soundId] = sound

    self._logger:Debug("SOUNDMANAGER", "Playing sound", { soundId = soundId })
    return sound
end

function SoundManager:StopSound(soundId)
    local sound = self._sounds[soundId]
    if sound then
        sound:Stop()
        self._sounds[soundId] = nil
        return true
    end
    return false
end

return SoundManager

--[[
@End: SoundManager.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]
```

**File 2: `SoundManagerManifest.lua`**

```lua
--[[
OVHL ENGINE V1.0.0
@Component: SoundManager Manifest
@Path: ReplicatedStorage.OVHL.Systems.Advanced.SoundManagerManifest
@Purpose: Declare dependencies untuk SoundManager
@Stability: STABLE
--]]

return {
    name = "SoundManager",
    dependencies = { "SmartLogger" },  -- Hanya depend logger
    context = "Client"                  -- Load hanya di client (sounds hanya client-side)
}

--[[
@End: SoundManagerManifest.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]
```

---

### **Step 3: File Structure**

Setelah buat, struktur folder jadi:

```
Systems/Advanced/
├── DataManager.lua
├── DataManagerManifest.lua
├── PlayerManager.lua
├── PlayerManagerManifest.lua
├── NotificationService.lua
├── NotificationServiceManifest.lua
├── SoundManager.lua                    ← NEW
├── SoundManagerManifest.lua            ← NEW
├── ...
```

---

### **Step 4: Use System di Modul**

Sekarang modul bisa akses SoundManager:

```lua
-- Di ShopService.lua
function ShopService:KnitInit()
    self.OVHL = require(...)
    self.Logger = self.OVHL:GetSystem("SmartLogger")
    self.SoundManager = self.OVHL:GetSystem("SoundManager")  -- ✅ NEW
end

function ShopService:ProcessPurchase(player, itemId)
    -- ... security checks ...

    -- Mainkan sound saat berhasil
    if success then
        self.SoundManager:PlaySound("123456789", workspace, 0.8)
    end
end
```

---

### **Step 5: Test**

Play test di Studio:

```
1. Server boot → lihat log "Sound Manager started"
2. Purchase item → lihat log "Playing sound"
3. Game close → lihat log "Shutdown complete"
```

Ensure **no nil errors**, **no memory leaks**.

---

## 4. ADVANCED: SYSTEM DENGAN DEPENDENCIES

Kalau system lu depend sistem lain (bukan hanya Logger):

**Example: `NotificationService` depend `NetworkingRouter`**

### **Manifest:**

```lua
return {
    name = "NotificationService",
    dependencies = { "SmartLogger", "NetworkingRouter" },  -- Multiple deps
    context = "Server"
}
```

### **Code:**

```lua
function NotificationService:Start()
    local OVHL = require(...)

    -- Resolve dependencies (SAFE di Fase 3)
    self._logger = OVHL:GetSystem("SmartLogger")
    self._router = OVHL:GetSystem("NetworkingRouter")

    if not self._router then
        self._logger:Critical("NOTIFICATION", "Router not available!")
        return
    end

    self._logger:Info("NOTIFICATION", "Notification Service ready")
end

function NotificationService:SendToPlayer(player, message, icon)
    if not self._router then return end

    self._router:SendToClient(player, "OVHL.Notification.Show", {
        Message = message,
        Icon = icon or "Info"
    })
end
```

### **SystemRegistry akan otomatis:**

1. Initialize NotificationService **SETELAH** NetworkingRouter (dependency order)
2. Register semua sistem
3. Start NotificationService (NetworkingRouter sudah siap)

**Key:** Declare di Manifest, resolve di Start(), use dengan aman.

---

## 5. COMMON PATTERNS

### **Pattern 1: Background Task dengan Cleanup**

```lua
function MySystem:Start()
    self._isRunning = true
    task.spawn(function()
        while self._isRunning do
            self:_doWork()
            task.wait(60)
        end
    end)
end

function MySystem:Destroy()
    self._isRunning = false  -- Flag stop loop
    task.wait(0.1)           -- Brief wait untuk loop notice
    self._logger:Info("MYSYSTEM", "Shutdown complete")
end
```

### **Pattern 2: Event Connection dengan Cleanup**

```lua
function MySystem:Start()
    self._connections = {}

    self._connections.event1 = game.Something:Connect(function()
        self:_onEvent()
    end)
end

function MySystem:Destroy()
    for name, conn in pairs(self._connections) do
        pcall(function() conn:Disconnect() end)
    end
    self._connections = {}
end
```

### **Pattern 3: External Service Connection (DataStore, API)**

```lua
function MySystem:Start()
    local success, result = pcall(function()
        self._dataStore = game:GetService("DataStoreService"):GetDataStore("MyData")
        return true
    end)

    if success then
        self._logger:Info("MYSYSTEM", "Connected to DataStore")
    else
        self._logger:Critical("MYSYSTEM", "Failed to connect DataStore", { error = result })
    end
end

function MySystem:Destroy()
    -- DataStore tidak perlu explicit cleanup, GC handle
    self._logger:Info("MYSYSTEM", "Shutdown")
end
```

---

## 6. INTEGRATION: HOW SYSTEMS WORK TOGETHER

Contoh flow kompleks:

```
PlayerManager:Start()
    ↓
Resolve DataManager via OVHL:GetSystem("DataManager")
    ↓
Connect Players.PlayerAdded event
    ↓
Player join → PlayerManager:_onPlayerAdded(player)
    ↓
Call DataManager:LoadData(player)
    ↓
DataManager fetch dari DataStore
    ↓
Player data loaded
    ↓
NotificationService send "Welcome" notification ke client
    ↓
Client receive via NetworkingRouter
    ↓
UI show notification
```

**Key:** Sistem terpisah tapi bisa berkomunikasi via OVHL gateway.

---

## 7. VALIDATION CHECKLIST (SEBELUM SUBMIT)

- [ ] File `.lua` + `*Manifest.lua` ada
- [ ] Manifest punya `name`, `dependencies`, `context`
- [ ] `:Initialize(logger)` hanya init variables (no GetSystem)
- [ ] `:Start()` punya GetSystem + Connect + task.spawn (jika ada)
- [ ] `:Destroy()` cleanup (disconnect, stop task) - jika ada
- [ ] Header + footer V1.0.0 lengkap
- [ ] No placeholder / ellipsis
- [ ] Logger.Info di Start + Destroy
- [ ] Test di studio: boot + shutdown smooth
- [ ] No nil errors, no memory leak

---

## 8. TROUBLESHOOTING

### **Error: "Circular Dependency detected"**

**Cause:** System A depend B, B depend A

**Fix:** Remove dependency dari salah satu

```lua
-- WRONG:
-- A depend B
-- B depend A

-- RIGHT:
-- A depend B (saja)
-- B tidak depend A (gunakan event atau callback instead)
```

---

### **Error: "GetSystem() returned nil"**

**Cause:** Call `OVHL:GetSystem()` di Fase 1 (Initialize)

**Fix:** Move ke Fase 3 (Start)

```lua
-- WRONG:
function MySystem:Initialize(logger)
    self._other = OVHL:GetSystem("OtherSystem")  -- nil!
end

-- RIGHT:
function MySystem:Start()
    self._other = OVHL:GetSystem("OtherSystem")  -- safe
end
```

---

### **Error: "Memory leak - connections not disconnected"**

**Cause:** Forgot to implement `:Destroy()` atau tidak disconnect

**Fix:** Implement Destroy + disconnect

```lua
function MySystem:Destroy()
    for name, conn in pairs(self._connections) do
        pcall(function() conn:Disconnect() end)  -- cleanup
    end
end
```

---

> END OF ./docs/200_USER_GUIDES/202_CONTRIBUTING_SYSTEM.md
