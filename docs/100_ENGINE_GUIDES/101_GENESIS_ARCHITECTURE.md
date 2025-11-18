> START OF ./docs/100_ENGINE_GUIDES/101_GENESIS_ARCHITECTURE.md
>
> **OVHL ENGINE V1.0.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** ENGINE ARCHITECT
> **PURPOSE:** Definisi Hukum Arsitektural yg Absolut dan Abadi untuk V1.0.0.

---

# 📜 101_GENESIS_ARCHITECTURE.md (V1.0.0 - Core Law)

---

## 1. FILOSOFI & HUKUM DASAR (THE 12 COMMANDMENTS)

**12 hukum ini adalah fondasi engine. Jangan dilanggar.**

### **HUKUM 1: Zero Core Modification**

- Modul game (`Modules/`) **DILARANG** menyentuh folder `Core/`
- `Core/` adalah _black box_
- Alasan: Menjaga stabilitas engine, prevent circular dependency

### **HUKUM 2: Separation of Concerns**

- `Systems/` = Teknologi inti (Logger, Validator, Router, DataManager)
- `Modules/` = Fitur gameplay (Shop, Inventory, Quest)
- Jangan campur: Services tidak boleh contain business logic mentah

### **HUKUM 3: Server Authority**

- Client **TIDAK** dipercaya
- Input dari client **HARUS** lewat:
  1. `InputValidator` (Schema check)
  2. `RateLimiter` (Spam check)
  3. `PermissionCore` (Rank check)
- Baru lalu eksekusi business logic di server

### **HUKUM 4: Config-Driven**

- Behavior diatur via **3 file Config**:
  - `SharedConfig.lua` (Kontrak data, schema, izin umum)
  - `ServerConfig.lua` (Rahasia, API keys, db credentials)
  - `ClientConfig.lua` (Preferensi visual, keybinds)
- **DILARANG hardcode magic values**
- Semua system ini akan support adapter pattern (V1.1.0 roadmap)

### **HUKUM 5: Fusion 0.3 Scoped UI**

- UI **WAJIB** menggunakan `Fusion.scoped`
- **DILARANG** instansiasi UI tanpa Scope (memory leak heaven)
- Scope otomatis cleanup saat `:Destroy()` dipanggil

### **HUKUM 6: No Global State**

- State disimpan di Service/Controller atau `StateManager` (Roadmap V1.1.0)
- **`_G` DILARANG** (kecuali third-party APIs yg inject kesana)
- Alasan: Thread safety, debugging nightmare

### **HUKUM 7: Self-Contained Modules**

- Modul membawa 3 file config, service, dan controller-nya sendiri
- Folder structure:
  ```
  Modules/[ModuleName]/
  ├── Shared/
  │   └── SharedConfig.lua
  ├── Server/
  │   ├── [Name]Service.lua
  │   └── ServerConfig.lua
  └── Client/
      ├── [Name]Controller.lua
      └── ClientConfig.lua
  ```

### **HUKUM 8: No init.lua**

- **DILARANG** file bernama `init.lua`
- Gunakan nama deskriptif: `Bootstrap.lua`, `Kernel.lua`, `ServerRuntime.server.lua`
- Alasan: Clarity, explicit is better than implicit

### **HUKUM 9: Explicit Paths**

- Gunakan `game:GetService()` atau path traversal eksplisit
- **DILARANG `script.Parent` berlebihan**
- Alasan: Maintainability, refactoring-proof

### **HUKUM 10: Luau Compatibility**

- Gunakan sintaks Luau yg valid
- Contoh WRONG: `table.size()` (tidak ada di Luau)
- Contoh RIGHT: Manual count dengan `for k,v in pairs(t)`

### **HUKUM 11: Mandatory Code Header V1.0.0**

- **SEMUA file `.lua` WAJIB** punya header:
  ```lua
  --[[
  OVHL ENGINE V1.0.0
  @Component: [ComponentName] ([Category])
  @Path: [Full.Path.To.Module]
  @Purpose: [One sentence]
  @Stability: [STABLE/BETA/EXPERIMENTAL]
  --]]
  ```

### **HUKUM 12: Mandatory Code Footer V1.0.0**

- **SEMUA file `.lua` WAJIB** punya footer:
  ```lua
  --[[
  @End: [FileName].lua
  @Version: 1.0.0
  @LastUpdate: [YYYY-MM-DD]
  @Maintainer: [Name or "OVHL Core Team"]
  --]]
  ```

---

## 2. STRUKTUR DIREKTORI PRODUKSI (V1.0.0)

