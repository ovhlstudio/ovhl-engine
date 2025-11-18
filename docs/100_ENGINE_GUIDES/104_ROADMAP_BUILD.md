> START OF ./docs/100_ENGINE_GUIDES/104_ROADMAP_BUILD.md
>
> **OVHL ENGINE V1.0.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** ENGINE ENGINEERS, CORE DEVELOPERS
> **PURPOSE:** Peta implementasi sistem OVHL V1.0.0 dari nol (Build From Scratch reference).

---

# 🗺️ 104_ROADMAP_BUILD.md (V1.0.0)

> **DESAIN:** Dokumen ini adalah panduan "Build From Scratch" untuk reference.
> **CATATAN:** Saat ini OVHL V1.0.0 **SUDAH SELESAI**. Roadmap ini untuk future phase (V1.1.0+).

---

## 📊 STATUS V1.0.0 (CURRENT)

| Komponen           | Status     | File                                                   | Notes                                       |
| ------------------ | ---------- | ------------------------------------------------------ | ------------------------------------------- |
| **Core Systems**   | ✅ DONE    | `SystemRegistry`, `Bootstrap`, `Kernel`, `OVHL`        | 4-Phase lifecycle fully implemented         |
| **Foundation**     | ✅ DONE    | `SmartLogger`, `ConfigLoader`, `StudioFormatter`       | Logging + config resolution working         |
| **Security**       | ✅ DONE    | `InputValidator`, `RateLimiter`, `PermissionCore`      | 3-pilar security pipeline functional        |
| **Networking**     | ⚠️ BETA    | `NetworkingRouter`, `RemoteBuilder`, `NetworkSecurity` | Basic working, missing SendToAllClients()   |
| **UI**             | ✅ DONE    | `UIEngine`, `UIManager`, `AssetLoader`                 | Fusion 0.3 + Native fallback                |
| **Advanced**       | ✅ DONE    | `DataManager`, `PlayerManager`, `NotificationService`  | Data persistence + player lifecycle working |
| **MinimalModule**  | ✅ DONE    | Service + Controller + Configs                         | Reference implementation complete           |
| **Test Framework** | ⚠️ PARTIAL | `SmartLogger.spec.lua`                                 | Only SmartLogger tested, more needed        |

**Summary:** V1.0.0 **STABLE & PRODUCTION READY** untuk core features. Ready untuk game development.

---

## 🛣️ PHASE HISTORY (COMPLETED)

### **Phase 0: Preparation (✅ DONE)**

Siapkan environment, tools, struktur.

- ✅ Instalasi Knit, Fusion, testing framework
- ✅ Setup Rojo + project structure
- ✅ Create scaffolding folder (Core, Systems, Modules)

---

### **Phase 1: Foundation (✅ DONE)**

Core engine yang bisa "boot".

**Completed:**

- ✅ `OVHL.lua` - API Gateway
- ✅ `Bootstrap.lua` - System discovery + scanner
- ✅ `Kernel.lua` - Module loader
- ✅ `SystemRegistry.lua` - 4-Phase orchestrator (Initialize → Register → Start → Destroy)
- ✅ `SmartLogger.lua` - Logging system dengan 4 modes (SILENT, NORMAL, DEBUG, VERBOSE)
- ✅ `ConfigLoader.lua` - Layered config resolution
- ✅ `StudioFormatter.lua` - Pretty console output

**Validation:**

- ✅ Server boot: No errors
- ✅ Client boot: No errors
- ✅ Logger accessible via `OVHL:GetSystem("SmartLogger")`

---

### **Phase 2: Security & Networking (✅ DONE)**

Security layer + basic networking.

**Completed:**

- ✅ `InputValidator.lua` - Schema-based validation
- ✅ `RateLimiter.lua` - Anti-spam per player/action
- ✅ `PermissionCore.lua` - HD Admin style ranks (Owner, Admin, Mod, VIP, NonAdmin)
- ✅ `NetworkingRouter.lua` - Knit-based remote management
- ✅ `RemoteBuilder.lua` - Type-safe endpoint definition
- ✅ `NetworkSecurity.lua` - Middleware untuk security checks

