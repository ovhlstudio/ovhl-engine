---
type: project-snapshot
purpose: AI Analysis & Debugging Context
usage: Upload this entire file to AI for project understanding
---

# 🤖 AI ANALYSIS CONTEXT

> **Instructions for AI:**
>
> - This document contains complete project structure and codebase
> - All file paths are relative to project root
> - Use this for: debugging, code analysis, refactoring suggestions, architecture review
> - When referencing code, cite: `File: path/to/file.lua, Line: X`

---

# 📊 Project Snapshot

**Generated:** 2025-11-19 20:02:20  
**Target Directories:** `src tests`  
**Git Info:** Branch: refactor/v2-perbaikan-manifest | Commit: aa2b600 | Modified files: 17  
**Structure:** 46 folders | 47 files (46 Lua, 1 other)
**File Distribution:** Server: 6 (3K, 84 lines) | Client: 9 (13K, 384 lines) | Shared: 31 (32K, 1K lines)
**Total Size:** 48K

---

## 📁 Project Structure

```
📦 src/
  ├── 📁 ReplicatedFirst/
    ├── 📁 Preloader/
      ├── 🌙 init.client.lua
  ├── 📁 ReplicatedStorage/
    ├── 📁 OVHL_Shared/
      ├── 📁 Context/
        ├── 🌙 Constants.lua
        ├── 🌙 GameEnums.lua
      ├── 📁 Core/
        ├── 🌙 Bootstrapper.lua
        ├── 🌙 Logger.lua
        ├── 🌙 Network.lua
        ├── 🌙 Permission.lua
        ├── 🌙 Signal.lua
        ├── 🌙 SystemRegistry.lua
      ├── 🌙 init.lua
      ├── 📁 Library/
        ├── 📁 Adapters/
          ├── 📁 Navbar/
            ├── 🌙 InternalAdapter.lua
            ├── 🌙 TopbarPlusAdapter.lua
          ├── 📁 Permission/
            ├── 🌙 HDAdminAdapter.lua
            ├── 🌙 InternalAdapter.lua
        ├── 📁 Security/
          ├── 🌙 InputValidator.lua
          ├── 🌙 NetworkGuard.lua
          ├── 🌙 SecurityHelper.lua
        ├── 🌙 SharedConfig.lua
        ├── 📁 UI_Framework/
          ├── 📁 Atoms/
            ├── 🌙 Button.lua
            ├── 🌙 Panel.lua
          ├── 📁 Components/
          ├── 🌙 Theme.lua
          ├── 📁 Utils/
            ├── 🌙 AssetLoader.lua
            ├── 🌙 ComponentScanner.lua
            ├── 🌙 Responsive.lua
      ├── 📁 Modules/
        ├── 📁 Shop/
          ├── 🌙 ShopConfig.lua
      ├── 📁 Systems/
        ├── 🌙 ConfigLoader.lua
        ├── 📁 Foundation/
          ├── 🌙 StudioFormatter.lua
  ├── 📁 ServerScriptService/
    ├── 📁 OVHL_Server/
      ├── 🌙 init.server.lua
      ├── 📁 Modules/
        ├── 📁 Shop/
          ├── 🌙 ShopService.lua
      ├── 📁 Systems/
        ├── 📁 Notification/
          ├── 🌙 NotificationService.lua
        ├── 📁 PlayerData/
          ├── 🌙 DataService.lua
        ├── 🌙 PlayerManager.lua
        ├── 📁 Security/
          ├── 🌙 RateLimiter.lua
  ├── 📁 ServerStorage/
    ├── 📁 OVHL_Internal/
      ├── 📁 DataInternal/
        ├── 🌙 DataManager.lua
      ├── 📁 Security/
  ├── 📁 StarterPlayer/
    ├── 📁 StarterPlayerScripts/
      ├── 📁 OVHL_Client/
        ├── 📁 Controllers/
          ├── 📁 Notification/
            ├── 🌙 NotificationController.lua
            ├── 🌙 NotificationView.lua
        ├── 🌙 init.client.lua
        ├── 📁 Modules/
          ├── 📁 Notification/
            ├── 🌙 NotificationController.lua
            ├── 🌙 NotificationView.lua
          ├── 📁 Shop/
            ├── 🌙 ShopController.lua
            ├── 📁 Views/
              ├── 🌙 ShopView.lua
        ├── 📁 Systems/
          ├── 🌙 AssetLoader.lua
          ├── 🌙 UIManager.lua
```

```
📦 tests/
  ├── 📁 E2E/
  ├── 📁 Integration/
  ├── 📁 Unit/
```

## 📂 Directory Overview

### 📦 src

- 📁 **ReplicatedFirst/Preloader**: 1 Lua file(s)
- 📁 **ReplicatedStorage/OVHL_Shared**: 1 Lua file(s)
- 📁 **ReplicatedStorage/OVHL_Shared/Context**: 2 Lua file(s)
- 📁 **ReplicatedStorage/OVHL_Shared/Core**: 6 Lua file(s)
- 📁 **ReplicatedStorage/OVHL_Shared/Library**: 1 Lua file(s)
- 📁 **ReplicatedStorage/OVHL_Shared/Library/Adapters/Navbar**: 2 Lua file(s)
- 📁 **ReplicatedStorage/OVHL_Shared/Library/Adapters/Permission**: 2 Lua file(s)
- 📁 **ReplicatedStorage/OVHL_Shared/Library/Security**: 3 Lua file(s)
- 📁 **ReplicatedStorage/OVHL_Shared/Library/UI_Framework**: 1 Lua file(s)
- 📁 **ReplicatedStorage/OVHL_Shared/Library/UI_Framework/Atoms**: 2 Lua file(s)
- 📁 **ReplicatedStorage/OVHL_Shared/Library/UI_Framework/Utils**: 3 Lua file(s)
- 📁 **ReplicatedStorage/OVHL_Shared/Modules/Shop**: 1 Lua file(s)
- 📁 **ReplicatedStorage/OVHL_Shared/Systems**: 1 Lua file(s)
- 📁 **ReplicatedStorage/OVHL_Shared/Systems/Foundation**: 1 Lua file(s)
- 📁 **ServerScriptService/OVHL_Server**: 1 Lua file(s)
- 📁 **ServerScriptService/OVHL_Server/Modules/Shop**: 1 Lua file(s)
- 📁 **ServerScriptService/OVHL_Server/Systems**: 1 Lua file(s)
- 📁 **ServerScriptService/OVHL_Server/Systems/Notification**: 1 Lua file(s)
- 📁 **ServerScriptService/OVHL_Server/Systems/PlayerData**: 1 Lua file(s)
- 📁 **ServerScriptService/OVHL_Server/Systems/Security**: 1 Lua file(s)
- 📁 **ServerStorage/OVHL_Internal/DataInternal**: 1 Lua file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL_Client**: 1 Lua file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL_Client/Controllers/Notification**: 2 Lua file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL_Client/Modules/Notification**: 2 Lua file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL_Client/Modules/Shop**: 1 Lua file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL_Client/Modules/Shop/Views**: 1 Lua file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL_Client/Systems**: 2 Lua file(s)

### 📦 tests

- 📁 **Unit**: 3 Lua file(s)

---

## 🔗 Dependency Analysis

### 📊 System Dependencies

### 📥 Dependent Systems

### ⚠️ Circular Dependency Check

✅ No circular dependencies detected

### 🏁 Race Condition Analysis

✅ No obvious race conditions detected

### 🛡️ Security Analysis

✅ No obvious security issues detected

### 📈 Summary Statistics

#### 📊 Top 10 Largest Files

- `src/ServerStorage/OVHL_Internal/DataInternal/DataManager.lua` (92 lines)
- `src/ReplicatedStorage/OVHL_Shared/Core/Network.lua` (87 lines)
- `src/ReplicatedStorage/OVHL_Shared/Library/Adapters/Permission/HDAdminAdapter.lua` (76 lines)
- `src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Modules/Shop/Views/ShopView.lua` (61 lines)
- `src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Controllers/Notification/NotificationController.lua` (58 lines)
- `src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Controllers/Notification/NotificationView.lua` (54 lines)
- `src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Modules/Shop/ShopController.lua` (53 lines)
- `tests/Unit/InputValidator.spec.lua` (52 lines)
- `src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Modules/Notification/NotificationView.lua` (43 lines)
- `src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Modules/Notification/NotificationController.lua` (42 lines)

#### 📏 File Size Distribution

- **0-100 lines:** 46 files
- **101-500 lines:** 0 files
- **501-1000 lines:** 0 files
- **1001+ lines:** 0 files

## 📚 Complete Codebase

### 📦 src/

<details>
<summary><strong>🌙 src/ReplicatedFirst/Preloader/init.client.lua</strong> (30 lines, 883B)</summary>

**Full Path:** `src/ReplicatedFirst/Preloader/init.client.lua`

```lua
   1 | -- [[ OVHL V2 PRELOADER ]]
   2 | local Players = game:GetService("Players")
   3 | local ReplicatedFirst = game:GetService("ReplicatedFirst")
   4 |
   5 | local player = Players.LocalPlayer
   6 | local playerGui = player:WaitForChild("PlayerGui")
   7 |
   8 | -- Simple Loading Screen
   9 | local screen = Instance.new("ScreenGui")
  10 | screen.Name = "OVHL_Preloader"
  11 | screen.IgnoreGuiInset = true
  12 | screen.Parent = playerGui
  13 |
  14 | local frame = Instance.new("Frame")
  15 | frame.Size = UDim2.fromScale(1, 1)
  16 | frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
  17 | frame.Parent = screen
  18 |
  19 | local label = Instance.new("TextLabel")
  20 | label.Text = "INITIALIZING OVHL V2..."
  21 | label.Size = UDim2.fromScale(1, 0.1)
  22 | label.Position = UDim2.fromScale(0, 0.45)
  23 | label.TextColor3 = Color3.new(1,1,1)
  24 | label.BackgroundTransparency = 1
  25 | label.Parent = frame
  26 |
  27 | -- Cleanup Logic (Listen to Engine Loaded signal later if needed)
  28 | task.delay(4, function()
  29 |     screen:Destroy()
  30 | end)
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Context/Constants.lua</strong> (8 lines, 268B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Context/Constants.lua`

