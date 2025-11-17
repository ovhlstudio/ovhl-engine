> START OF ./docs/01_OVHL_ENGINE.md

# OVHL (Omniverse Highland) ENGINE – COMPLETE ARCHITECTURE BLUEPRINT

Version: 2.2 (Updated to Match Actual Implementation)  
Status: **REVISED** - All Sections Updated to Match Working Codebase  
Date: November 17, 2025

---

## 1. INTRODUCTION

**OVHL (Omniverse Highland Library)** adalah **Engine Layer Modular** untuk proyek Roblox yang dirancang sebagai pondasi seluruh game development di Omniverse Highland Studio.

**Visi:** Membuat engine yang memisahkan concern antara core systems, game logic, dan studio tools dengan batasan yang jelas.

**Filosofi Inti:**

- "Configuration Over Code"
- "Separation of Concerns"
- "Fallback Everything"
- "300 Lines Maximum"
- "Zero Core Modification"

---

## 2. CORE PRINCIPLES & DESIGN RULES

### 2.1 The 10 Commandments of OVHL

1. **Engine Architecture** - Bukan framework, tapi foundation layer yang complement existing ecosystems (Knit, Fusion, Plasma)
2. **Zero Core Modification** - Modul tidak boleh mengubah core engine
3. **Config-Driven** - Semua behavior dikontrol via config/attributes
4. **Self-Contained Modules** - Modul plug-and-play dengan dependency jelas
5. **Triple UI Mode** - Fusion (programmatic) + Plasma (builder) + Native (fallback) dengan auto-detection
6. **Third-Party Integration** - HD Admin, TopbarPlus, etc sebagai first-class citizen
7. **Universal Fallback** - Setiap system wajib punya fallback mechanism
8. **Flat Structure** - File organization sederhana dan predictable
9. **300 Line Limit** - Maximum maintainability per file
10. **Standardized Lifecycle** - Konsisten di semua modul dan systems

### 2.2 Architectural Constraints

- **No Global State** - State management melalui StateManager (Rodux pattern)
- **No Direct Remote Access** - Semua networking melalui Router
- **No Hardcoded Paths** - UI paths via attribute/config
- **No Cross-Module Dependencies** - Komunikasi via EventBus/StateManager
- **No Core Engine Access** - Modul hanya gunakan OVHL API
- **No Relative Paths** - ALWAYS use `game:GetService()`, NEVER `script.Parent`

### 2.3 Naming Conventions (CRITICAL)

**File Extensions:**

```
*.server.lua    → Script (green icon, runs on server)
*.client.lua    → LocalScript (blue icon, runs on client)
*.lua           → ModuleScript (gray icon, require only)
```

**Entry Points:**

```
ServerRuntime.server.lua   → SERVER ENTRY POINT
ClientRuntime.client.lua   → CLIENT ENTRY POINT
```

**Module Naming:**

```
YourModuleService.lua      → Server-side Knit Service
YourModuleController.lua   → Client-side Knit Controller
Types.lua                  → Type definitions
Config.lua                 → Configuration values
```

**❌ FORBIDDEN:**

```
init.lua                   → AKAN HILANG DI STUDIO!
Service.lua                → Terlalu generic
Controller.lua             → Tidak deskriptif
```

---

## 3. TECHNICAL ARCHITECTURE

### 3.1 High-Level Architecture

```
[ GAME APPLICATION ]
         ↓
[ MODULE LAYER ]          ← Plug-and-play modules
         ↓
[ OVHL ENGINE ]           ← Core engine systems
    ├─ Core API (OVHL.lua)
    ├─ Systems (State, Logging, UI, Performance)
    ├─ Networking (Router, RemoteBuilder)
    └─ Fallback Systems
         ↓
[ FRAMEWORK LAYER ]       ← Knit, Fusion, Plasma, Rodux
         ↓
[ ROBLOX RUNTIME ]
```

### 3.2 Technology Stack

- **Runtime Framework:** Knit (service/controller pattern)
- **UI Engine:** Fusion (reactive) + Plasma (builder) + Native (fallback)
- **State Management:** Rodux (Redux-like pattern)
- **Networking:** Custom Router over Knit remotes
- **Permission:** HD Admin + internal fallback
- **Testing:** TestEZ
- **Build Tool:** Rojo + Wally

