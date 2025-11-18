> START OF ./docs/200_USER_GUIDES/210_API_REFERENCE/README.md
>
> **OVHL ENGINE V1.0.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** GAMEPLAY PROGRAMMERS, USERS
> **PURPOSE:** Index dan navigation untuk API reference docs dari semua OVHL systems.

---

# 📂 210_API_REFERENCE: System API Documentation

Folder ini berisi **DETAILED API REFERENCE** untuk setiap system di OVHL Engine.

**Audience:** Gameplay programmers, developers menggunakan OVHL systems  
**Purpose:** "Bagaimana cara pakai system ini?" + API reference lengkap  
**Not for:** Engine architects (gunakan `100_ENGINE_GUIDES/` untuk itu)

---

## 📋 SISTEM YANG SUDAH DIDOKUMENTASI (V1.0.0)

### ✅ **211_LOGGER.md** - SmartLogger System

**File:** `docs/200_USER_GUIDES/210_API_REFERENCE/211_LOGGER.md`

**Apa ini?**

- Logging system dengan 4 modes (SILENT, NORMAL, DEBUG, VERBOSE)
- Emoji-based domains dengan color coding
- Structured metadata logging

**API Methods:**

- `Logger:Debug(domain, message, metadata)`
- `Logger:Info(domain, message, metadata)`
- `Logger:Warn(domain, message, metadata)`
- `Logger:Error(domain, message, metadata)`
- `Logger:Critical(domain, message, metadata)`
- `Logger:Performance(domain, message, metadata)` - VERBOSE only
- `Logger:SetModel(modelName)` - Change log level
- `Logger:GetModel()`
- `Logger:IsModel(modelName)`

**Usage:**

```lua
local Logger = OVHL:GetSystem("SmartLogger")
Logger:Info("MYMODULE", "Something happened", {player = player.Name, value = 123})
```

**Lihat:** `211_LOGGER.md` untuk detail lengkap

---

### ✅ **212_PERMISSION.md** - PermissionCore System

**File:** `docs/200_USER_GUIDES/210_API_REFERENCE/212_PERMISSION.md`

**Apa ini?**

- Permission checking system
- HD Admin style ranks (Owner, Admin, Mod, VIP, NonAdmin)
- Node-based permission checking

**API Methods:**

- `PermissionCore:Check(player, permissionNode)` - Check if player has access

**Usage:**

```lua
local PermissionCore = OVHL:GetSystem("PermissionCore")
if PermissionCore:Check(player, "ShopModule.Purchase") then
    -- Player allowed
else
    -- Denied
end
```

**Lihat:** `212_PERMISSION.md` untuk detail lengkap

---

### ✅ **213_VALIDATOR.md** - InputValidator System

**File:** `docs/200_USER_GUIDES/210_API_REFERENCE/213_VALIDATOR.md`

**Apa ini?**

- Schema-based input validation
- Type checking, range validation
- Security-focused validation patterns

**API Methods:**

- `InputValidator:Validate(schemaName, data)` - Validate data against schema
- `InputValidator:AddSchema(schemaName, schema)` - Register custom schema
- `InputValidator:GetSchema(schemaName)`
- `InputValidator:GetAvailableSchemas()`

**Usage:**

```lua
local Validator = OVHL:GetSystem("InputValidator")
local valid, error = Validator:Validate("ActionData", {action = "test", data = {}})
if not valid then
    Logger:Warn("SECURITY", "Invalid input", {error = error})
end
```

**Lihat:** `213_VALIDATOR.md` untuk detail lengkap

---

### ✅ **214_UI_ENGINE.md** - UIEngine System

**File:** `docs/200_USER_GUIDES/210_API_REFERENCE/214_UI_ENGINE.md`

**Apa ini?**

- UI creation system dengan Fusion 0.3 + Native fallback
- Scope management untuk Fusion
- Screen lifecycle

**API Methods:**

- `UIEngine:CreateScreen(screenName, config)` - Create UI screen
- `UIEngine:ShowScreen(screenName)`
- `UIEngine:HideScreen(screenName)`
- `UIEngine:GetScreen(screenName)`
- `UIEngine:GetAvailableFrameworks()` - Check FUSION / NATIVE support

**Usage:**

```lua
local UIEngine = OVHL:GetSystem("UIEngine")
local mainUI = UIEngine:CreateScreen("MainUI", config)
UIEngine:ShowScreen("MainUI")
```

**Lihat:** `214_UI_ENGINE.md` untuk detail lengkap

---

### ✅ **215_RATE_LIMITER.md** - RateLimiter System

**File:** `docs/200_USER_GUIDES/210_API_REFERENCE/215_RATE_LIMITER.md`

**Apa ini?**

- Anti-spam rate limiting per player/action
- Configurable max requests per time window
- Stats tracking

**API Methods:**