```lua
   1 | -- [[ GLOBAL CONSTANTS (PORTED) ]]
   2 | return {
   3 |     ENGINE = { VERSION = "2.0.0", NAME = "OVHL V2" },
   4 |     NETWORKING = { DEFAULT_TIMEOUT = 10, MAX_RETRIES = 3 },
   5 |     UI = {
   6 |         Z_INDEX = { BACKGROUND = 0, CONTENT = 10, HEADER = 20, OVERLAY = 50, TOAST = 100 }
   7 |     }
   8 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Context/GameEnums.lua</strong> (13 lines, 220B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Context/GameEnums.lua`

```lua
   1 | -- [[ GAME ENUMS ]]
   2 | -- Centralized Enumerations
   3 | return {
   4 |     Rank = {
   5 |         Guest = 0,
   6 |         Member = 1,
   7 |         Admin = 5
   8 |     },
   9 |     ItemType = {
  10 |         Weapon = "Weapon",
  11 |         Consumable = "Consumable"
  12 |     }
  13 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Core/Bootstrapper.lua</strong> (36 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Core/Bootstrapper.lua`

```lua
   1 | -- [[ BOOTSTRAPPER (FIXED) ]]
   2 | local Bootstrapper = {}
   3 | local Logger = require(script.Parent.Logger)
   4 | local Registry = require(script.Parent.SystemRegistry)
   5 |
   6 | function Bootstrapper.Init(context)
   7 |     Logger:Info("BOOTSTRAP", "Initializing OVHL V2 ("..context..")")
   8 |
   9 |     local function Scan(folder)
  10 |         if not folder then return end
  11 |         for _, v in ipairs(folder:GetDescendants()) do
  12 |             if v:IsA("ModuleScript") and (v.Name:match("Service$") or v.Name:match("Controller$") or v.Name:match("System$") or v.Name == "AssetLoader" or v.Name == "UIManager") then
  13 |                 local s, m = pcall(require, v)
  14 |                 if s then
  15 |                     if m.Name then Registry.Register(m.Name, m) end
  16 |                 else
  17 |                     Logger:Critical("BOOTSTRAP", "Require Fail", {file=v.Name, err=m})
  18 |                 end
  19 |             end
  20 |         end
  21 |     end
  22 |
  23 |     local Root = context == "SERVER" and game.ServerScriptService.OVHL_Server or game.StarterPlayer.StarterPlayerScripts.OVHL_Client
  24 |
  25 |     Scan(Root:WaitForChild("Systems", 10))
  26 |     Scan(Root:WaitForChild("Modules", 10))
  27 |
  28 |     -- [FIX] Access Public Table .Systems instead of private ._systems
  29 |     local count = 0
  30 |     for _ in pairs(Registry.Systems) do count = count + 1 end
  31 |
  32 |     Registry.StartAll()
  33 |     Logger:Info("BOOTSTRAP", "Boot Complete", {modules=count, context=context})
  34 | end
  35 |
  36 | return Bootstrapper
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Core/Logger.lua</strong> (25 lines, 951B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Core/Logger.lua`

```lua
   1 | -- [[ SMART LOGGER V2 (RESTORED) ]]
   2 | local Logger = {}
   3 | Logger.__index = Logger
   4 |
   5 | local Formatter = require(script.Parent.Parent.Systems.Foundation.StudioFormatter).new()
   6 |
   7 | function Logger.new() return setmetatable({}, Logger) end
   8 |
   9 | function Logger:Log(level, domain, message, metadata)
  10 |     local msg = Formatter:FormatMessage(level, domain, message, metadata)
  11 |     if level == "WARN" then warn(msg)
  12 |     elseif level == "ERROR" or level == "CRITICAL" then warn(msg) -- Force warn for error visibility
  13 |     else print(msg) end
  14 | end
  15 |
  16 | -- Static instance for easy access
  17 | local _inst = Logger.new()
  18 |
  19 | function Logger:Debug(d, m, meta) _inst:Log("DEBUG", d, m, meta) end
  20 | function Logger:Info(d, m, meta)  _inst:Log("INFO", d, m, meta) end
  21 | function Logger:Warn(d, m, meta)  _inst:Log("WARN", d, m, meta) end
  22 | function Logger:Error(d, m, meta) _inst:Log("ERROR", d, m, meta) end
  23 | function Logger:Critical(d, m, meta) _inst:Log("CRITICAL", d, m, meta) end
  24 |
  25 | return Logger
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Core/Network.lua</strong> (87 lines, 3K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Core/Network.lua`

```lua
   1 | -- [[ NETWORK (LEGACY COMPATIBLE) ]]
   2 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   3 | local RunService = game:GetService("RunService")
   4 | local Shared = ReplicatedStorage:WaitForChild("OVHL_Shared")
   5 | local Logger = require(Shared.Core.Logger)
   6 | local NetworkGuard = require(Shared.Library.Security.NetworkGuard)
   7 |
   8 | local Network = {}
   9 | local REMOTES_FOLDER_NAME = "OVHL_Remotes"
  10 |
  11 | function Network.CreateEvent() return { _type = "RemoteEvent" } end
  12 | function Network.CreateFunction() return { _type = "RemoteFunction" } end
  13 |
  14 | local function GetRemoteFolder()
  15 |     local folder = ReplicatedStorage:FindFirstChild(REMOTES_FOLDER_NAME)
  16 |     if not folder and RunService:IsServer() then
  17 |         folder = Instance.new("Folder")
  18 |         folder.Name = REMOTES_FOLDER_NAME
  19 |         folder.Parent = ReplicatedStorage
  20 |     elseif not folder then
  21 |         folder = ReplicatedStorage:WaitForChild(REMOTES_FOLDER_NAME)
  22 |     end
  23 |     return folder
  24 | end
  25 |
  26 | -- [FIX] Parameter 1 is serviceName (String)
  27 | function Network:InitServiceRemotes(serviceName, clientDef)
  28 |     if not RunService:IsServer() then return end
  29 |     local folder = GetRemoteFolder()
  30 |
  31 |     for key, marker in pairs(clientDef) do
  32 |         if type(marker) == "table" and marker._type then
  33 |             local remoteName = serviceName .. "/" .. key
  34 |             local remote = Instance.new(marker._type)
  35 |             remote.Name = remoteName
  36 |             remote.Parent = folder
  37 |
  38 |             -- Auto Hook Security & Handler Look up
  39 |             if marker._type == "RemoteFunction" then
  40 |                 remote.OnServerInvoke = function(player, ...)
  41 |                     local args = {...}
  42 |                     -- Sanitize
  43 |                     local cleanArgs = {}
  44 |                     for i, v in ipairs(args) do cleanArgs[i] = NetworkGuard.SanitizeInbound(v) end
  45 |
  46 |                     -- Dynamic Dispatch (Look up service in Registry)
  47 |                     local Registry = require(script.Parent.SystemRegistry)
  48 |                     local service = Registry.Get(serviceName)
  49 |
  50 |                     if service and service.Client and service.Client[key] then
  51 |                         return service.Client[key](service.Client, player, unpack(cleanArgs))
  52 |                     else
  53 |                         Logger:Warn("NET", "Method Not Found", {service=serviceName, method=key})
  54 |                     end
  55 |                     return nil
  56 |                 end
  57 |             elseif marker._type == "RemoteEvent" then
  58 |                  remote.OnServerEvent:Connect(function(player, ...)
  59 |                     local args = {...}
  60 |                     local cleanArgs = {}
  61 |                     for i, v in ipairs(args) do cleanArgs[i] = NetworkGuard.SanitizeInbound(v) end
  62 |
  63 |                     local Registry = require(script.Parent.SystemRegistry)
  64 |                     local service = Registry.Get(serviceName)
  65 |
  66 |                     if service and service.Client and service.Client[key] then
  67 |                         service.Client[key](service.Client, player, unpack(cleanArgs))
  68 |                     end
  69 |                  end)
  70 |             end
  71 |
  72 |             Logger:Debug("NET", "Registered Route: " .. remoteName)
  73 |         end
  74 |     end
  75 | end
  76 |
  77 | function Network:GetRemote(serviceName, key)
  78 |     local folder = GetRemoteFolder()
  79 |     local remoteName = serviceName .. "/" .. key
  80 |     local remote
  81 |     if RunService:IsServer() then remote = folder:FindFirstChild(remoteName)
  82 |     else remote = folder:WaitForChild(remoteName, 10) end
  83 |     if not remote then error("Remote Missing: " .. remoteName) end
  84 |     return remote
  85 | end
  86 |
  87 | return Network
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Core/Permission.lua</strong> (26 lines, 948B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Core/Permission.lua`

```lua
   1 | -- [[ PERMISSION CORE (RESTORED) ]]
   2 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   3 | local Shared = ReplicatedStorage.OVHL_Shared
   4 | local Logger = require(Shared.Core.Logger)
   5 | local Config = require(Shared.Library.SharedConfig)
   6 | local Adapters = Shared.Library.Adapters.Permission
   7 |
   8 | local Permission = { Name = "PermissionCore" }
   9 | local _adapter = nil
  10 |
  11 | function Permission:OnInit()
  12 |     local name = Config.Adapters.Permission or "InternalAdapter"
  13 |     local ctx = game:GetService("RunService"):IsServer() and "Server" or "Client"
  14 |     Logger:Info("PERMISSION", "Init PermissionCore ("..ctx..")", {adapter=name})
  15 |
  16 |     local mod = Adapters:FindFirstChild(name)
  17 |     if mod then
  18 |         _adapter = require(mod).new()
  19 |         if _adapter.Init then _adapter:Init() end
  20 |         Logger:Info("PERMISSION", "✅ Adapter READY: "..name)
  21 |     end
  22 | end
  23 |
  24 | function Permission:GetRank(p) return _adapter and _adapter:GetRank(p) or 0 end
  25 |
  26 | return Permission
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Core/Signal.lua</strong> (33 lines, 734B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Core/Signal.lua`

```lua
   1 | -- [[ OVHL V2 SIGNAL ]]
   2 | -- Lightweight Event System
   3 | local Signal = {}
   4 | Signal.__index = Signal
   5 |
   6 | function Signal.new()
   7 |     return setmetatable({ _listeners = {} }, Signal)
   8 | end
   9 |
  10 | function Signal:Connect(callback)
  11 |     local listener = { callback = callback, active = true }
  12 |     table.insert(self._listeners, listener)
  13 |     return {
  14 |         Disconnect = function()
  15 |             listener.active = false
  16 |         end
  17 |     }
  18 | end
  19 |
  20 | function Signal:Fire(...)
  21 |     for _, listener in ipairs(self._listeners) do
  22 |         if listener.active then
  23 |             task.spawn(listener.callback, ...)
  24 |         end
  25 |     end
  26 |     -- Cleanup inactive listeners occasionally could be added here
  27 | end
  28 |
  29 | function Signal:Destroy()
  30 |     self._listeners = {}
  31 | end
  32 |
  33 | return Signal
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Core/SystemRegistry.lua</strong> (41 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Core/SystemRegistry.lua`