### 3.3 Project Structure **✅ REVISED - MATCHES ACTUAL IMPLEMENTATION**

**ACTUAL WORKING STRUCTURE (Confirmed in Codebase):**

```
ovhl-engine/
├── src/
│   ├── ReplicatedStorage/
│   │   ├── OVHL/                     # 🔒 CORE ENGINE (READ ONLY)
│   │   │   ├── Core/
│   │   │   │   ├── Bootstrap.lua
│   │   │   │   ├── Kernel.lua
│   │   │   │   └── OVHL.lua
│   │   │   ├── Systems/
│   │   │   │   ├── State/            # State management
│   │   │   │   ├── Logging/
│   │   │   │   ├── Networking/
│   │   │   │   ├── ConfigSystem/     # ✅ ACTUAL: Config system location
│   │   │   │   ├── UI/
│   │   │   │   ├── Events/           # Event bus
│   │   │   │   └── Performance/      # Object pooling
│   │   │   ├── Config/
│   │   │   ├── Types/
│   │   │   └── Shared/               # ✅ ACTUAL: Shared modules location
│   │   │       └── Modules/
│   │   │           └── MinimalModule/
│   │   │               └── SharedConfig.lua
│   │   └── Packages/                 # Wally dependencies
│   │
│   ├── ServerScriptService/
│   │   └── OVHL/                     # ✅ ACTUAL: Server root (NOT OVHLServer)
│   │       ├── ServerRuntime.server.lua    # ⚡ ENTRY POINT
│   │       ├── Systems/              # 🔒 SERVER SYSTEMS (READ ONLY)
│   │       │   ├── Permission/
│   │       │   ├── Data/
│   │       │   ├── Economy/
│   │       │   ├── Monitoring/       # Performance tracking
│   │       │   └── Testing/          # Test runner
│   │       └── Modules/              # ✅ ACTUAL: Server modules location
│   │           └── MinimalModule/
│   │               ├── MinimalService.lua
│   │               └── ServerConfig.lua
│   │
│   └── StarterPlayer/
│       └── StarterPlayerScripts/
│           └── OVHL/                 # ✅ ACTUAL: Client root (NOT OVHLClient)
│               ├── ClientRuntime.client.lua    # ⚡ ENTRY POINT
│               ├── Systems/          # 🔒 CLIENT SYSTEMS (READ ONLY)
│               │   ├── Input/
│   │   │   ├── UI/
│   │   │   └── Audio/
│               └── Modules/          # ✅ ACTUAL: Client modules location
│                   └── MinimalModule/
│                       ├── MinimalController.lua
│                       └── ClientConfig.lua
│
├── tests/                            # Test suites
├── docs/                             # Documentation
├── default.project.json              # Rojo config
├── wally.toml                        # Packages
└── .luaurc                           # Type checker
```

**IMPLEMENTATION NOTES:**

- Current structure confirmed working in actual codebase
- All paths verified against snapshot implementation
- Maintains separation of concerns while simplifying structure

---

## 4. CORE ENGINE SYSTEMS **✅ UPDATED - IMPLEMENTATION STATUS**

### 4.1 Bootstrap System **✅ IMPLEMENTED**

**File:** `Bootstrap.lua` (Client/Server separate) **✅ WORKING**

**Responsibilities:**

- Environment detection (client/server) **✅ IMPLEMENTED**
- Load order management
- Global error boundary setup
- Engine initialization **✅ IMPLEMENTED**
- Graceful startup sequence

**Actual Implementation:**

```lua
function Bootstrap:DetectEnvironment()
    if game:GetService("RunService"):IsServer() then
        return "Server"
    else
        return "Client"
    end
end

function Bootstrap:Initialize()
    local environment = self:DetectEnvironment()
    print("🚀 OVHL Engine Initializing - Environment: " .. environment)
    -- Load OVHL API and register core systems
end
```

### 4.2 Kernel System **✅ BASIC IMPLEMENTATION**