(Struktur ini match dengan `snapshot-20251118_121113.md`)

```text
src/
├── ReplicatedStorage/
│   └── OVHL/
│       ├── Config/                 # Global configuration
│       │   ├── EngineConfig.lua
│       │   └── LoggerConfig.lua
│       │
│       ├── Core/                   # Black box - jangan diubah dari Modules/
│       │   ├── Bootstrap.lua       # [ENTRY] Scanner & System Discovery
│       │   ├── Kernel.lua          # [ENTRY] Module Loader & Knit Bridge
│       │   ├── OVHL.lua            # [API] Public Gateway
│       │   └── SystemRegistry.lua  # [ORCHESTRATOR] 4-Phase Lifecycle
│       │
│       ├── Systems/                # Engine core technologies
│       │   ├── Foundation/         # Basics (Logger, ConfigLoader)
│       │   │   ├── SmartLogger.lua
│       │   │   ├── SmartLoggerManifest.lua
│       │   │   ├── ConfigLoader.lua
│       │   │   ├── ConfigLoaderManifest.lua
│       │   │   └── StudioFormatter.lua
│       │   │
│       │   ├── Security/           # Security layer (Validator, RateLimiter, Permission)
│       │   │   ├── InputValidator.lua
│       │   │   ├── InputValidatorManifest.lua
│       │   │   ├── RateLimiter.lua
│       │   │   ├── RateLimiterManifest.lua
│       │   │   ├── PermissionCore.lua
│       │   │   ├── PermissionCoreManifest.lua
│       │   │   └── SecurityHelper.lua
│       │   │
│       │   ├── Networking/         # Network layer (Router, RemoteBuilder)
│       │   │   ├── NetworkingRouter.lua
│       │   │   ├── NetworkingRouterManifest.lua
│       │   │   ├── NetworkSecurity.lua
│       │   │   └── RemoteBuilder.lua
│       │   │
│       │   ├── UI/                 # UI frameworks (Engine, Manager, AssetLoader)
│       │   │   ├── UIEngine.lua
│       │   │   ├── UIEngineManifest.lua
│       │   │   ├── UIManager.lua
│       │   │   ├── UIManagerManifest.lua
│       │   │   ├── AssetLoader.lua
│       │   │   └── AssetLoaderManifest.lua
│       │   │
│       │   └── Advanced/           # Complex systems (DataManager, PlayerManager, NotificationService)
│       │       ├── DataManager.lua
│       │       ├── DataManagerManifest.lua
│       │       ├── PlayerManager.lua
│       │       ├── PlayerManagerManifest.lua
│       │       ├── NotificationService.lua
│       │       └── NotificationServiceManifest.lua
│       │
│       ├── Types/                  # Type definitions (Luau)
│       │   ├── CoreTypes.lua
│       │   └── ScannerContract.lua
│       │
│       └── Shared/Modules/         # Game Modules (Shared config)
│           ├── Global/
│           │   └── Constants.lua
│           └── [ModuleName]/
│               └── SharedConfig.lua
│
├── ServerScriptService/
│   └── OVHL/
│       ├── ServerRuntime.server.lua    # Entry point server
│       └── Modules/                    # Game Modules (Server part)
│           └── [ModuleName]/
│               ├── [Name]Service.lua
│               └── ServerConfig.lua
│
└── StarterPlayer/StarterPlayerScripts/
    └── OVHL/
        ├── ClientRuntime.client.lua    # Entry point client
        └── Modules/                    # Game Modules (Client part)
            └── [ModuleName]/
                ├── [Name]Controller.lua
                └── ClientConfig.lua
```

---

## 3. TECHNOLOGY STACK (V1.0.0)