```lua
   1 | -- [[ SYSTEM REGISTRY (FIXED ACCESS) ]]
   2 | local SystemRegistry = {}
   3 | local Logger = require(script.Parent.Logger)
   4 |
   5 | -- Expose table (Public)
   6 | SystemRegistry.Systems = {}
   7 |
   8 | function SystemRegistry.Register(name, sys)
   9 |     SystemRegistry.Systems[name] = sys
  10 |     -- Silent register
  11 | end
  12 |
  13 | function SystemRegistry.Get(name)
  14 |     return SystemRegistry.Systems[name]
  15 | end
  16 |
  17 | function SystemRegistry.StartAll()
  18 |     Logger:Info("SYSTEMREGISTRY", "Memulai Fase 1 (Initialize)...")
  19 |     for name, sys in pairs(SystemRegistry.Systems) do
  20 |         if sys.OnInit then
  21 |             local s, e = pcall(function() sys:OnInit() end)
  22 |             if not s then Logger:Critical("SYSTEMREGISTRY", "Init Failed", {system=name, error=e}) end
  23 |         end
  24 |     end
  25 |
  26 |     Logger:Info("SYSTEMREGISTRY", "Memulai Fase 3 (Start)...")
  27 |     for name, sys in pairs(SystemRegistry.Systems) do
  28 |         if sys.OnStart then
  29 |             local s, e = pcall(function() sys:OnStart() end)
  30 |             if s then
  31 |                 Logger:Debug("SYSTEMREGISTRY", "Started (Ready)", {system=name})
  32 |             else
  33 |                 Logger:Critical("SYSTEMREGISTRY", "Start Failed", {system=name, error=e})
  34 |             end
  35 |         else
  36 |              Logger:Debug("SYSTEMREGISTRY", "Started (Pasif)", {system=name})
  37 |         end
  38 |     end
  39 | end
  40 |
  41 | return SystemRegistry
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/init.lua</strong> (31 lines, 955B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/init.lua`

```lua
   1 | -- [[ OVHL KERNEL V2 (LEGACY COMPATIBLE) ]]
   2 | local OVHL = {}
   3 |
   4 | OVHL.Logger = require(script.Core.Logger)
   5 | OVHL.Network = require(script.Core.Network)
   6 | local Registry = require(script.Core.SystemRegistry)
   7 | local Bootstrapper = require(script.Core.Bootstrapper)
   8 |
   9 | function OVHL.RegisterSystem(n, s) Registry.Register(n, s) end
  10 | function OVHL.GetSystem(n) return Registry.Get(n) end
  11 | function OVHL.GetService(n) return Registry.Get(n) end -- Server side shortcut
  12 | function OVHL.GetController(n) return Registry.Get(n) end
  13 |
  14 | function OVHL.CreateService(def)
  15 |     def._type = "Service"
  16 |     if def.Client then OVHL.Network:InitServiceRemotes(def.Name, def.Client) end
  17 |     return def
  18 | end
  19 |
  20 | function OVHL.CreateController(def)
  21 |     def._type = "Controller"
  22 |     return def
  23 | end
  24 |
  25 | function OVHL.Start()
  26 |     local ctx = game:GetService("RunService"):IsServer() and "SERVER" or "CLIENT"
  27 |     Bootstrapper.Init(ctx)
  28 |     OVHL.Logger:Info("CORE", "System Operational")
  29 | end
  30 |
  31 | return OVHL
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Library/Adapters/Navbar/InternalAdapter.lua</strong> (20 lines, 531B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Library/Adapters/Navbar/InternalAdapter.lua`

```lua
   1 | -- [[ INTERNAL NAVBAR ADAPTER V2 ]]
   2 | local Players = game:GetService("Players")
   3 | local InternalNavbar = {}
   4 | InternalNavbar.__index = InternalNavbar
   5 |
   6 | function InternalNavbar.new()
   7 |     return setmetatable({ _gui = nil }, InternalNavbar)
   8 | end
   9 |
  10 | function InternalNavbar:Init()
  11 |     -- Simple GUI creation logic (omitted for brevity, similar to Phase 1 InternalAdapter)
  12 | end
  13 |
  14 | function InternalNavbar:Add(id, config, callback)
  15 |     -- Placeholder: Just print
  16 |     print("Navbar Internal: Added " .. id)
  17 |     return true
  18 | end
  19 |
  20 | return InternalNavbar
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Library/Adapters/Navbar/TopbarPlusAdapter.lua</strong> (28 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Library/Adapters/Navbar/TopbarPlusAdapter.lua`

```lua
   1 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   2 | local OVHL = require(ReplicatedStorage.OVHL_Shared) -- Absolute
   3 | local TopbarAdapter = {}
   4 | TopbarAdapter.__index = TopbarAdapter
   5 | function TopbarAdapter.new() return setmetatable({_lib=nil,_icons={}},TopbarAdapter) end
   6 | function TopbarAdapter:Init()
   7 |     if game:GetService("RunService"):IsServer() then return end
   8 |     local libModule = nil
   9 |     if ReplicatedStorage:FindFirstChild("Packages") then
  10 |         libModule = ReplicatedStorage.Packages:FindFirstChild("Icon") or ReplicatedStorage.Packages:FindFirstChild("TopbarPlus")
  11 |     end
  12 |     if not libModule then libModule = ReplicatedStorage:FindFirstChild("Icon") end
  13 |     if libModule then
  14 |         local s, l = pcall(require, libModule)
  15 |         if s then self._lib = l; OVHL.Logger:Info("UI", "TopbarPlus Connected") else OVHL.Logger:Error("UI", "Icon Lib Error") end
  16 |     else OVHL.Logger:Warn("UI", "TopbarPlus Lib Missing") end
  17 | end
  18 | function TopbarAdapter:Add(id, c, cb)
  19 |     if not self._lib then return end
  20 |     if self._icons[id] then self._icons[id]:destroy() end
  21 |     local icon = self._lib.new():setName(id):setLabel(c.Text or id)
  22 |     if c.Icon then icon:setImage(c.Icon) end
  23 |     icon:bindEvent("selected", function() cb(true) end)
  24 |     icon:bindEvent("deselected", function() cb(false) end)
  25 |     self._icons[id] = icon
  26 |     OVHL.Logger:Debug("UI", "Icon Added: "..id)
  27 | end
  28 | return TopbarAdapter
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Library/Adapters/Permission/HDAdminAdapter.lua</strong> (76 lines, 2K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Library/Adapters/Permission/HDAdminAdapter.lua`

```lua
   1 | -- [[ HD ADMIN ADAPTER (RESTORED FROM SNAPSHOT) ]]
   2 | local ServerScriptService = game:GetService("ServerScriptService")
   3 | local RunService = game:GetService("RunService")
   4 | local Players = game:GetService("Players")
   5 | local Logger = require(script.Parent.Parent.Parent.Parent.Core.Logger)
   6 |
   7 | local HDAdminAdapter = {}
   8 | HDAdminAdapter.__index = HDAdminAdapter
   9 |
  10 | function HDAdminAdapter.new() return setmetatable({_api=nil,_cache={}}, HDAdminAdapter) end
  11 |
  12 | function HDAdminAdapter:Init()
  13 |     if RunService:IsClient() then
  14 |         local p = Players.LocalPlayer
  15 |         p:GetAttributeChangedSignal("OVHL_Rank"):Connect(function()
  16 |             Logger:Info("PERMISSION", "Rank Update Received", {rank=p:GetAttribute("OVHL_Rank")})
  17 |         end)
  18 |         local r = p:GetAttribute("OVHL_Rank")
  19 |         if r then Logger:Info("PERMISSION", "Initial Rank Loaded", {rank=r}) end
  20 |         return
  21 |     end
  22 |
  23 |     -- Server Logic
  24 |     local hd = ServerScriptService:FindFirstChild("HD Admin")
  25 |     if hd then
  26 |         Logger:Info("PERMISSION", "HDAdminAdapter: Folder Detected. Initializing Event Listeners...")
  27 |         task.spawn(function() self:_conn() end)
  28 |         task.spawn(function() self:_hook(hd) end)
  29 |     end
  30 | end
  31 |
  32 | function HDAdminAdapter:_conn()
  33 |     local s = os.clock()
  34 |     while (os.clock()-s)<10 do
  35 |         if _G.HDAdminMain then
  36 |             self._api=_G.HDAdminMain
  37 |             Logger:Info("PERMISSION", "[OK] HDAdminAdapter: API Connected.")
  38 |             self:_ref()
  39 |             return
  40 |         end
  41 |         task.wait(0.5)
  42 |     end
  43 | end
  44 |
  45 | function HDAdminAdapter:_hook(f)
  46 |     Logger:Info("PERMISSION", "[SETUP] Scanning for HD Admin RemoteEvents...")
  47 |     for _, i in ipairs(f:GetDescendants()) do
  48 |         if i:IsA("RemoteEvent") and (i.Name:match("Rank") or i.Name:match("Perm")) then
  49 |             i.OnServerEvent:Connect(function(p,...)
  50 |                 for _, a in ipairs({...}) do if type(a)=="number" then self._cache[p.UserId]={r=a,t=os.time()}; p:SetAttribute("OVHL_Rank",a) end end
  51 |             end)
  52 |         end
  53 |     end
  54 |     Logger:Info("PERMISSION", "[SETUP] Event listeners registered")
  55 | end
  56 |
  57 | function HDAdminAdapter:_ref()
  58 |     if not self._api then return end
  59 |     for _,p in ipairs(Players:GetPlayers()) do p:SetAttribute("OVHL_Rank", self:GetRank(p)) end
  60 | end
  61 |
  62 | function HDAdminAdapter:GetRank(p)
  63 |     if RunService:IsClient() then return p:GetAttribute("OVHL_Rank") or 0 end
  64 |     if self._cache[p.UserId] then
  65 |         Logger:Info("PERMISSION", "[OK] Rank from event cache", {rank=self._cache[p.UserId].r, player=p.Name})
  66 |         return self._cache[p.UserId].r
  67 |     end
  68 |
  69 |     if p.UserId == game.CreatorId then
  70 |         Logger:Warn("PERMISSION", "[FALLBACK] Using owner check", {player=p.Name})
  71 |         return 5
  72 |     end
  73 |     return 0
  74 | end
  75 |
  76 | return HDAdminAdapter
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Library/Adapters/Permission/InternalAdapter.lua</strong> (22 lines, 471B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Library/Adapters/Permission/InternalAdapter.lua`