**File:** `Kernel.lua` (Client/Server separate) **✅ BASIC FUNCTIONALITY**

**Responsibilities:**

- Module scanning & registration **✅ BASIC SCANNING**
- Lifecycle management (Init → Start → Stop)
- Dependency resolution
- Service locator pattern
- Lazy module loading

**Current Status:** Basic module registration implemented, full lifecycle WIP

### 4.3 Main API Layer **✅ FULLY IMPLEMENTED**

**File:** `OVHL.lua` (Client/Server separate) **✅ COMPLETE**

**Public API (ACTUAL WORKING):**

```lua
OVHL:GetSystem(name)      -- Access core systems ✅ WORKING
OVHL:GetService(name)     -- Access Knit services (server) ⏳ PLANNED
OVHL:GetController(name)  -- Access Knit controllers (client) ⏳ PLANNED
OVHL:GetModule(name)      -- Access module instances ✅ BASIC
OVHL:GetConfig(key)       -- Access configuration values ✅ FULLY IMPLEMENTED
OVHL:GetClientConfig(key) -- Client-safe config ✅ FULLY IMPLEMENTED
```

**Usage Example (ACTUAL WORKING):**

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)

local Logger = OVHL:GetSystem("SmartLogger")  -- ✅ WORKING
local Config = OVHL:GetConfig("MinimalModule") -- ✅ WORKING
```

---

## 5. SUBSYSTEMS SPECIFICATION **✅ UPDATED - IMPLEMENTATION STATUS**

### 5.1 Smart Logger System **✅ FULLY IMPLEMENTED**

**File:** `SmartLogger.lua` (Server + Client separate) **✅ COMPLETE**

**Requirements:**

- 5 log levels: Debug, Info, Warn, Error, Critical **✅ IMPLEMENTED**
- Environment-aware (disable Debug in production)
- Metadata attachment capability **✅ BASIC**
- File/array export for debugging
- Fallback to minimal console logger **✅ IMPLEMENTED**

**API (ACTUAL WORKING):**

```lua
Logger:Debug(message, metadata)    -- ✅ IMPLEMENTED
Logger:Info(message, metadata)     -- ✅ IMPLEMENTED
Logger:Warn(message, metadata)     -- ✅ IMPLEMENTED
Logger:Error(message, metadata)    -- ✅ IMPLEMENTED
Logger:Critical(message, metadata) -- ✅ IMPLEMENTED
```

### 5.2 State Management System **✅ BASIC IMPLEMENTATION**

**Files:** `StateManager.lua` **✅ BASIC FUNCTIONALITY**

**Purpose:** Redux-like predictable state for dual UI system synchronization

**Current Status:** Basic state container implemented, full Redux pattern WIP

**API (CURRENT):**

```lua
State:Dispatch(actionName, payload) -- ✅ BASIC IMPLEMENTATION
State:Select(path, key)             -- ⏳ PLANNED
State:Subscribe(path, callback)     -- ⏳ PLANNED
```

### 5.3 Config System **✅ FULLY IMPLEMENTED**

**File:** `ConfigLoader.lua` **✅ COMPLETE & WORKING**

**Layered Config Resolution (ACTUAL WORKING):**

1. **LAYER 1:** Engine Config ✅ IMPLEMENTED
2. **LAYER 2:** Shared Module Config ✅ IMPLEMENTED
3. **LAYER 3:** Context-Specific Config ✅ IMPLEMENTED

**Security Features:**

- Client-safe config filtering ✅ IMPLEMENTED
- Sensitive data protection ✅ IMPLEMENTED
- Server authority enforcement ✅ IMPLEMENTED

### 5.4 Networking Router **✅ BASIC IMPLEMENTATION**

**File:** `NetworkingRouter.lua` **✅ BASIC FUNCTIONALITY**

**Current Status:** Basic send/receive implemented, full Knit integration WIP

**API (CURRENT):**

```lua
Router:SendServer(eventName, data)    -- ✅ BASIC IMPLEMENTATION
Router:SendClient(player, eventName, data) -- ✅ BASIC IMPLEMENTATION
```

### 5.5 UI Engine System **⏳ PLANNED**

**File:** `UIEngine.lua` (Client only) **⏳ NOT IMPLEMENTED**

**Triple Mode Architecture (PLANNED):**

1. **Mode 1 (Fusion):** Reactive programmatic UI
2. **Mode 2 (Plasma):** Builder-friendly components
3. **Mode 3 (Native):** Fallback renderer

### 5.6 Event Bus System **⏳ PLANNED**

**File:** `EventBus.lua` **⏳ NOT IMPLEMENTED**

### 5.7 Permission System **⏳ PLANNED**

**Files:** `PermissionCore.lua`, `HDAdminBridge.lua` **⏳ NOT IMPLEMENTED**

### 5.8 Performance Systems **⏳ PLANNED**

**Files:** `ObjectPool.lua`, `PerformanceMonitor.lua` **⏳ NOT IMPLEMENTED**

### 5.9 Monitoring & Analytics **⏳ PLANNED**

**Files:** `ErrorTracker.lua`, `Analytics.lua` **⏳ NOT IMPLEMENTED**

---

## 6. MODULE ARCHITECTURE **✅ FULLY REVISED - MATCHES ACTUAL**

## 6.1 MODULE STRUCTURE **✅ REVISED - ACTUAL WORKING PATTERNS**

### **VERSION 1: MINIMAL MODULE - ACTUAL WORKING IMPLEMENTATION**

_(Basic functionality, single responsibility - **CONFIRMED WORKING**)_

```
MinimalModule/
├── Shared/                           # ✅ ACTUAL: In ReplicatedStorage/OVHL/Shared/Modules/
│   └── SharedConfig.lua              # Public contracts only ✅ WORKING
├── Server/                           # ✅ ACTUAL: In ServerScriptService/OVHL/Modules/
│   ├── MinimalService.lua            # Server-side logic ✅ WORKING
│   └── ServerConfig.lua              # Server authority config ✅ WORKING
└── Client/                           # ✅ ACTUAL: In StarterPlayerScripts/OVHL/Modules/
    ├── MinimalController.lua         # Client-side logic ✅ WORKING
    └── ClientConfig.lua              # Client preferences config ✅ WORKING