**3-Pilar Security Pipeline:**

1. InputValidator (schema check)
2. RateLimiter (spam check)
3. PermissionCore (rank check)

**Validation:**

- ✅ MinimalModule loads + UI renders
- ✅ Button click triggers service method
- ✅ Security pipeline blocks invalid input
- ✅ Rate limiting prevents spam

---

### **Phase 3: Persistence & Advanced (✅ DONE)**

Data persistence + player lifecycle management.

**Completed:**

- ✅ `DataManager.lua` - DataStore integration (load/save player data)
- ✅ `PlayerManager.lua` - Detect join/leave, trigger data load/save
- ✅ `NotificationService.lua` - Server-side notification API
- ✅ 4-Phase Lifecycle fixes (ADR-004):
  - Initialize: Construction only
  - Register: OVHL registration
  - Start: Dependencies + activation
  - Destroy: Cleanup (reverse order)

**Validation:**

- ✅ Player join → data loads
- ✅ Player leave → data saves
- ✅ Game close → all data saved, connections cleanup
- ✅ No memory leaks, no nil race conditions

---

### **Phase 4: UI & Modules (✅ DONE)**

UI frameworks + reference implementation.

**Completed:**

- ✅ `UIEngine.lua` - Fusion 0.3 screen creation (scoped)
- ✅ `UIManager.lua` - Screen lifecycle + TopbarPlus integration
- ✅ `AssetLoader.lua` - Asset management + keybind handling
- ✅ `MinimalModule` (reference):
  - `SharedConfig.lua` - 3-schema example
  - `MinimalService.lua` - 3-pilar security + business logic
  - `MinimalController.lua` - UI + networking
  - `ServerConfig.lua` + `ClientConfig.lua` - Layered config

**Validation:**

- ✅ UI renders via Fusion
- ✅ TopbarPlus button shows + toggles screen
- ✅ Keybinds (M, Q) work
- ✅ Action button triggers validated server call
- ✅ Data persists across rejoin

---

## 🚀 PHASE 5: ADAPTER PATTERN (V1.1.0 - PLANNED)