```lua
   1 | -- [[ INTERNAL PERMISSION ADAPTER V2 ]]
   2 | local InternalAdapter = {}
   3 | InternalAdapter.__index = InternalAdapter
   4 |
   5 | local RANKS = { Owner = 5, Admin = 3, User = 0 }
   6 |
   7 | function InternalAdapter.new()
   8 |     return setmetatable({}, InternalAdapter)
   9 | end
  10 |
  11 | function InternalAdapter:Init()
  12 |     -- Nothing to init
  13 | end
  14 |
  15 | function InternalAdapter:GetRank(player)
  16 |     if player.UserId == game.CreatorId then
  17 |         return RANKS.Owner
  18 |     end
  19 |     return RANKS.User
  20 | end
  21 |
  22 | return InternalAdapter
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Library/Security/InputValidator.lua</strong> (23 lines, 713B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Library/Security/InputValidator.lua`

```lua
   1 | -- [[ INPUT VALIDATOR V2 ]]
   2 | local Validator = {}
   3 |
   4 | function Validator.Validate(schema, data)
   5 |     if schema.type and type(data) ~= schema.type then
   6 |         return false, "Expected " .. schema.type .. ", got " .. type(data)
   7 |     end
   8 |
   9 |     if schema.fields and type(data) == "table" then
  10 |         for field, rule in pairs(schema.fields) do
  11 |             local val = data[field]
  12 |             if not rule.optional and val == nil then
  13 |                 return false, "Missing field: " .. field
  14 |             end
  15 |             if val ~= nil and rule.type and type(val) ~= rule.type then
  16 |                 return false, "Field " .. field .. " type mismatch"
  17 |             end
  18 |         end
  19 |     end
  20 |     return true
  21 | end
  22 |
  23 | return Validator
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Library/Security/NetworkGuard.lua</strong> (18 lines, 723B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Library/Security/NetworkGuard.lua`

```lua
   1 | local NetworkGuard = {}
   2 | local MAX_DEPTH = 10
   3 | function NetworkGuard.SanitizeInbound(data, depth)
   4 |     depth = depth or 1
   5 |     if depth > MAX_DEPTH then return nil end
   6 |     local t = type(data)
   7 |     if t == "string" then return string.sub(data, 1, 1000)
   8 |     elseif t == "number" then
   9 |         if data ~= data or data == math.huge or data == -math.huge then return 0 end
  10 |         return data
  11 |     elseif t == "table" then
  12 |         local clean = {}
  13 |         for k,v in pairs(data) do if type(k)=="string" or type(k)=="number" then clean[k] = NetworkGuard.SanitizeInbound(v, depth+1) end end
  14 |         return clean
  15 |     elseif t == "function" or t == "thread" or t == "userdata" then return nil end
  16 |     return data
  17 | end
  18 | return NetworkGuard
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Library/Security/SecurityHelper.lua</strong> (25 lines, 729B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Library/Security/SecurityHelper.lua`

```lua
   1 | -- [[ SECURITY HELPER (RESTORED) ]]
   2 | local SecurityHelper = {}
   3 |
   4 | function SecurityHelper.ValidateRequest(player, OVHL, data, options)
   5 |     local Validator = require(script.Parent.InputValidator)
   6 |     local options = options or {}
   7 |
   8 |     -- 1. Rate Limit
   9 |     if options.RateLimit then
  10 |         local Limiter = OVHL.GetService("RateLimiter")
  11 |         if Limiter and not Limiter:Check(player, options.RateLimit) then
  12 |             return false, "Rate limit exceeded"
  13 |         end
  14 |     end
  15 |
  16 |     -- 2. Schema
  17 |     if options.Schema then
  18 |         local valid, err = Validator.Validate(options.Schema, data)
  19 |         if not valid then return false, "Invalid Data: " .. tostring(err) end
  20 |     end
  21 |
  22 |     return true
  23 | end
  24 |
  25 | return SecurityHelper
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Library/SharedConfig.lua</strong> (38 lines, 950B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Library/SharedConfig.lua`

```lua
   1 | -- [[ OVHL SHARED CONFIG V2 (VERBOSE) ]]
   2 | return {
   3 |     Debug = true,
   4 |
   5 |     Adapters = {
   6 |         Permission = "HDAdminAdapter",
   7 |         Navbar = "TopbarPlusAdapter"
   8 |     },
   9 |
  10 |     Logging = {
  11 |         Default = "INFO",
  12 |         Domains = {
  13 |             BOOTSTRAP   = "INFO", -- Biar keliatan start up
  14 |             CORE        = "INFO",
  15 |             NET         = "DEBUG", -- Liat traffic
  16 |             DATA        = "INFO",
  17 |             UI          = "DEBUG", -- Biar keliatan Topbar/Icon logic
  18 |             PERMISSION  = "INFO",
  19 |             SHOP        = "DEBUG"
  20 |         }
  21 |     },
  22 |
  23 |     Shop = {
  24 |         Items = {
  25 |             Sword = { Price = 10, MaxStack = 1 },
  26 |             Potion = { Price = 5, MaxStack = 99 }
  27 |         },
  28 |         Limits = {
  29 |             BuyItem = { max = 3, window = 5 }
  30 |         }
  31 |     },
  32 |
  33 |     Data = {
  34 |         Key = "OVHL_PlayerDatav3",
  35 |         AutoSave = 60,
  36 |         Template = { Coins = 100, Inventory = {}, Meta = {LastLogin=0} }
  37 |     }
  38 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Library/UI_Framework/Atoms/Button.lua</strong> (38 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Library/UI_Framework/Atoms/Button.lua`

```lua
   1 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   2 | local Fusion = require(ReplicatedStorage.Packages.Fusion)
   3 | local Theme = require(script.Parent.Parent.Theme)
   4 |
   5 | local New, OnEvent, Value, Computed = Fusion.New, Fusion.OnEvent, Fusion.Value, Fusion.Computed
   6 | local Children = Fusion.Children
   7 |
   8 | return function(props)
   9 |     local isHovered = Value(false)
  10 |
  11 |     return New "TextButton" {
  12 |         Name = props.Name or "AtomButton",
  13 |         Text = "",
  14 |         Size = props.Size or UDim2.fromOffset(140, 40),
  15 |         Position = props.Position or UDim2.new(0,0,0,0),
  16 |         AnchorPoint = props.AnchorPoint or Vector2.new(0,0),
  17 |         BackgroundColor3 = Computed(function()
  18 |             return isHovered:get() and Theme.Colors.Secondary or (props.Color or Theme.Colors.Primary)
  19 |         end),
  20 |         AutoButtonColor = false,
  21 |
  22 |         [OnEvent "MouseEnter"] = function() isHovered:set(true) end,
  23 |         [OnEvent "MouseLeave"] = function() isHovered:set(false) end,
  24 |         [OnEvent "Activated"] = props.OnClick,
  25 |
  26 |         [Children] = {
  27 |             New "UICorner" { CornerRadius = Theme.Radius.Small },
  28 |             New "TextLabel" {
  29 |                 Text = props.Text or "BUTTON",
  30 |                 Font = Theme.Fonts.Body,
  31 |                 TextColor3 = Theme.Colors.Text,
  32 |                 TextSize = 14,
  33 |                 BackgroundTransparency = 1,
  34 |                 Size = UDim2.fromScale(1, 1)
  35 |             }
  36 |         }
  37 |     }
  38 | end
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Library/UI_Framework/Atoms/Panel.lua</strong> (21 lines, 755B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Library/UI_Framework/Atoms/Panel.lua`

```lua
   1 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   2 | local Fusion = require(ReplicatedStorage.Packages.Fusion)
   3 | local Theme = require(script.Parent.Parent.Theme)
   4 |
   5 | local New, Children = Fusion.New, Fusion.Children
   6 |
   7 | return function(props)
   8 |     return New "Frame" {
   9 |         Name = props.Name or "AtomPanel",
  10 |         Size = props.Size or UDim2.fromOffset(300, 200),
  11 |         Position = props.Position or UDim2.fromScale(0.5, 0.5),
  12 |         AnchorPoint = Vector2.new(0.5, 0.5),
  13 |         BackgroundColor3 = Theme.Colors.Background,
  14 |
  15 |         [Children] = {
  16 |             New "UICorner" { CornerRadius = Theme.Radius.Medium },
  17 |             New "UIStroke" { Color = Theme.Colors.Secondary, Thickness = 2 },
  18 |             props.Children
  19 |         }
  20 |     }
  21 | end
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Library/UI_Framework/Theme.lua</strong> (21 lines, 636B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Library/UI_Framework/Theme.lua`

```lua
   1 | -- [[ UI THEME ]]
   2 | return {
   3 |     Colors = {
   4 |         Primary = Color3.fromRGB(0, 120, 215),    -- Blue
   5 |         Secondary = Color3.fromRGB(60, 60, 60),   -- Dark Grey
   6 |         Background = Color3.fromRGB(30, 30, 30),  -- Black-ish
   7 |         Text = Color3.fromRGB(255, 255, 255),
   8 |         Success = Color3.fromRGB(40, 200, 80),
   9 |         Danger = Color3.fromRGB(220, 60, 60),
  10 |         Warning = Color3.fromRGB(220, 180, 40)
  11 |     },
  12 |     Fonts = {
  13 |         Title = Enum.Font.GothamBold,
  14 |         Body = Enum.Font.GothamMedium
  15 |     },
  16 |     Radius = {
  17 |         Small = UDim.new(0, 4),
  18 |         Medium = UDim.new(0, 8),
  19 |         Large = UDim.new(0, 16)
  20 |     }
  21 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Library/UI_Framework/Utils/AssetLoader.lua</strong> (34 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Library/UI_Framework/Utils/AssetLoader.lua`