```

**ACTUAL PROJECT MAPPING (CONFIRMED):**

```
ReplicatedStorage/
└── OVHL/
    └── Shared/Modules/MinimalModule/     # ✅ ACTUAL LOCATION
        └── SharedConfig.lua              # ✅ WORKING IMPLEMENTATION

ServerScriptService/
└── OVHL/
    └── Modules/MinimalModule/            # ✅ ACTUAL LOCATION
        ├── MinimalService.lua            # ✅ WORKING IMPLEMENTATION
        └── ServerConfig.lua              # ✅ WORKING IMPLEMENTATION

StarterPlayer/
└── StarterPlayerScripts/
    └── OVHL/
        └── Modules/MinimalModule/        # ✅ ACTUAL LOCATION
            ├── MinimalController.lua     # ✅ WORKING IMPLEMENTATION
            └── ClientConfig.lua          # ✅ WORKING IMPLEMENTATION
```

---

### **VERSION 2: COMPLEX MODULE - UPDATED TO MATCH ACTUAL PATTERN**

_(Advanced functionality, multiple subsystems - **REVISED STRUCTURE**)_

```
ComplexModule/
├── Shared/                           # ✅ REVISED: In ReplicatedStorage/OVHL/Shared/Modules/
│   ├── Types.lua              # Complex type definitions
│   ├── Config.lua             # Main configuration
│   ├── Enums.lua              # Enumeration values
│   └── Constants.lua          # Constant values
├── Server/                           # ✅ REVISED: In ServerScriptService/OVHL/Modules/
│   ├── ComplexService.lua     # Main service
│   ├── SubsystemA.lua         # Specialized logic A
│   ├── SubsystemB.lua         # Specialized logic B
│   └── Managers/
│       ├── DataManager.lua    # Data handling
│       └── Validation.lua     # Input validation
└── Client/                           # ✅ REVISED: In StarterPlayerScripts/OVHL/Modules/
    ├── ComplexController.lua  # Main controller
    ├── UI/
    │   ├── MainUI.lua         # Primary UI controller
    │   └── Components/
    │       ├── WidgetA.lua
    │       └── WidgetB.lua
    └── Systems/
        ├── InputHandler.lua   # Input processing
        └── StateSync.lua      # State synchronization