Implement config-driven adapter system (Hukum #4 - Config-Driven).

### **What's This About**

Currently `PermissionCore` + `UIManager` hardcoded to specific implementations:

- `PermissionCore` → always use fallback ranks
- `UIManager` → always use TopbarPlus

**Problem:** Violates Hukum #4 (Config-Driven). Should be pluggable.

**Solution:** Adapter Pattern (sudah documented di `103_ARCHITECTURE_ADAPTERS.md`)

### **Implementation Plan**

#### **Step 1: Create Adapter Folders**

```
Systems/Adapters/
├── Permission/
│   ├── IPermissionAdapter.lua       (interface/contract)
│   ├── InternalAdapter.lua          (current fallback logic)
│   └── HDAdminAdapter.lua           (HD Admin integration)
└── Navbar/
    ├── INavbarAdapter.lua           (interface)
    ├── TopbarPlusAdapter.lua        (current TopbarPlus logic)
    └── InternalAdapter.lua          (native implementation)
```

#### **Step 2: Extract Logic to Adapters**

Move existing code:

- `PermissionCore` logic → `InternalAdapter`
- `UIManager` TopbarPlus logic → `TopbarPlusAdapter`

#### **Step 3: Make Core Systems Adapter Loaders**

Refactor:

- `PermissionCore.lua` → load adapter dari config, delegate ke adapter
- `UIManager.lua` → load adapter dari config, delegate ke adapter

#### **Step 4: Update EngineConfig**

```lua
-- EngineConfig.lua
return {
    -- ...
    Adapters = {
        Permission = "InternalAdapter",  -- or "HDAdminAdapter"
        Navbar = "TopbarPlusAdapter",    -- or "InternalAdapter"
    }
}
```

#### **Step 5: Validate**

- ✅ Permission check still works
- ✅ Navbar still appears
- ✅ Can switch adapters via config

**Effort:** ~4-6 hours

---

## 📦 PHASE 6: COMPLETE NETWORKING (V1.1.0 - PLANNED)

Finish networking layer (missing methods + retry logic).

### **What's Missing**

1. `NetworkingRouter:SendToAllClients(route, data)` - broadcast to all
2. Client-side `RequestServer(route, data)` - RPC call to server
3. Automatic retry dengan exponential backoff
4. Network timeout handling

### **Implementation Plan**

#### **Step 1: Add SendToAllClients**

```lua
function NetworkingRouter:SendToAllClients(route, data)
    local players = game:GetService("Players"):GetPlayers()
    for _, player in ipairs(players) do
        self._remotes.ServerToClient:FireClient(player, route, data)
    end
end
```

#### **Step 2: Add Client RequestServer**

```lua
function NetworkingRouter:RequestServer(route, data)
    if not self._remotes.RequestResponse then return nil end
    local result = self._remotes.RequestResponse:InvokeServer(route, data)
    return result.success and result.data or nil
end
```

#### **Step 3: Retry Logic**

```lua
function NetworkingRouter:_sendWithRetry(route, data, maxRetries)
    local attempt = 0
    while attempt < maxRetries do
        local success, result = pcall(function()
            return self:_send(route, data)
        end)

        if success then return result end

        attempt = attempt + 1
        local backoff = 2 ^ attempt  -- exponential: 2, 4, 8, 16...
        task.wait(backoff)
    end
    return nil
end
```

#### **Step 4: Validate**

- ✅ SendToAllClients sends to multiple players
- ✅ RequestServer blocks + returns response
- ✅ Retry works with exponential backoff

**Effort:** ~2-3 hours

---

## 🎮 PHASE 7: STATE MANAGER (V1.1.0 - PLANNED)

Implement global state management (Redux-like).

### **What's This For**

Saat ini data state ada di:

- Server: DataManager (persistent)
- Client: Scattered di various controllers

**Problem:** Sulit track state changes, debug, reload state.

**Solution:** Centralized StateManager dengan action/reducer pattern.

### **Architecture**

```lua
-- Example usage
local Store = OVHL:GetSystem("StateManager")

-- Subscribe ke state changes
Store:Subscribe("inventory", function(newInventory)
    UI:UpdateInventory(newInventory)
end)

-- Dispatch action
Store:Dispatch("inventory/addItem", {itemId = 123, qty = 5})

-- Get current state
local inv = Store:GetState("inventory")
```

### **Implementation Plan**

1. Create `StateManager.lua` system
2. Define reducer functions (inventory, currency, etc)
3. Action dispatcher
4. Subscribe to changes
5. Persist to DataManager

**Effort:** ~6-8 hours

---

## 🧪 PHASE 8: ENHANCED TESTING (V1.1.0 - PLANNED)

Complete test coverage untuk semua systems.

### **Current Status**

- ✅ SmartLogger.spec.lua exists (basic test)
- ❌ InputValidator - no test
- ❌ RateLimiter - no test
- ❌ PermissionCore - no test
- ❌ DataManager - no test
- ❌ Integration tests - none
- ❌ E2E tests - none

### **Plan**

Create tests untuk:

1. **Unit Tests** (per system):

   - InputValidator validation logic
   - RateLimiter counting logic
   - PermissionCore rank checking
   - DataManager load/save

2. **Integration Tests**:

   - Security pipeline (all 3 checks together)
   - Data flow (player join → load → action → save)
   - System lifecycle (4-phase flow)

3. **E2E Tests**:
   - Full player workflow (join → action → data persist → rejoin)

**Test structure:**

```text
tests/
├── Unit/
│   ├── SmartLogger.spec.lua ✅
│   ├── InputValidator.spec.lua
│   ├── RateLimiter.spec.lua
│   ├── PermissionCore.spec.lua
│   └── DataManager.spec.lua
├── Integration/
│   ├── SecurityPipeline.spec.lua
│   ├── SystemRegistry.spec.lua
│   └── DataFlow.spec.lua
└── E2E/
    └── PlayerJoinFlow.spec.lua
```

**Effort:** ~4-6 hours

---

## ⚡ PHASE 9: PERFORMANCE OPTIMIZATION (V1.2.0 - PLANNED)

Performance improvements + monitoring.

### **Focus Areas**

1. **Object Pooling** - Reuse instances instead of create/destroy
2. **Lazy Loading** - Load systems/modules on-demand
3. **Memory Profiling** - Detect leaks
4. **Performance Monitoring** - Log slow operations

### **Implementation**

- Create `ObjectPool.lua` system
- Create `PerformanceMonitor.lua` system
- Refactor hot paths untuk use pooling
- Add metrics collection

**Effort:** ~8-10 hours

---

## 🔐 PHASE 10: ADVANCED SECURITY (V2.0.0 - FUTURE)

Advanced security features.

### **Planned Features**

1. **Encryption** - Encrypt sensitive data
2. **OAuth/SSO** - External auth provider
3. **Audit Logging** - Log security events
4. **Rate Limiting per IP** - DDoS protection
5. **Automatic Rollback** - Revert bad changes

**Status:** Future phase, design phase only.

---

## 📈 TIMELINE SUMMARY

| Phase            | Name                  | Status      | Duration | Dependencies |
| ---------------- | --------------------- | ----------- | -------- | ------------ |
| 0                | Preparation           | ✅ DONE     | 1h       | None         |
| 1                | Foundation            | ✅ DONE     | 8h       | Phase 0      |
| 2                | Security & Networking | ✅ DONE     | 8h       | Phase 1      |
| 3                | Persistence           | ✅ DONE     | 6h       | Phase 2      |
| 4                | UI & Modules          | ✅ DONE     | 6h       | Phase 3      |
| **V1.0.0 Total** |                       | **✅ DONE** | **~30h** | -            |
| 5                | Adapter Pattern       | 📋 PLANNED  | 5h       | Phase 4      |
| 6                | Complete Networking   | 📋 PLANNED  | 3h       | Phase 5      |
| 7                | StateManager          | 📋 PLANNED  | 7h       | Phase 4      |
| 8                | Enhanced Testing      | 📋 PLANNED  | 5h       | Phase 7      |
| **V1.1.0 Total** |                       | **PLANNED** | **~20h** | Phase 4      |
| 9                | Performance Opt       | 📋 PLANNED  | 10h      | Phase 8      |
| **V1.2.0 Total** |                       | **PLANNED** | **~10h** | Phase 8      |
| 10               | Advanced Security     | 🔮 FUTURE   | TBD      | Phase 9      |
| **V2.0.0 Total** |                       | **FUTURE**  | **TBD**  | Phase 9      |

---

## 🎯 NEXT IMMEDIATE ACTIONS (POST V1.0.0)

Untuk kontribusi berikutnya:

1. **Documentation** (1-2 jam):

   - Update `210_API_REFERENCE` untuk missing systems
   - Create `RELEASE_NOTES.md` untuk V1.0.0

2. **Adapter Pattern** (5-6 jam):

   - Refactor PermissionCore → adapter loader
   - Refactor UIManager → adapter loader
   - Create adapters folder + implementations

3. **Testing** (2-3 jam):

   - Create InputValidator.spec.lua
   - Create SecurityPipeline integration test

4. **Networking** (2-3 jam):
   - Implement SendToAllClients()
   - Add RequestServer() client method

---

> END OF ./docs/100_ENGINE_GUIDES/104_ROADMAP_BUILD.md