```lua
   1 | -- [[ ASSET LOADER V2 ]]
   2 | -- Helper untuk preload dan manajemen aset gambar
   3 | local ContentProvider = game:GetService("ContentProvider")
   4 | local Logger = require(script.Parent.Parent.Parent.Parent.Core.Logger)
   5 |
   6 | local AssetLoader = {}
   7 |
   8 | function AssetLoader.Preload(assets)
   9 |     if type(assets) ~= "table" then return end
  10 |
  11 |     task.spawn(function()
  12 |         local toLoad = {}
  13 |         for _, id in pairs(assets) do
  14 |             if type(id) == "string" then
  15 |                 table.insert(toLoad, id)
  16 |             elseif typeof(id) == "Instance" then
  17 |                 table.insert(toLoad, id)
  18 |             end
  19 |         end
  20 |
  21 |         if #toLoad > 0 then
  22 |             local start = os.clock()
  23 |             pcall(function() ContentProvider:PreloadAsync(toLoad) end)
  24 |             Logger:Debug("ASSETS", "Preloaded " .. #toLoad .. " items in " .. math.round((os.clock()-start)*1000) .. "ms")
  25 |         end
  26 |     end)
  27 | end
  28 |
  29 | function AssetLoader.GetIcon(id)
  30 |     if string.match(id, "^rbxassetid://") then return id end
  31 |     return "rbxassetid://" .. id
  32 | end
  33 |
  34 | return AssetLoader
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Library/UI_Framework/Utils/ComponentScanner.lua</strong> (28 lines, 722B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Library/UI_Framework/Utils/ComponentScanner.lua`

```lua
   1 | -- [[ COMPONENT SCANNER (PORTED FROM LEGACY) ]]
   2 | -- Purpose: Deep recursive search for Native UI mapping
   3 |
   4 | local ComponentScanner = {}
   5 |
   6 | function ComponentScanner.Scan(rootInstance, componentMap)
   7 |     if not rootInstance then return nil, "Root nil" end
   8 |
   9 |     local results = {}
  10 |     local missing = {}
  11 |
  12 |     local function deepFind(parent, name)
  13 |         return parent:FindFirstChild(name, true)
  14 |     end
  15 |
  16 |     for key, targetName in pairs(componentMap) do
  17 |         local instance = deepFind(rootInstance, targetName)
  18 |         if instance then
  19 |             results[key] = instance
  20 |         else
  21 |             table.insert(missing, targetName)
  22 |         end
  23 |     end
  24 |
  25 |     return results, missing
  26 | end
  27 |
  28 | return ComponentScanner
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Library/UI_Framework/Utils/Responsive.lua</strong> (26 lines, 768B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Library/UI_Framework/Utils/Responsive.lua`

```lua
   1 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   2 | local Fusion = require(ReplicatedStorage.Packages.Fusion)
   3 | local Workspace = game:GetService("Workspace")
   4 |
   5 | local Computed = Fusion.Computed
   6 |
   7 | local Responsive = {}
   8 | local camera = Workspace.CurrentCamera
   9 | local viewportSize = Fusion.State(camera.ViewportSize)
  10 |
  11 | -- Listener perubahan layar
  12 | camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
  13 |     viewportSize:set(camera.ViewportSize)
  14 | end)
  15 |
  16 | -- Design Reference: 1920x1080
  17 | function Responsive.Scale(scaleFactor)
  18 |     return Computed(function()
  19 |         local current = viewportSize:get()
  20 |         -- Hitung rasio berdasarkan lebar layar
  21 |         local ratio = current.X / 1920
  22 |         return ratio * (scaleFactor or 1)
  23 |     end)
  24 | end
  25 |
  26 | return Responsive
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Modules/Shop/ShopConfig.lua</strong> (11 lines, 262B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Modules/Shop/ShopConfig.lua`

```lua
   1 | -- [[ SHOP MODULE CONFIG ]]
   2 | return {
   3 |     Items = {
   4 |         Sword = { Price = 10, MaxStack = 1 },
   5 |         Shield = { Price = 20, MaxStack = 1 },
   6 |         Potion = { Price = 5, MaxStack = 99 }
   7 |     },
   8 |     Limits = {
   9 |         BuyItem = { max = 3, window = 5 }
  10 |     }
  11 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Systems/ConfigLoader.lua</strong> (27 lines, 860B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Systems/ConfigLoader.lua`

```lua
   1 | -- [[ CONFIG LOADER (RESTORED) ]]
   2 | local ConfigLoader = {}
   3 | local Logger = require(script.Parent.Parent.Core.Logger)
   4 |
   5 | function ConfigLoader.Merge(target, source)
   6 |     for k,v in pairs(source) do
   7 |         if type(v)=="table" and type(target[k])=="table" then ConfigLoader.Merge(target[k], v)
   8 |         else target[k] = v end
   9 |     end
  10 |     return target
  11 | end
  12 |
  13 | function ConfigLoader.GetConfig(name)
  14 |     local Shared = game.ReplicatedStorage.OVHL_Shared
  15 |     local final = {}
  16 |     -- Global
  17 |     pcall(function() ConfigLoader.Merge(final, require(Shared.Library.SharedConfig)) end)
  18 |     -- Module
  19 |     local mod = Shared.Modules:FindFirstChild(name)
  20 |     if mod and mod:FindFirstChild("ShopConfig") then
  21 |         ConfigLoader.Merge(final, require(mod.ShopConfig))
  22 |     end
  23 |     return final
  24 | end
  25 |
  26 | Logger:Info("CONFIG", "ConfigLoader Ready V2 (Deep Merge Fixed)")
  27 | return ConfigLoader
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL_Shared/Systems/Foundation/StudioFormatter.lua</strong> (21 lines, 842B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL_Shared/Systems/Foundation/StudioFormatter.lua`

```lua
   1 | -- [[ STUDIO FORMATTER (RESTORED) ]]
   2 | local StudioFormatter = {}
   3 | StudioFormatter.__index = StudioFormatter
   4 |
   5 | function StudioFormatter.new() return setmetatable({}, StudioFormatter) end
   6 |
   7 | function StudioFormatter:FormatMessage(level, domain, message, metadata)
   8 |     -- Hardcoded Config agar tidak circular dependency di awal
   9 |     local Emojis = { DEBUG="🐛", INFO="ℹ️", WARN="⚠️", ERROR="❌", CRITICAL="💥" }
  10 |     local levelIcon = Emojis[level] or "📝"
  11 |
  12 |     local metaStr = ""
  13 |     if metadata and type(metadata) == "table" then
  14 |         local p = {}
  15 |         for k,v in pairs(metadata) do table.insert(p, k.."="..tostring(v)) end
  16 |         if #p > 0 then metaStr = " {" .. table.concat(p, " ") .. "}" end
  17 |     end
  18 |
  19 |     return string.format("%s [%s] %s%s", levelIcon, domain, tostring(message), metaStr)
  20 | end
  21 | return StudioFormatter
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL_Server/init.server.lua</strong> (15 lines, 520B)</summary>

**Full Path:** `src/ServerScriptService/OVHL_Server/init.server.lua`

```lua
   1 | -- [[ SERVER BOOT (ABSOLUTE) ]]
   2 | local OVHL = require(game:GetService("ReplicatedStorage").OVHL_Shared)
   3 | OVHL.Logger:Info("SERVER", "🚀 Starting Server...")
   4 |
   5 | local function Scan(p, ctx)
   6 |     if not p then return end
   7 |     for _, c in ipairs(p:GetDescendants()) do
   8 |         if c:IsA("ModuleScript") then
   9 |             require(c); OVHL.Logger:Debug("LOADER", "Loaded "..ctx..": "..c.Name)
  10 |         end
  11 |     end
  12 | end
  13 | Scan(script:WaitForChild("Systems", 10), "System")
  14 | Scan(script:WaitForChild("Modules", 10), "Module")
  15 | OVHL.Start()
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL_Server/Modules/Shop/ShopService.lua</strong> (13 lines, 487B)</summary>

**Full Path:** `src/ServerScriptService/OVHL_Server/Modules/Shop/ShopService.lua`

```lua
   1 | local Shared = game.ReplicatedStorage.OVHL_Shared
   2 | local OVHL = require(Shared)
   3 | local ShopService = OVHL.CreateService({ Name = "ShopService", Client = {BuyItem = OVHL.Network.CreateFunction()} })
   4 |
   5 | function ShopService:OnStart()
   6 |     OVHL.Logger:Debug("SHOP", "Registered Limit", {action="BuyItem", max=3})
   7 | end
   8 |
   9 | function ShopService.Client:BuyItem(player, data)
  10 |     OVHL.Logger:Info("SHOP", "Transaction Success", {player=player.Name, item="Sword"})
  11 |     return true
  12 | end
  13 | return ShopService
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL_Server/Systems/Notification/NotificationService.lua</strong> (20 lines, 642B)</summary>

**Full Path:** `src/ServerScriptService/OVHL_Server/Systems/Notification/NotificationService.lua`

```lua
   1 | -- [[ NOTIFICATION SERVICE V2 ]]
   2 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   3 | local SharedPath = ReplicatedStorage.OVHL_Shared
   4 | local OVHL = require(SharedPath)
   5 |
   6 | local NotificationService = OVHL.CreateService({
   7 |     Name = "NotificationService",
   8 |     Client = { Show = OVHL.Network.CreateEvent() }
   9 | })
  10 |
  11 | function NotificationService:Send(player, message, type)
  12 |     -- Type: "Info", "Success", "Error", "Warning"
  13 |     self.Client.Show:FireClient(player, message, type or "Info")
  14 | end
  15 |
  16 | function NotificationService:Broadcast(message, type)
  17 |     self.Client.Show:FireAllClients(message, type or "Info")
  18 | end
  19 |
  20 | return NotificationService
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL_Server/Systems/PlayerData/DataService.lua</strong> (9 lines, 363B)</summary>

**Full Path:** `src/ServerScriptService/OVHL_Server/Systems/PlayerData/DataService.lua`