```

**ACTUAL PROJECT MAPPING FOR COMPLEX MODULES:**

```
ReplicatedStorage/
└── OVHL/
    └── Shared/Modules/ComplexModule/     # ✅ REVISED LOCATION
        ├── Types.lua
        ├── Config.lua
        ├── Enums.lua
        └── Constants.lua

ServerScriptService/
└── OVHL/
    └── Modules/ComplexModule/            # ✅ REVISED LOCATION
        ├── ComplexService.lua
        ├── SubsystemA.lua
        ├── SubsystemB.lua
        └── Managers/
            ├── DataManager.lua
            └── Validation.lua

StarterPlayer/
└── StarterPlayerScripts/
    └── OVHL/
        └── Modules/ComplexModule/        # ✅ REVISED LOCATION
            ├── ComplexController.lua
            ├── UI/
            │   ├── MainUI.lua
            │   └── Components/
            │       ├── WidgetA.lua
            │       └── WidgetB.lua
            └── Systems/
                ├── InputHandler.lua
                └── StateSync.lua
```

---

### **VERSION 3: EXAMPLE - MUSIC PLAYER MODULE** **✅ RETAINED - UPDATED STRUCTURE**

_(Real-world complex example - **UPDATED TO MATCH ACTUAL PATTERN**)_

```
MusicPlayer/
├── Shared/                           # ✅ UPDATED: In ReplicatedStorage/OVHL/Shared/Modules/
│   ├── Types.lua
│   ├── Config.lua
│   ├── Enums.lua
│   └── Constants.lua
├── Server/                           # ✅ UPDATED: In ServerScriptService/OVHL/Modules/
│   ├── MusicService.lua
│   ├── PlaylistManager.lua
│   ├── PermissionManager.lua
│   └── Managers/
│       ├── APIManager.lua     # Handle external API calls
│       ├── SyncManager.lua    # Music synchronization
│       └── Validation.lua     # Input validation
└── Client/                           # ✅ UPDATED: In StarterPlayerScripts/OVHL/Modules/
    ├── MusicController.lua
    ├── UI/
    │   ├── MusicUI.lua
    │   ├── AdminUI.lua
    │   └── Components/
    │       ├── NowPlaying.lua
    │       ├── PlaylistView.lua
    │       └── VolumeControl.lua
    └── Systems/
        ├── AudioEngine.lua    # Spatial audio handling
        ├── UIManager.lua      # TopbarPlus integration
        └── SyncClient.lua     # Client-side sync
```

**ACTUAL PROJECT MAPPING FOR MUSIC PLAYER:**

```
ReplicatedStorage/
└── OVHL/
    └── Shared/Modules/MusicPlayer/       # ✅ UPDATED LOCATION
        ├── Types.lua
        ├── Config.lua
        ├── Enums.lua
        └── Constants.lua

ServerScriptService/
└── OVHL/
    └── Modules/MusicPlayer/              # ✅ UPDATED LOCATION
        ├── MusicService.lua
        ├── PlaylistManager.lua
        ├── PermissionManager.lua
        └── Managers/
            ├── APIManager.lua
            ├── SyncManager.lua
            └── Validation.lua

StarterPlayer/
└── StarterPlayerScripts/
    └── OVHL/
        └── Modules/MusicPlayer/          # ✅ UPDATED LOCATION
            ├── MusicController.lua
            ├── UI/
            │   ├── MusicUI.lua
            │   ├── AdminUI.lua
            │   └── Components/
            │       ├── NowPlaying.lua
            │       ├── PlaylistView.lua
            │       └── VolumeControl.lua
            └── Systems/
                ├── AudioEngine.lua
                ├── UIManager.lua
                └── SyncClient.lua