- `RateLimiter:Check(player, action)` - Check if allowed
- `RateLimiter:SetLimit(action, maxRequests, timeWindow)`
- `RateLimiter:GetLimit(action)`
- `RateLimiter:GetPlayerStats(player)` - Get current limits status

**Usage:**

```lua
local RateLimiter = OVHL:GetSystem("RateLimiter")
if not RateLimiter:Check(player, "DoAction") then
    return false, "Spam detected"
end
```

**Lihat:** `215_RATE_LIMITER.md` untuk detail lengkap

---

### ✅ **216_NETWORKING.md** - NetworkingRouter System

**File:** `docs/200_USER_GUIDES/210_API_REFERENCE/216_NETWORKING.md`

**Apa ini?**

- Remote event/function management
- Client ↔ Server communication
- Basic routing + security middleware

**API Methods:**

- `NetworkingRouter:RegisterHandler(route, handler)` - Register endpoint handler
- `NetworkingRouter:SendToServer(route, data)` - Client → Server
- `NetworkingRouter:SendToClient(player, route, data)` - Server → Client
- `RemoteBuilder:CreateEndpoint(name, config)` - Create typed endpoint
- `RemoteBuilder:SendEvent(endpointName, data, target)`
- `RemoteBuilder:SendRequest(endpointName, data)` - Request/response

**Usage:**

```lua
local Router = OVHL:GetSystem("NetworkingRouter")
Router:RegisterHandler("MyModule.DoAction", function(player, data)
    -- Handle request
end)

-- Client side:
Router:SendToServer("MyModule.DoAction", {action = "test"})
```

**Lihat:** `216_NETWORKING.md` untuk detail lengkap

---

### ✅ **217_UI_MANAGER.md** - UIManager System

**File:** `docs/200_USER_GUIDES/210_API_REFERENCE/217_UI_MANAGER.md`

**Apa ini?**

- Screen lifecycle management (show/hide/toggle)
- TopbarPlus v3 integration
- Component discovery
- Event binding

**API Methods:**

- `UIManager:RegisterScreen(screenName, screenInstance)`
- `UIManager:ShowScreen(screenName)`
- `UIManager:HideScreen(screenName)`
- `UIManager:ToggleScreen(screenName)`
- `UIManager:SetupTopbar(moduleName, config)` - Create topbar button
- `UIManager:FindComponent(screenName, componentName)`
- `UIManager:BindEvent(component, eventName, callback)`

**Usage:**

```lua
local UIManager = OVHL:GetSystem("UIManager")
UIManager:RegisterScreen("MainUI", screenGui)
UIManager:ShowScreen("MainUI")

local button = UIManager:FindComponent("MainUI", "ActionButton")
UIManager:BindEvent(button, "Activated", function()
    print("Button clicked")
end)
```

**Lihat:** `217_UI_MANAGER.md` untuk detail lengkap

---

### ✅ **218_ASSET_LOADER.md** - AssetLoader System

**File:** `docs/200_USER_GUIDES/210_API_REFERENCE/218_ASSET_LOADER.md`

**Apa ini?**

- Asset loading + management (icons, images)
- Input handling + keybind registration
- Button click event management

**API Methods:**

- `AssetLoader:LoadIcon(iconName, assetId)` - Load asset
- `AssetLoader:PreloadAssets(assetConfig)` - Batch load
- `AssetLoader:GetAsset(assetName)`
- `AssetLoader:RegisterKeybind(keyCode, callback, options)`
- `AssetLoader:RegisterButtonClick(button, callback)`
- `AssetLoader:Cleanup()` - Disconnect all

**Usage:**

```lua
local AssetLoader = OVHL:GetSystem("AssetLoader")
local icon = AssetLoader:LoadIcon("MyIcon", "rbxassetid://123456789")

AssetLoader:RegisterKeybind(Enum.KeyCode.M, function()
    print("M pressed")
end)
```

**Lihat:** `218_ASSET_LOADER.md` untuk detail lengkap

---

## 📋 SISTEM YANG BELUM DIDOKUMENTASI (PLANNED)

### ⏳ **DataManager System**

**Status:** BETA - Implementation exists, docs not yet written

**Quick reference:**

```lua
local DataManager = OVHL:GetSystem("DataManager")
local playerData = DataManager:LoadData(player)
DataManager:SaveData(player)
DataManager:GetCachedData(player)
```

**TODO:** Create `219_DATA_MANAGER.md`

---

### ⏳ **PlayerManager System**

**Status:** BETA - Implementation exists, docs not yet written

**Quick reference:**

```lua
-- Automatic player join/leave handling
-- Triggers DataManager:LoadData() on join
-- Triggers DataManager:SaveData() on leave
```

**TODO:** Create `220_PLAYER_MANAGER.md`

---

### ⏳ **NotificationService System**

**Status:** BETA - Implementation exists, docs not yet written

**Quick reference:**

```lua
local NotifService = OVHL:GetSystem("NotificationService")
NotifService:SendToPlayer(player, "Hello!", "Info", 5)
```