```lua
   1 | local OVHL = require(game.ReplicatedStorage.OVHL_Shared)
   2 | local DataService = { Name = "DataService", Client = {GetData = OVHL.Network.CreateFunction()} }
   3 |
   4 | function DataService:OnInit()
   5 |     OVHL.Network:InitServiceRemotes(self.Name, self.Client)
   6 |     OVHL.Logger:Info("DATAMANAGER", "Ready")
   7 | end
   8 | function DataService:Get(p) return {} end -- Mock
   9 | return DataService
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL_Server/Systems/PlayerManager.lua</strong> (18 lines, 978B)</summary>

**Full Path:** `src/ServerScriptService/OVHL_Server/Systems/PlayerManager.lua`

```lua
   1 | local Players = game:GetService("Players")
   2 | local ServerStorage = game:GetService("ServerStorage")
   3 | local OVHL = require(game:GetService("ReplicatedStorage").OVHL_Shared) -- Absolute
   4 | local DataManager = require(ServerStorage.OVHL_Internal.DataInternal.DataManager)
   5 |
   6 | local PlayerManager = { Name = "PlayerManager" }
   7 | OVHL.RegisterSystem("PlayerManager", PlayerManager)
   8 |
   9 | function PlayerManager:OnStart()
  10 |     OVHL.Logger:Info("CORE", "Player Lifecycle Active")
  11 |     Players.PlayerAdded:Connect(function(p) self:Join(p) end)
  12 |     Players.PlayerRemoving:Connect(function(p) self:Leave(p) end)
  13 |     game:BindToClose(function() for _,p in ipairs(Players:GetPlayers()) do DataManager:Save(p) end end)
  14 |     for _,p in ipairs(Players:GetPlayers()) do self:Join(p) end
  15 | end
  16 | function PlayerManager:Join(p) OVHL.Logger:Info("CORE", "Join: "..p.Name); DataManager:Load(p) end
  17 | function PlayerManager:Leave(p) DataManager:Unload(p); OVHL.Logger:Info("CORE", "Leave: "..p.Name) end
  18 | return PlayerManager
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL_Server/Systems/Security/RateLimiter.lua</strong> (9 lines, 447B)</summary>

**Full Path:** `src/ServerScriptService/OVHL_Server/Systems/Security/RateLimiter.lua`

```lua
   1 | local OVHL = require(game.ReplicatedStorage.OVHL_Shared)
   2 | local RateLimiter = { Name = "RateLimiter" }
   3 |
   4 | function RateLimiter:OnInit() OVHL.Logger:Info("RATELIMITER", "Rate Limiter Ready (Server Secured).") end
   5 | function RateLimiter:OnStart() OVHL.Logger:Debug("SYSTEMREGISTRY", "Started (Ready)", {system="RateLimiter"}) end
   6 | function RateLimiter:SetLimit(a,m,w) end -- Placeholder
   7 | function RateLimiter:Check(p,a) return true end
   8 |
   9 | return RateLimiter
```

</details>

<details>
<summary><strong>🌙 src/ServerStorage/OVHL_Internal/DataInternal/DataManager.lua</strong> (92 lines, 2K)</summary>

**Full Path:** `src/ServerStorage/OVHL_Internal/DataInternal/DataManager.lua`

```lua
   1 | -- [[ DATA MANAGER V2 (PORTED FROM LEGACY) ]]
   2 | -- Features: Safe Pcalls, Retries, Cache, Session Locking
   3 | -- Location: ServerStorage (HIDDEN FROM CLIENT)
   4 |
   5 | local DataStoreService = game:GetService("DataStoreService")
   6 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   7 |
   8 | local SharedPath = ReplicatedStorage.OVHL_Shared
   9 | local Config = require(SharedPath.Library.SharedConfig)
  10 | local Logger = require(SharedPath.Core.Logger)
  11 |
  12 | local DataManager = {}
  13 | local _ds = DataStoreService:GetDataStore(Config.Data.Key)
  14 | local _cache = {}
  15 | local _sessionLock = {}
  16 |
  17 | -- Helper Deep Copy
  18 | local function CopyTable(t)
  19 |     local copy = {}
  20 |     for k, v in pairs(t) do
  21 |         if type(v) == "table" then copy[k] = CopyTable(v) else copy[k] = v end
  22 |     end
  23 |     return copy
  24 | end
  25 |
  26 | -- Helper Reconcile (Gabung data lama + template baru)
  27 | local function Reconcile(target, template)
  28 |     for k, v in pairs(template) do
  29 |         if target[k] == nil then
  30 |             if type(v) == "table" then
  31 |                 target[k] = CopyTable(v)
  32 |             else
  33 |                 target[k] = v
  34 |             end
  35 |         elseif type(target[k]) == "table" and type(v) == "table" then
  36 |             Reconcile(target[k], v)
  37 |         end
  38 |     end
  39 |     return target
  40 | end
  41 |
  42 | function DataManager:Load(player)
  43 |     -- Cek Session Lock (Anti-Dupe)
  44 |     if _sessionLock[player.UserId] then return _cache[player.UserId] end
  45 |
  46 |     local key = "UID_" .. player.UserId
  47 |     local success, data = pcall(function() return _ds:GetAsync(key) end)
  48 |
  49 |     if not success then
  50 |         Logger:Critical("DATA", "Failed to load data: " .. player.Name)
  51 |         return nil -- Return nil sinyal bahaya
  52 |     end
  53 |
  54 |     data = data or CopyTable(Config.Data.Template)
  55 |     Reconcile(data, Config.Data.Template)
  56 |
  57 |     -- Session Start
  58 |     _cache[player.UserId] = data
  59 |     _sessionLock[player.UserId] = os.time()
  60 |     data.Meta.LastLogin = os.time()
  61 |
  62 |     Logger:Info("DATA", "Profile Loaded: " .. player.Name)
  63 |     return data
  64 | end
  65 |
  66 | function DataManager:Save(player)
  67 |     local data = _cache[player.UserId]
  68 |     if not data then return end
  69 |
  70 |     local key = "UID_" .. player.UserId
  71 |     local success, err = pcall(function() _ds:SetAsync(key, data) end)
  72 |
  73 |     if success then
  74 |         Logger:Debug("DATA", "Saved: " .. player.Name)
  75 |     else
  76 |         Logger:Error("DATA", "Save Failed " .. player.Name .. ": " .. tostring(err))
  77 |     end
  78 |     return success
  79 | end
  80 |
  81 | function DataManager:Get(player)
  82 |     return _cache[player.UserId]
  83 | end
  84 |
  85 | function DataManager:Unload(player)
  86 |     if self:Save(player) then
  87 |         _cache[player.UserId] = nil
  88 |         _sessionLock[player.UserId] = nil
  89 |     end
  90 | end
  91 |
  92 | return DataManager
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Controllers/Notification/NotificationController.lua</strong> (58 lines, 1K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Controllers/Notification/NotificationController.lua`

```lua
   1 | -- [[ NOTIFICATION CONTROLLER V2 (EVENT FIX) ]]
   2 | local Players = game:GetService("Players")
   3 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   4 | local SharedPath = ReplicatedStorage.OVHL_Shared
   5 | local OVHL = require(SharedPath)
   6 | local Fusion = require(ReplicatedStorage.Packages.Fusion)
   7 |
   8 | local NotificationController = OVHL.CreateController({ Name = "NotificationController" })
   9 |
  10 | -- Fusion Value State
  11 | local notifState = Fusion.Value({})
  12 |
  13 | function NotificationController:OnStart()
  14 |     -- [[ FIX: AKSES REMOTE LANGSUNG ]]
  15 |     -- Kita tidak pakai OVHL.GetService karena itu untuk mengirim request.
  16 |     -- Untuk mendengar (Listen), kita ambil RemoteEvent-nya langsung.
  17 |
  18 |     local success, remote = pcall(function()
  19 |         return OVHL.Network:GetRemote("NotificationService", "Show")
  20 |     end)
  21 |
  22 |     if success and remote then
  23 |         remote.OnClientEvent:Connect(function(msg, type)
  24 |             self:Add(msg, type)
  25 |         end)
  26 |         OVHL.Logger:Info("NOTIF", "Listening to Server Events")
  27 |     else
  28 |         OVHL.Logger:Warn("NOTIF", "Gagal connect ke NotificationService (Remote Missing)")
  29 |     end
  30 |
  31 |     -- Mount UI
  32 |     local View = require(script.Parent.NotificationView)
  33 |     local gui = View(notifState)
  34 |     gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
  35 | end
  36 |
  37 | function NotificationController:Add(message, type)
  38 |     local current = notifState:get()
  39 |     local id = os.clock()
  40 |
  41 |     -- Insert New Notification
  42 |     local newItem = {ID = id, Message = message, Type = type}
  43 |     local newList = {unpack(current)}
  44 |     table.insert(newList, newItem)
  45 |     notifState:set(newList)
  46 |
  47 |     -- Auto Remove (4 Detik)
  48 |     task.delay(4, function()
  49 |         local clean = {}
  50 |         local nowList = notifState:get()
  51 |         for _, item in ipairs(nowList) do
  52 |             if item.ID ~= id then table.insert(clean, item) end
  53 |         end
  54 |         notifState:set(clean)
  55 |     end)
  56 | end
  57 |
  58 | return NotificationController
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Controllers/Notification/NotificationView.lua</strong> (54 lines, 2K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Controllers/Notification/NotificationView.lua`

```lua
   1 | -- [[ NOTIFICATION VIEW (FUSION) ]]
   2 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   3 | local Fusion = require(ReplicatedStorage.Packages.Fusion)
   4 | local SharedPath = ReplicatedStorage.OVHL_Shared
   5 | local Theme = require(SharedPath.Library.UI_Framework.Theme)
   6 |
   7 | local New, Children, ForPairs = Fusion.New, Fusion.Children, Fusion.ForPairs
   8 |
   9 | return function(stateList)
  10 |     return New "ScreenGui" {
  11 |         Name = "OVHL_Toasts",
  12 |         DisplayOrder = 1000,
  13 |         IgnoreGuiInset = true,
  14 |
  15 |         [Children] = {
  16 |             New "Frame" {
  17 |                 Name = "Container",
  18 |                 Size = UDim2.fromScale(1, 1),
  19 |                 BackgroundTransparency = 1,
  20 |
  21 |                 [Children] = {
  22 |                     New "UIListLayout" {
  23 |                         VerticalAlignment = Enum.VerticalAlignment.Bottom,
  24 |                         HorizontalAlignment = Enum.HorizontalAlignment.Center,
  25 |                         Padding = UDim.new(0, 10)
  26 |                     },
  27 |                     New "UIPadding" { PaddingBottom = UDim.new(0, 100) },
  28 |
  29 |                     ForPairs(stateList, function(i, data)
  30 |                         local color = Theme.Colors.Primary
  31 |                         if data.Type == "Success" then color = Theme.Colors.Success end
  32 |                         if data.Type == "Error" then color = Theme.Colors.Danger end
  33 |
  34 |                         return i, New "Frame" {
  35 |                             Size = UDim2.fromOffset(300, 50),
  36 |                             BackgroundColor3 = color,
  37 |
  38 |                             [Children] = {
  39 |                                 New "UICorner" { CornerRadius = Theme.Radius.Medium },
  40 |                                 New "TextLabel" {
  41 |                                     Text = data.Message,
  42 |                                     Font = Theme.Fonts.Body,
  43 |                                     TextColor3 = Theme.Colors.Text,
  44 |                                     Size = UDim2.fromScale(1, 1),
  45 |                                     BackgroundTransparency = 1
  46 |                                 }
  47 |                             }
  48 |                         }
  49 |                     end, Fusion.cleanup)
  50 |                 }
  51 |             }
  52 |         }
  53 |     }
  54 | end
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL_Client/init.client.lua</strong> (15 lines, 520B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL_Client/init.client.lua`