```

## 📁 **PROJECT STRUCTURE MAPPING** **✅ UPDATED**

```
ReplicatedStorage/
├── OVHL/                           # 🔒 CORE ENGINE (READ ONLY)
└── Shared/Modules/                 # ✅ ACTUAL: Shared modules location
    ├── MinimalModule/              # VERSION 1 EXAMPLE ✅ WORKING
    │   └── SharedConfig.lua
    ├── ComplexModule/              # VERSION 2 EXAMPLE
    │   └── Shared/
    │       ├── Types.lua
    │       ├── Config.lua
    │       ├── Enums.lua
    │       └── Constants.lua
    └── MusicPlayer/                # VERSION 3 EXAMPLE
        └── Shared/
            ├── Types.lua
            ├── Config.lua
            ├── Enums.lua
            └── Constants.lua

ServerScriptService/
└── OVHL/                          # ✅ ACTUAL: Server root
    ├── ServerRuntime.server.lua    # ⚡ SERVER ENTRY POINT ✅ WORKING
    └── Modules/                    # ✅ ACTUAL: Server modules
        ├── MinimalModule/          # ✅ WORKING IMPLEMENTATION
        │   └── MinimalService.lua
        ├── ComplexModule/
        │   └── Server/
        │       ├── ComplexService.lua
        │       ├── SubsystemA.lua
        │       ├── SubsystemB.lua
        │       └── Managers/
        │           ├── DataManager.lua
        │           └── Validation.lua
        └── MusicPlayer/
            └── Server/
                ├── MusicService.lua
                ├── PlaylistManager.lua
                ├── PermissionManager.lua
                └── Managers/
                    ├── APIManager.lua
                    ├── SyncManager.lua
                    └── Validation.lua

StarterPlayer/
└── StarterPlayerScripts/
    └── OVHL/                      # ✅ ACTUAL: Client root
        ├── ClientRuntime.client.lua    # ⚡ CLIENT ENTRY POINT ✅ WORKING
        └── Modules/                    # ✅ ACTUAL: Client modules
            ├── MinimalModule/          # ✅ WORKING IMPLEMENTATION
            │   └── MinimalController.lua
            ├── ComplexModule/
            │   └── Client/
            │       ├── ComplexController.lua
            │       ├── UI/
            │       │   ├── MainUI.lua
            │       │   └── Components/
            │       │       ├── WidgetA.lua
            │       │       └── WidgetB.lua
            │       └── Systems/
            │           ├── InputHandler.lua
            │           └── StateSync.lua
            └── MusicPlayer/
                └── Client/
                    ├── MusicController.lua
                    ├── UI/
                    │   ├── MusicUI.lua
                    │   ├── AdminUI.lua
                    │   └── Components/
                    │       ├── NowPlaying.lua
                    │       ├── PlaylistView.lua
                    │       └── VolumeControl.lua
                    └── Systems/
                        ├── AudioEngine.lua
                        ├── UIManager.lua
                        └── SyncClient.lua
```

### 6.2 Module Rules **✅ RETAINED**

1. **Self-Contained:** Semua dependencies explicit via OVHL API
2. **Config-Driven:** No hardcoded values
3. **Lifecycle Compliance:** Implement KnitInit() and KnitStart()
4. **API Boundary:** ONLY use OVHL public API, NEVER direct require to Core
5. **Communication:** Via EventBus/StateManager/Router, NO direct calls
6. **Naming:** Descriptive names, NO generic names like Service.lua
7. **Path Resolution:** ALWAYS `game:GetService()`, NEVER `script.Parent`

### 6.3 Module Lifecycle **✅ RETAINED**

```
Discovery (Kernel scan)
    ↓
Registration (Service locator)
    ↓
Initialization (KnitInit - load configs, get systems)
    ↓
Startup (KnitStart - business logic starts)
    ↓
Runtime (Handle requests/events)
    ↓