**TODO:** Create `221_NOTIFICATION_SERVICE.md`

---

### ⏳ **ConfigLoader System**

**Status:** STABLE - Core system, docs planned

**Quick reference:**

```lua
local ConfigLoader = OVHL:GetSystem("ConfigLoader")
local config = ConfigLoader:ResolveConfig("ModuleName", "Server")
local clientSafeConfig = ConfigLoader:GetClientSafeConfig("ModuleName")
```

**TODO:** Create `210_CONFIG_LOADER.md`

---

## 🎯 QUICK LOOKUP BY USE CASE

### **"Saya ingin log sesuatu"**

→ **211_LOGGER.md**

```lua
Logger:Info("MYMODULE", "Something", {data = value})
```

### **"Saya ingin validate input dari client"**

→ **213_VALIDATOR.md**

```lua
local valid, err = Validator:Validate("ActionData", data)
```

### **"Saya ingin check permission"**

→ **212_PERMISSION.md**

```lua
if PermissionCore:Check(player, "ModuleName.Action") then ... end
```

### **"Saya ingin prevent spam"**

→ **215_RATE_LIMITER.md**

```lua
if not RateLimiter:Check(player, "DoAction") then return false end
```

### **"Saya ingin bikin UI"**

→ **214_UI_ENGINE.md** + **217_UI_MANAGER.md**

```lua
local screen = UIEngine:CreateScreen("MainUI", config)
UIManager:ShowScreen("MainUI")
```

### **"Saya ingin handle keybinds"**

→ **218_ASSET_LOADER.md**

```lua
AssetLoader:RegisterKeybind(Enum.KeyCode.M, callback)
```

### **"Saya ingin komunikasi client ↔ server"**

→ **216_NETWORKING.md**

```lua
Router:SendToServer("Module.Action", data)
```

### **"Saya ingin load/save player data"**

→ **219_DATA_MANAGER.md** (PLANNED)

```lua
local data = DataManager:LoadData(player)
```

---

## 📖 READING ORDER

**Jika lu programmer gameplay baru:**

1. `211_LOGGER.md` - Pelajari logging
2. `213_VALIDATOR.md` - Understand validation
3. `212_PERMISSION.md` - Understand permission
4. `215_RATE_LIMITER.md` - Understand rate limiting
5. `214_UI_ENGINE.md` + `217_UI_MANAGER.md` - Understand UI
6. `216_NETWORKING.md` - Understand networking

**Jika lu sudah familiar:**

- Langsung ke doc spesifik yg lu butuh

---

## ✅ DOCUMENTATION STANDARDS

Setiap API reference file harus punya:

- ✅ **Purpose** - Apa system ini?
- ✅ **Quick Start** - Copy-paste contoh sederhana
- ✅ **API Methods** - List semua public methods
- ✅ **Method Details** - Per-method explanation
- ✅ **Usage Examples** - Real-world scenarios
- ✅ **Best Practices** - Dos and don'ts
- ✅ **FAQ** - Common questions

---

## 🔗 RELATED DOCUMENTATION

- **For creating modules:** `201_CONTRIBUTING_MODULE.md`
- **For creating systems:** `202_CONTRIBUTING_SYSTEM.md`
- **For architecture:** `100_ENGINE_GUIDES/101_GENESIS_ARCHITECTURE.md`
- **For workflow:** `00_AI_WORKFLOW_GUIDE.md`

---

## 📈 DOCUMENTATION PROGRESS

| System              | Doc File                    | Status     | Last Update |
| ------------------- | --------------------------- | ---------- | ----------- |
| SmartLogger         | 211_LOGGER.md               | ✅ DONE    | 2025-11-18  |
| PermissionCore      | 212_PERMISSION.md           | ✅ DONE    | 2025-11-18  |
| InputValidator      | 213_VALIDATOR.md            | ✅ DONE    | 2025-11-18  |
| UIEngine            | 214_UI_ENGINE.md            | ✅ DONE    | 2025-11-18  |
| RateLimiter         | 215_RATE_LIMITER.md         | ✅ DONE    | 2025-11-18  |
| NetworkingRouter    | 216_NETWORKING.md           | ✅ DONE    | 2025-11-18  |
| UIManager           | 217_UI_MANAGER.md           | ✅ DONE    | 2025-11-18  |
| AssetLoader         | 218_ASSET_LOADER.md         | ✅ DONE    | 2025-11-18  |
| DataManager         | 219_DATA_MANAGER.md         | ⏳ PLANNED | -           |
| PlayerManager       | 220_PLAYER_MANAGER.md       | ⏳ PLANNED | -           |
| NotificationService | 221_NOTIFICATION_SERVICE.md | ⏳ PLANNED | -           |
| ConfigLoader        | 210_CONFIG_LOADER.md        | ⏳ PLANNED | -           |

---

> END OF ./docs/200_USER_GUIDES/210_API_REFERENCE/README.md