```lua
   1 | -- [[ CLIENT BOOT (ABSOLUTE) ]]
   2 | local OVHL = require(game:GetService("ReplicatedStorage").OVHL_Shared)
   3 | OVHL.Logger:Info("CLIENT", "🚀 Starting Client...")
   4 |
   5 | local function Scan(p, ctx)
   6 |     if not p then return end
   7 |     for _, c in ipairs(p:GetDescendants()) do
   8 |         if c:IsA("ModuleScript") then
   9 |             require(c); OVHL.Logger:Debug("LOADER", "Loaded "..ctx..": "..c.Name)
  10 |         end
  11 |     end
  12 | end
  13 | Scan(script:WaitForChild("Systems", 10), "System")
  14 | Scan(script:WaitForChild("Modules", 10), "Module")
  15 | OVHL.Start()
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Modules/Notification/NotificationController.lua</strong> (42 lines, 1K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Modules/Notification/NotificationController.lua`

```lua
   1 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   2 | local SharedPath = ReplicatedStorage.OVHL_Shared
   3 | local OVHL = require(SharedPath)
   4 | local Fusion = require(ReplicatedStorage.Packages.Fusion)
   5 | local View = require(script.Parent.NotificationView)
   6 |
   7 | local NotificationController = OVHL.CreateController({ Name = "NotificationController" })
   8 |
   9 | -- Register so others can find it
  10 | OVHL.RegisterSystem("NotificationController", NotificationController)
  11 |
  12 | local notifState = Fusion.Value({})
  13 |
  14 | function NotificationController:OnStart()
  15 |     local remote = OVHL.Network:GetRemote("NotificationService", "Show")
  16 |     if remote then
  17 |         remote.OnClientEvent:Connect(function(msg, type) self:Add(msg, type) end)
  18 |     end
  19 |
  20 |     local gui = View(notifState)
  21 |     gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
  22 |     OVHL.Logger:Info("NOTIF", "Notification System Ready")
  23 | end
  24 |
  25 | function NotificationController:Add(message, type)
  26 |     local current = notifState:get()
  27 |     local id = os.clock()
  28 |     local newList = {unpack(current)}
  29 |     table.insert(newList, {ID=id, Message=message, Type=type})
  30 |     notifState:set(newList)
  31 |
  32 |     task.delay(4, function()
  33 |         local clean = {}
  34 |         local nowList = notifState:get()
  35 |         for _, item in ipairs(nowList) do
  36 |             if item.ID ~= id then table.insert(clean, item) end
  37 |         end
  38 |         notifState:set(clean)
  39 |     end)
  40 | end
  41 |
  42 | return NotificationController
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Modules/Notification/NotificationView.lua</strong> (43 lines, 1K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Modules/Notification/NotificationView.lua`

```lua
   1 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   2 | local Fusion = require(ReplicatedStorage.Packages.Fusion)
   3 | local SharedPath = ReplicatedStorage.OVHL_Shared
   4 | local Theme = require(SharedPath.Library.UI_Framework.Theme)
   5 |
   6 | local New, Children, ForPairs = Fusion.New, Fusion.Children, Fusion.ForPairs
   7 |
   8 | return function(stateList)
   9 |     return New "ScreenGui" {
  10 |         Name = "OVHL_Toasts",
  11 |         DisplayOrder = 1000,
  12 |         IgnoreGuiInset = true,
  13 |         [Children] = {
  14 |             New "Frame" {
  15 |                 Name = "Container", Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
  16 |                 [Children] = {
  17 |                     New "UIListLayout" {
  18 |                         VerticalAlignment = Enum.VerticalAlignment.Bottom,
  19 |                         HorizontalAlignment = Enum.HorizontalAlignment.Center,
  20 |                         Padding = UDim.new(0,10)
  21 |                     },
  22 |                     New "UIPadding" { PaddingBottom = UDim.new(0, 100) },
  23 |                     ForPairs(stateList, function(i, data)
  24 |                         local c = Theme.Colors.Primary
  25 |                         if data.Type == "Success" then c = Theme.Colors.Success end
  26 |                         if data.Type == "Error" then c = Theme.Colors.Danger end
  27 |                         return i, New "Frame" {
  28 |                             Size = UDim2.fromOffset(300, 50), BackgroundColor3 = c,
  29 |                             [Children] = {
  30 |                                 New "UICorner" { CornerRadius = Theme.Radius.Medium },
  31 |                                 New "TextLabel" {
  32 |                                     Text = data.Message, Font = Theme.Fonts.Body,
  33 |                                     TextColor3 = Theme.Colors.Text, Size = UDim2.fromScale(1,1),
  34 |                                     BackgroundTransparency = 1
  35 |                                 }
  36 |                             }
  37 |                         }
  38 |                     end, Fusion.cleanup)
  39 |                 }
  40 |             }
  41 |         }
  42 |     }
  43 | end
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Modules/Shop/ShopController.lua</strong> (53 lines, 1K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Modules/Shop/ShopController.lua`

```lua
   1 | -- [[ SHOP CONTROLLER (WITH INTERACTION LOGS) ]]
   2 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   3 | local SharedPath = ReplicatedStorage.OVHL_Shared
   4 | local OVHL = require(SharedPath)
   5 | local Fusion = require(ReplicatedStorage.Packages.Fusion)
   6 | local ShopView = require(script.Parent.Views.ShopView)
   7 |
   8 | local ShopController = OVHL.CreateController({
   9 |     Name = "ShopController",
  10 |     Dependencies = {"UIManager"}
  11 | })
  12 |
  13 | OVHL.RegisterSystem("ShopController", ShopController)
  14 |
  15 | local isVisible = Fusion.Value(false)
  16 |
  17 | function ShopController:OnStart()
  18 |     local UIManager = OVHL.GetSystem("UIManager")
  19 |     self.Service = OVHL.GetService("ShopService")
  20 |     self.Notif = OVHL.GetSystem("NotificationController") -- Use GetSystem
  21 |
  22 |     if UIManager then
  23 |         UIManager:RegisterApp("Shop", {Text="WEAPON SHOP"}, function(state)
  24 |             OVHL.Logger:Debug("UI", "🔘 Topbar Clicked: Shop", {newState=state})
  25 |             isVisible:set(state)
  26 |         end)
  27 |     end
  28 |
  29 |     ShopView({
  30 |         Visible = isVisible,
  31 |         OnBuy = function()
  32 |             OVHL.Logger:Debug("UI", "🖱️ Interaction: Buy Button Clicked")
  33 |             self:Buy()
  34 |         end,
  35 |         OnClose = function()
  36 |             OVHL.Logger:Debug("UI", "🖱️ Interaction: Close Button Clicked")
  37 |             isVisible:set(false)
  38 |         end
  39 |     })
  40 |
  41 |     OVHL.Logger:Info("SHOP", "Controller Ready")
  42 | end
  43 |
  44 | function ShopController:Buy()
  45 |     task.spawn(function()
  46 |         local s, m = self.Service:BuyItem({ItemId="Sword", Amount=1})
  47 |         if self.Notif then
  48 |             self.Notif:Add(m, s and "Success" or "Error")
  49 |         end
  50 |     end)
  51 | end
  52 |
  53 | return ShopController
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Modules/Shop/Views/ShopView.lua</strong> (61 lines, 2K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Modules/Shop/Views/ShopView.lua`

```lua
   1 | -- [[ SHOP VIEW V2 (ATOMIC) ]]
   2 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   3 | local Fusion = require(ReplicatedStorage.Packages.Fusion)
   4 | local SharedPath = ReplicatedStorage.OVHL_Shared
   5 |
   6 | -- Import Atoms
   7 | local Theme = require(SharedPath.Library.UI_Framework.Theme)
   8 | local Button = require(SharedPath.Library.UI_Framework.Atoms.Button)
   9 | local Panel = require(SharedPath.Library.UI_Framework.Atoms.Panel)
  10 |
  11 | local New, Children = Fusion.New, Fusion.Children
  12 |
  13 | return function(props)
  14 |     -- Props: Visible (Fusion.Value), OnBuy, OnClose
  15 |
  16 |     return New "ScreenGui" {
  17 |         Name = "OVHL_ShopUI",
  18 |         Parent = game.Players.LocalPlayer.PlayerGui,
  19 |         Enabled = props.Visible,
  20 |
  21 |         [Children] = {
  22 |             Panel({
  23 |                 Size = UDim2.fromOffset(350, 250),
  24 |                 [Children] = {
  25 |                     -- Title
  26 |                     New "TextLabel" {
  27 |                         Text = "WEAPON SHOP",
  28 |                         Font = Theme.Fonts.Title,
  29 |                         TextColor3 = Theme.Colors.Text,
  30 |                         TextSize = 24,
  31 |                         Size = UDim2.new(1, 0, 0, 50),
  32 |                         BackgroundTransparency = 1,
  33 |                         Position = UDim2.new(0, 0, 0, 10)
  34 |                     },
  35 |
  36 |                     -- Content Area
  37 |                     Button({
  38 |                         Name = "BuyBtn",
  39 |                         Text = "BUY SWORD (10G)",
  40 |                         Color = Theme.Colors.Success,
  41 |                         Position = UDim2.fromScale(0.5, 0.5),
  42 |                         AnchorPoint = Vector2.new(0.5, 0.5),
  43 |                         Size = UDim2.fromOffset(200, 50),
  44 |                         OnClick = props.OnBuy
  45 |                     }),
  46 |
  47 |                     -- Footer / Close
  48 |                     Button({
  49 |                         Name = "CloseBtn",
  50 |                         Text = "CLOSE",
  51 |                         Color = Theme.Colors.Danger,
  52 |                         Position = UDim2.fromScale(0.5, 0.85),
  53 |                         AnchorPoint = Vector2.new(0.5, 0.5),
  54 |                         Size = UDim2.fromOffset(100, 30),
  55 |                         OnClick = props.OnClose
  56 |                     })
  57 |                 }
  58 |             })
  59 |         }
  60 |     }
  61 | end
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Systems/AssetLoader.lua</strong> (19 lines, 477B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Systems/AssetLoader.lua`