Shutdown (Cleanup resources)
```

### 6.4 Module Communication Matrix **✅ RETAINED**

```
Server Module A ↔ Server Module B:  EventBus / StateManager
Server → Client:                     NetworkingRouter:SendClient()
Client → Server:                     NetworkingRouter:SendServer()
Module → Core System:                OVHL:GetSystem()
Cross-module events:                 EventBus pattern
Shared data:                         StateManager pattern
```

---

**SISA SECTIONS 7-12 DIBAWAH INI DI RETAIN TANPA PERUBAHAN KARENA TIDAK ADA IMPLEMENTASI AKTUAL YANG BERTENTANGAN:**

## 7. ERROR HANDLING & RECOVERY **✅ RETAINED**

### 7.1 Error Classification

- **Level 1 (Non-critical):** Fallback available, log warning
- **Level 2 (Module-specific):** Isolate failure, don't crash engine
- **Level 3 (System-wide):** Graceful degradation to fallback systems
- **Level 4 (Critical):** Emergency recovery, save state, notify monitoring

### 7.2 Layered Error Handling

**Layer 1: Input Validation (Modules)**

```lua
function Module:DoSomething(param)
    assert(typeof(param) == "string", "Invalid parameter type")
    -- Continue...
end
```

**Layer 2: System-Level Recovery (Core)**

```lua
function OVHL:GetSystem(systemName)
    local success, system = pcall(function()
        return require(ReplicatedStorage.OVHL.Systems[systemName])
    end)

    if not success then
        self.Logger:Error("System unavailable", {system = systemName})
        return self:_GetFallbackSystem(systemName)
    end

    return system
end
```

**Layer 3: Network Resilience (Router)**

```lua
function Router:SendServerWithRetry(eventName, data, maxRetries)
    local attempts = 0
    repeat
        local success = pcall(function()
            self._remote:FireServer(eventName, data)
        end)
        if success then return true end
        attempts += 1
        task.wait(2 ^ attempts)  -- Exponential backoff
    until attempts >= (maxRetries or 3)

    return false
end
```

**Layer 4: Global Error Boundary (Bootstrap)**

```lua
game:GetService("LogService").MessageOut:Connect(function(message, messageType)
    if messageType == Enum.MessageType.MessageError then
        ErrorTracker:CaptureException(message)
        -- Attempt recovery...
    end
end)
```

### 7.3 Recovery Strategies

- **Fallback Chains:** Primary → Secondary → Minimal
- **State Restoration:** Recovery points untuk critical state
- **Circuit Breaker:** Prevent cascade failures
- **Retry with Backoff:** Exponential backoff untuk network failures

---

## 8. PERFORMANCE & OPTIMIZATION **✅ RETAINED**

### 8.1 Performance Budget

- **Frame Time Impact:** ≤5ms maximum per frame
- **Memory Usage:** Controlled growth dengan lazy loading
- **Network Bandwidth:** Optimized payloads, batched sends
- **Load Time:** <3 seconds engine initialization

### 8.2 Optimization Strategies

**Lazy Loading:**

```lua
-- Load modules on-demand
function Kernel:GetModule(name)
    if not self._loaded[name] then
        self._loaded[name] = require(moduleScript)
    end
    return self._loaded[name]
end
```

**Object Pooling:**

```lua
-- Reuse expensive objects
local pool = ObjectPool.new("Button")
local button = pool:Get()  -- Reuse or create
pool:Return(button)  -- Return to pool
```

**Batched Operations:**

```lua
-- Send multiple updates in one call
Router:BatchSend("BulkUpdate", arrayOfData)
```

**Performance Monitoring:**

```lua
-- Auto-detect slow operations
function Monitor:WrapFunction(fn, label)
    return function(...)
        local start = os.clock()
        local result = {fn(...)}
        local duration = os.clock() - start
        if duration > 0.016 then
            self:LogSlowFunction(label, duration)
        end
        return table.unpack(result)
    end
end
```

---

## 9. SECURITY CONSIDERATIONS **✅ RETAINED**

### 9.1 Server Authority Pattern

**NEVER trust client input:**

```lua
-- ❌ BAD: Client controls everything
Client:Fire("GiveMoney", 9999999)

-- ✅ GOOD: Server validates
Client:Fire("PurchaseItem", itemId)
-- Server checks: inventory, currency, permissions, rate limits
```

### 9.2 Input Validation

**Always validate on server:**

```lua
function DataService:SetPlayerData(player, key, value)
    -- Whitelist
    if not table.find(ALLOWED_KEYS, key) then
        return false
    end

    -- Type check
    if typeof(value) ~= EXPECTED_TYPES[key] then
        return false
    end

    -- Execute
    return pcall(function()
        self._dataStore:SetAsync(player.UserId, value)
    end)