- **Framework:** [Knit v1.7.0+](https://sleitnick.github.io/Knit/) - Service/Controller architecture
- **UI Library:** [Fusion v0.3.0](https://elttob.uk/Fusion/) - Reactive UI (Luau-native)
- **UI Rule:** Hanya `Fusion` (Programmatic) dan `Native` (Fallback). ~~Plasma dihapus~~.
- **Testing:** Testez (built-in Roblox)
- **Version Control:** Git (standard workflow)

---

## 4. SISTEM INTI (CORE SYSTEMS)

### **Bootstrap (`Core/Bootstrap.lua`)**

- Auto-discovery sistem di `Systems/` via `*Manifest.lua` files
- Environment-aware (detect Server vs Client context)
- Fallback ke V3.1.0 legacy systems jika manifest belum ada
- **Keluaran:** Daftar `SystemManifest` untuk SystemRegistry

### **Kernel (`Core/Kernel.lua`)**

- Auto-discovery modul di `Modules/` folder
- Scan `*Service.lua` (server) dan `*Controller.lua` (client)
- Bridge ke Knit.CreateService / Knit.CreateController
- **Keluaran:** Knit services/controllers teregistrasi

### **SystemRegistry (`Core/SystemRegistry.lua`)**

- **Orchestrator** untuk 4-Phase Lifecycle:
  1. **Initialize**: Construct all systems + call `:Initialize(logger)`
  2. **Register**: Register systems ke OVHL gateway (enable `OVHL:GetSystem()`)
  3. **Start**: Call `:Start()` pada semua systems (safe untuk `OVHL:GetSystem()`)
  4. **Destroy**: Call `:Destroy()` dalam **reverse order** saat `game:BindToClose()` (cleanup memory, events, etc)
- **Topological Sort:** Resolve dependensi system menggunakan depth-first search
- **Error Handling:** Stop boot jika ada circular dependency atau missing dependency

### **OVHL Gateway (`Core/OVHL.lua`)**

- Public API untuk game logic:
  - `OVHL:GetSystem(name)` - Get system instance
  - `OVHL:GetConfig(moduleName, key?, context?)` - Resolve layered config
  - `OVHL:ValidateInput(schemaName, data)` - Input validation
  - `OVHL:CheckPermission(player, node)` - Permission check
  - `OVHL:CheckRateLimit(player, action)` - Rate limit check

---

## 5. SECURITY PIPELINE (3 PILAR)

Setiap request dari client ke server **HARUS** lewat:

```
CLIENT REQUEST
    ↓
    ├─→ [1] InputValidator (Schema check)
    │       Gunakan: SharedConfig.lua → ValidationSchemas
    │
    ├─→ [2] RateLimiter (Spam check)
    │       Gunakan: SharedConfig.lua → RateLimits
    │
    ├─→ [3] PermissionCore (Rank/Access check)
    │       Gunakan: SharedConfig.lua → Permissions
    │
    └─→ [OK] Business Logic (execute)
            [FAIL] Return error to client
```

**Pattern di Knit Service:**

```lua
function MyService:ProcessAction(player, actionData)
    -- 1. Validasi
    local valid, err = self.InputValidator:Validate("ActionData", actionData)
    if not valid then return false, err end

    -- 2. Rate limit
    if not self.RateLimiter:Check(player, "DoAction") then return false, "Spam" end

    -- 3. Permission
    if not self.PermissionCore:Check(player, "ModuleName.ActionName") then return false, "No access" end

    -- 4. Business logic
    return self:_executeLogic(player, actionData)
end
```

---

## 6. 4-PHASE LIFECYCLE (ADR-004, V1.0.0 Standard)

**Semua system harus patuh pattern ini:**

| Fase  | Method                 | Tujuan                                          | Constraints                                                                     |
| ----- | ---------------------- | ----------------------------------------------- | ------------------------------------------------------------------------------- |
| **1** | `:Initialize(logger)`  | Setup logger, init variables                    | ❌ Jangan `OVHL:GetSystem()` / ❌ Jangan `Connect()` / ❌ Jangan `task.spawn()` |
| **2** | _(otomatis, internal)_ | Register sistem ke OVHL gateway                 | _(hidden dari system)_                                                          |
| **3** | `:Start()`             | Resolve dependensi, connect events, start tasks | ✅ BOLEH `OVHL:GetSystem()` / ✅ BOLEH `Connect()` / ✅ BOLEH `task.spawn()`    |
| **4** | `:Destroy()`           | Cleanup (optional jika system active)           | ✅ Stop loop / ✅ Disconnect events / ✅ Save data                              |

**Contoh:**

```lua
local DataManager = {}

function DataManager.new()
    local self = setmetatable({}, DataManager)
    self._logger = nil
    self._dataStore = nil
    self._isRunning = false
    return self
end

-- FASE 1: Initialize
function DataManager:Initialize(logger)
    self._logger = logger
    -- Setup only, no external calls
end

-- FASE 3: Start
function DataManager:Start()
    local OVHL = require(...)
    self._dataStore = DataStoreService:GetDataStore("PlayerData")
    self._isRunning = true
    self._logger:Info("DATAMANAGER", "Ready")
end

-- FASE 4: Destroy (jika ada background task)
function DataManager:Destroy()
    self._isRunning = false
    self._logger:Info("DATAMANAGER", "Shutdown")
end

return DataManager
```

---

## 7. MODULE PATTERN (GOLDEN STANDARD)

Lihat `201_CONTRIBUTING_MODULE.md` untuk detail. Ringkas:

- **Server Service:** `[Name]Service.lua`

  - `KnitInit()`: Resolve dependensi
  - `KnitStart()`: Mulai logic
  - Client method: `self.Client:MethodName(player, data)`

- **Client Controller:** `[Name]Controller.lua`

  - `KnitInit()`: Get systems + service
  - `KnitStart()`: Setup UI + input
  - Server call: `self.Service:MethodName(data)`

- **3-Config:** Wajib 3 file:
  - `SharedConfig.lua`: Kontrak (schema, izin, rate limit)
  - `ServerConfig.lua`: Rahasia (API keys, db creds)
  - `ClientConfig.lua`: Preferensi (keybinds, theme)

---

## 8. ERROR HANDLING & RECOVERY

### **Error Classification**

- **Level 1 (Non-critical):** Fallback tersedia, log warning.
  - Contoh: Asset gagal load → gunakan placeholder
- **Level 2 (Module-specific):** Isolasi kegagalan, jangan crash engine.
  - Contoh: Service gagal init → skip service, continue boot
- **Level 3 (System-wide):** Degradasi ke mode fallback.
  - Contoh: DataManager gagal koneksi → use in-memory cache
- **Level 4 (Critical):** Emergency recovery + notification.
  - Contoh: SystemRegistry circular dependency → stop boot, crash dengan log jelas

### **Layered Error Handling**

- **Layer 1: Input Validation (Modules)**
  - `assert(typeof(param) == "string", "Invalid type")`
- **Layer 2: System-Level Recovery (Core)**
  - `pcall()` saat `require()` sistem
  - Fallback ke legacy system jika baru gagal
- **Layer 3: Network Resilience (Router)**
  - Retry dengan exponential backoff
  - Graceful degradation jika koneksi down

---

## 9. PERFORMANCE & OPTIMIZATION

### **Performance Budget**

- **Frame Time Impact:** ≤5ms maksimum per frame
- **Memory Usage:** Kontrol pertumbuhan dengan lazy loading
- **Load Time:** <3 detik inisialisasi engine

### **Optimization Strategies**

- **Lazy Loading:** Modul di-load saat dibutuhkan (Kernel)
- **Object Pooling:** (Roadmap V1.1.0+) Reuse instances
- **Batched Operations:** Kirim update ganda dalam satu RemoteEvent call
- **Performance Monitoring:** (Roadmap V1.1.0+) Detect operasi lambat

---

## 10. TESTING STRATEGY

### **Test Types**

- **Unit Tests:** Tes fungsi individual (misal: SmartLogger.spec.lua)
- **Integration Tests:** Tes interaksi antar sistem (misal: SecurityPipeline)
- **E2E Tests:** Tes workflow penuh (misal: UserJoin → DataLoad → Action → DataSave)

### **Test Structure**

```text
tests/
├── Unit/
│   ├── SmartLogger.spec.lua
│   ├── InputValidator.spec.lua
│   └── RateLimiter.spec.lua
├── Integration/
│   ├── SecurityPipeline.spec.lua
│   └── SystemRegistry.spec.lua
└── E2E/
    └── UserJoinFlow.spec.lua
```

---

## 11. DOCUMENTATION STANDARDS (V1.0.0)

- **Code Standard:** Header/Footer V1.0.0 (Hukum #11 & #12)
- **Module Docs:** Modul gameplay wajib documented di `201_CONTRIBUTING_MODULE.md`
- **System Docs:** Sistem engine wajib punya file API sendiri di `210_API_REFERENCE/`
- **Architecture Docs:** Keputusan besar logged di `302_ADR_LOG.md`

---

## 12. ROADMAP PHASES (Preview)

### **V1.0.0 (CURRENT - Stable Release)**

- ✅ 4-Phase Lifecycle
- ✅ Foundation systems (Logger, Config)
- ✅ Security pipeline
- ✅ Networking (basic)
- ✅ UI (Fusion + Native)
- ✅ DataManager + PlayerManager

### **V1.1.0 (Planned)**

- Adapter Pattern (config-driven, PermissionCore + UIManager)
- StateManager (Redux-like state management)
- Enhanced NetworkingRouter (SendToAllClients, retry logic)
- Performance monitoring

### **V1.2.0 (Planned)**

- Object pooling
- Advanced optimization
- Extended test coverage

### **V2.0.0 (Future - Breaking Changes)**

- Modular loading (load systems on-demand)
- Advanced security (OAuth, SSO)
- Analytics + telemetry

---

> END OF ./docs/100_ENGINE_GUIDES/101_GENESIS_ARCHITECTURE.md