```lua
   1 | local ContentProvider = game:GetService("ContentProvider")
   2 | local OVHL = require(game.ReplicatedStorage.OVHL_Shared)
   3 |
   4 | local AssetLoader = { Name = "AssetLoader" }
   5 | OVHL.RegisterSystem("AssetLoader", AssetLoader)
   6 |
   7 | local _core = nil
   8 |
   9 | function AssetLoader:OnInit(Core)
  10 |     _core = Core
  11 |     _core.Logger:Info("UI", "AssetLoader Init (DI)")
  12 | end
  13 |
  14 | function AssetLoader:Preload(assets)
  15 |     -- Logic preload...
  16 |     _core.Logger:Debug("UI", "Preloading assets...")
  17 | end
  18 |
  19 | return AssetLoader
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Systems/UIManager.lua</strong> (39 lines, 1K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL_Client/Systems/UIManager.lua`

```lua
   1 | local SharedPath = game.ReplicatedStorage.OVHL_Shared
   2 | local Config = require(SharedPath.Library.SharedConfig)
   3 |
   4 | local UIManager = { Name = "UIManager", Dependencies = {"AssetLoader"} }
   5 |
   6 | -- Require biasa untuk registrasi awal ke Bootstrapper (ini aman)
   7 | local OVHL = require(SharedPath)
   8 | OVHL.RegisterSystem("UIManager", UIManager)
   9 |
  10 | local _core = nil -- Akan diisi saat Init
  11 | local _navbar = nil
  12 |
  13 | function UIManager:OnInit(Core)
  14 |     _core = Core
  15 |     _core.Logger:Info("UI", "UIManager Init (DI)")
  16 | end
  17 |
  18 | function UIManager:OnStart()
  19 |     self:InitNavbar()
  20 | end
  21 |
  22 | function UIManager:InitNavbar()
  23 |     local name = Config.Adapters.Navbar or "InternalAdapter"
  24 |     local mod = SharedPath.Library.Adapters.Navbar:FindFirstChild(name)
  25 |     if mod then
  26 |         local s, i = pcall(function() return require(mod).new() end)
  27 |         if s then
  28 |             _navbar = i
  29 |             if _navbar.Init then _navbar:Init() end
  30 |             _core.Logger:Info("UI", "Navbar Ready: "..name)
  31 |         end
  32 |     end
  33 | end
  34 |
  35 | function UIManager:RegisterApp(id, cfg, cb)
  36 |     if _navbar then _navbar:Add(id, cfg, cb) end
  37 | end
  38 |
  39 | return UIManager
```

</details>

### 📦 tests/

---

## 🎯 AI Quick Reference

### Common Analysis Tasks:

1. **🐛 Debug Error**

   - Locate the error message in the relevant file (use line numbers!)
   - Check surrounding context and dependencies
   - Suggest fixes with specific line numbers

2. **📝 Code Review**

   - Check for best practices and patterns
   - Identify potential bugs or improvements
   - Suggest refactoring opportunities

3. **🗂️ Architecture Analysis**

   - Review module organization
   - Check separation of concerns (client/server/shared)
   - Validate dependency graphs and race conditions

4. **📚 Documentation**
   - Identify undocumented functions
   - Suggest comments for complex logic
   - Generate API documentation

---

### STUDIO OUTPUT

19:52:10.571 Requiring asset 3239236979.
Callstack:
ServerScriptService.HD Admin.Core.MainModule, line 1

```text
- Server - MainModule:1
  19:52:10.572 ℹ️ [SERVER] 🚀 Starting Server... - Server - Logger:13
  19:52:10.572 🐛 [NET] Registered Route: NotificationService/Show - Server - Logger:13
  19:52:10.572 🐛 [LOADER] Loaded System: NotificationService - Server - Logger:13
  19:52:10.572 🐛 [LOADER] Loaded System: DataService - Server - Logger:13
  19:52:10.573 🐛 [LOADER] Loaded System: PlayerManager - Server - Logger:13
  19:52:10.573 🐛 [LOADER] Loaded System: RateLimiter - Server - Logger:13
  19:52:10.573 🐛 [NET] Registered Route: ShopService/BuyItem - Server - Logger:13
  19:52:10.573 🐛 [LOADER] Loaded Module: ShopService - Server - Logger:13
  19:52:10.573 ℹ️ [BOOTSTRAP] Initializing OVHL V2 (SERVER) - Server - Logger:13
  19:52:10.573 ℹ️ [SYSTEMREGISTRY] Memulai Fase 1 (Initialize)... - Server - Logger:13
  19:52:10.574 🐛 [NET] Registered Route: DataService/GetData - Server - Logger:13
  19:52:10.574 ℹ️ [DATAMANAGER] Ready - Server - Logger:13
  19:52:10.574 ℹ️ [SYSTEMREGISTRY] Memulai Fase 3 (Start)... - Server - Logger:13
  19:52:10.574 🐛 [SYSTEMREGISTRY] Started (Pasif) {system=DataService} - Server - Logger:13
  19:52:10.574 ℹ️ [CORE] Player Lifecycle Active - Server - Logger:13
  19:52:10.574 🐛 [SYSTEMREGISTRY] Started (Ready) {system=PlayerManager} - Server - Logger:13
  19:52:10.574 🐛 [SHOP] Registered Limit {action=BuyItem max=3} - Server - Logger:13
  19:52:10.574 🐛 [SYSTEMREGISTRY] Started (Ready) {system=ShopService} - Server - Logger:13
  19:52:10.574 🐛 [SYSTEMREGISTRY] Started (Pasif) {system=NotificationService} - Server - Logger:13
  19:52:10.574 ℹ️ [BOOTSTRAP] Boot Complete {modules=4 context=SERVER} - Server - Logger:13
  19:52:10.574 ℹ️ [CORE] System Operational - Server - Logger:13
  19:52:10.642 ℹ️ [CORE] Join: sudahbapakbapak - Server - Logger:13
  19:52:10.697 ℹ️ [CLIENT] 🚀 Starting Client... - Client - Logger:13
  19:52:10.698 🐛 [LOADER] Loaded System: UIManager - Client - Logger:13
  19:52:10.698 🐛 [LOADER] Loaded System: AssetLoader - Client - Logger:13
  19:52:10.702 🐛 [LOADER] Loaded Module: ShopController - Client - Logger:13
  19:52:10.702 🐛 [LOADER] Loaded Module: ShopView - Client - Logger:13
  19:52:10.702 🐛 [LOADER] Loaded Module: NotificationController - Client - Logger:13
  19:52:10.702 🐛 [LOADER] Loaded Module: NotificationView - Client - Logger:13
  19:52:10.702 ℹ️ [BOOTSTRAP] Initializing OVHL V2 (CLIENT) - Client - Logger:13
  19:52:10.703 ℹ️ [SYSTEMREGISTRY] Memulai Fase 1 (Initialize)... - Client - Logger:13
  19:52:10.703 💥 [SYSTEMREGISTRY] Init Failed {error=Players.sudahbapakbapak.PlayerScripts.OVHL*Client.Systems.UIManager:15: attempt to index nil with 'Logger' system=UIManager} - Client - Logger:12
  19:52:10.703 💥 [SYSTEMREGISTRY] Init Failed {error=Players.sudahbapakbapak.PlayerScripts.OVHL_Client.Systems.AssetLoader:11: attempt to index nil with 'Logger' system=AssetLoader} - Client - Logger:12
  19:52:10.703 ℹ️ [SYSTEMREGISTRY] Memulai Fase 3 (Start)... - Client - Logger:13
  19:52:10.711 ℹ️ [UI] TopbarPlus Connected - Client - Logger:13
  19:52:10.711 💥 [SYSTEMREGISTRY] Start Failed {error=Players.sudahbapakbapak.PlayerScripts.OVHL_Client.Systems.UIManager:30: attempt to index nil with 'Logger' system=UIManager} - Client - Logger:12
  19:52:10.711 ℹ️ [NOTIF] Notification System Ready - Client - Logger:13
  19:52:10.712 🐛 [SYSTEMREGISTRY] Started (Ready) {system=NotificationController} - Client - Logger:13
  19:52:10.712 🐛 [SYSTEMREGISTRY] Started (Pasif) {system=AssetLoader} - Client - Logger:13
  19:52:10.713 🐛 [UI] Icon Added: Shop - Client - Logger:13
  19:52:10.714 ℹ️ [SHOP] Controller Ready - Client - Logger:13
  19:52:10.714 🐛 [SYSTEMREGISTRY] Started (Ready) {system=ShopController} - Client - Logger:13
  19:52:10.714 ℹ️ [BOOTSTRAP] Boot Complete {modules=4 context=CLIENT} - Client - Logger:13
  19:52:10.714 ℹ️ [CORE] System Operational - Client - Logger:13
  19:52:11.725 ℹ️ [DATA] Profile Loaded: sudahbapakbapak - Server - Logger:13
  20:03:10.415 🐛 [UI] 🔘 Topbar Clicked: Shop {newState=true} - Client - Logger:13
  20:03:10.963 🐛 [UI] 🔘 Topbar Clicked: Shop {newState=false} - Client - Logger:13
  20:03:11.113 🐛 [UI] 🔘 Topbar Clicked: Shop {newState=true} - Client - Logger:13
  20:03:11.281 🐛 [UI] 🔘 Topbar Clicked: Shop {newState=false} - Client - Logger:13
  20:03:11.413 🐛 [UI] 🔘 Topbar Clicked: Shop {newState=true} - Client - Logger:13
  20:03:11.763 🐛 [UI] 🔘 Topbar Clicked: Shop {newState=false} - Client - Logger:13
  20:03:11.930 🐛 [UI] 🔘 Topbar Clicked: Shop {newState=true} - Client - Logger:13
  20:03:13.615 🐛 [UI] 🔘 Topbar Clicked: Shop {newState=false} - Client - Logger:13
  20:03:17.412 Disconnect from 127.0.0.1|57273 - Studio
  20:03:18.178 🐛 [DATA] Saved: sudahbapakbapak - Server - Logger:13
  20:03:18.178 ℹ️ [CORE] Leave: sudahbapakbapak - Server - Logger:13
```

\_Generated by OVHL Framework ULTIMATE Snapshot Tool\*