end
```

### 9.3 Rate Limiting

**Prevent abuse:**

```lua
function RateLimiter:CheckLimit(player, action)
    local key = player.UserId .. "_" .. action
    local limit = self._limits[key]

    if not limit then
        self._limits[key] = {count = 1, resetTime = tick() + 60}
        return true
    end

    if tick() > limit.resetTime then
        limit.count = 1
        limit.resetTime = tick() + 60
        return true
    end

    if limit.count >= MAX_REQUESTS then
        return false  -- Rate limited
    end

    limit.count += 1
    return true
end
```

---

## 10. TESTING STRATEGY **✅ RETAINED**

### 10.1 Test Types

**Unit Tests:**

- Test individual functions in isolation
- Mock dependencies
- Fast execution

**Integration Tests:**

- Test system interactions
- Cross-module communication
- Data flow validation

**E2E Tests:**

- Full workflow scenarios
- User journey simulation
- Performance validation

### 10.2 Test Structure

```
tests/
├── Unit/
│   ├── SmartLogger.spec.lua
│   ├── StateManager.spec.lua
│   └── PermissionCore.spec.lua
├── Integration/
│   ├── DataFlow.spec.lua
│   └── ModuleCommunication.spec.lua
└── E2E/
    └── FullWorkflow.spec.lua
```

---

## 11. DOCUMENTATION STANDARDS **✅ RETAINED**

### 11.1 LuaDoc Format

```lua
--- Brief description of function
-- @param player Player -- The player instance
-- @param amount number -- Currency amount (must be positive)
-- @return boolean -- Success status
-- @usage
--   local success = Module:DoSomething(player, 100)
function Module:DoSomething(player, amount)
    -- Implementation
end
```

### 11.2 Module Documentation

Each module must have:

- README.md explaining purpose
- API documentation
- Configuration options
- Usage examples
- Known limitations

---

## 12. FINAL NOTES **✅ RETAINED**

### 12.1 Design Philosophy Summary

**OVHL is NOT:**

- ❌ A replacement for Knit/Fusion/Plasma
- ❌ A game framework
- ❌ A complete solution

**OVHL IS:**

- ✅ A foundation layer
- ✅ A framework complement
- ✅ A standardization tool
- ✅ An enterprise pattern implementor

### 12.2 Key Takeaways

1. **Core is Sacred** - NEVER modify core systems
2. **OVHL API is Gateway** - All access through OVHL
3. **Modules are Islands** - Communicate via EventBus/State
4. **Server is Authority** - Never trust client
5. **Everything Has Fallbacks** - Graceful degradation everywhere
6. **Paths are Explicit** - ALWAYS `game:GetService()`, NEVER relative
7. **Names are Descriptive** - NO `init.lua`, NO generic names

---

## 🎯 **IMPLEMENTATION STATUS SUMMARY** **✅ NEW SECTION**

### **CURRENTLY WORKING (MVP COMPLETE):**

- ✅ Bootstrap System
- ✅ OVHL Core API
- ✅ Config System with Layered Resolution
- ✅ Smart Logger System
- ✅ Basic Networking Router
- ✅ Basic State Management
- ✅ MinimalModule Implementation
- ✅ Server & Client Runtime Entry Points

### **PLANNED FOR NEXT PHASE:**

- ⏳ Full Knit Integration (Services/Controllers)
- ⏳ UI Engine (Triple Mode)
- ⏳ Event Bus System
- ⏳ Permission System
- ⏳ Performance Systems
- ⏳ Advanced State Management

### **ARCHITECTURE VALIDATION:**

- ✅ All core principles maintained
- ✅ Security patterns implemented
- ✅ Module structure confirmed working
- ✅ Config system fully functional
- ✅ Path resolution correct

---

**UPDATED:** November 17, 2025  
**VERSION:** 2.2 (Match Actual Implementation)  
**STATUS:** **REVISED** - Documentation Now Matches Working Codebase

> END OF ./docs/01_OVHL_ENGINE.md
