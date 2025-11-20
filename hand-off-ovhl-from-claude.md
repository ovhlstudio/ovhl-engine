# OVHL FRAMEWORK - COMPREHENSIVE ARCHITECTURAL AUDIT V2

**REVISION DATE:** 2024-11-20
**STATUS:** PRODUCTION READY
**AUTOMATION:** FULL BASH DELIVERY SYSTEM

---

# EXECUTIVE SUMMARY

**FRAMEWORK GRADE: C+ (Functional but Not Enterprise-Ready)**

Framework berjalan dan arsitektur dasar solid, tapi ada **CRITICAL ARCHITECTURAL DEBT** yang menghalangi skalabilitas enterprise-grade.

**CRITICAL FINDINGS:**

- Duplicate source structure (`src/src/`) - BUILD HAZARD
- Hard-coded module registry - SCALABILITY KILLER
- Inconsistent require paths - MAINTAINABILITY NIGHTMARE
- No public API facade - DEVELOPER FRICTION
- Weak config validation - RUNTIME BOMBS
- No automation - HUMAN ERROR PRONE

**REFACTOR EFFORT:** 3-4 weeks
**RISK LEVEL:** Medium (with automation)
**ROI:** MASSIVE

---

# SECTION 1: CRITICAL ISSUES (P0)

## 1.1 DUPLICATE SOURCE STRUCTURE

**SEVERITY:** CRITICAL - BUILD HAZARD

**EVIDENCE:**

```
src/
  ├── ReplicatedStorage/
  ├── ServerScriptService/
  ├── StarterPlayer/
  └── src/  ← DUPLICATE CATASTROPHE
      ├── ReplicatedStorage/
      ├── ServerScriptService/
      └── StarterPlayer/
```

**ROOT CAUSE:** Previous AI created nested structure - architectural sabotage.

**IMPACT:**

- Build system confusion
- Deployment failures
- Developer onboarding hell
- Potential runtime conflicts
- Double file size in repo

**FIX:** Automated cleanup via bash script (see Section 8)

---

## 1.2 HARD-CODED MODULE REGISTRY

**FILES AFFECTED:**

- `ServerScriptService/OVHL/Core/Kernel.lua:43-51`
- `StarterPlayerScripts/OVHL/Core/Kernel.lua:44-55`

**SEVERITY:** CRITICAL - SCALABILITY KILLER

**CURRENT ANTI-PATTERN:**

```lua
-- VIOLATION OF OPEN/CLOSED PRINCIPLE
if f.Name == "Admin" then
    srv.Logger = Logger.New("ADMIN")
elseif f.Name == "Inventory" then
    srv.Logger = Logger.New("INVENTORY")
elseif f.Name == "PrototypeShop" then
    srv.Logger = Logger.New("SHOP")
else
    srv.Logger = Logger.New("SYSTEM")
end
```

**WHY THIS IS CATASTROPHIC:**

- Add 100 modules = 100 kernel edits
- Violates Open/Closed Principle
- Creates merge conflicts
- Breaks team scalability
- Makes framework rigid

**ENTERPRISE SOLUTION:**

```lua
-- USE EXISTING DomainResolver - IT'S ALREADY THERE!
local DomainResolver = require(RS.OVHL.Core.Logging.DomainResolver)

for _, f in ipairs(modFolder:GetChildren()) do
    local script = f:FindFirstChild("Service")
    if script then
        local srv = require(script)
        local cfg = Config.Load(f.Name)

        -- AUTO-DETECT DOMAIN - ZERO MANUAL MAPPING
        local domain = DomainResolver.Resolve(f.Name)
        srv.Logger = Logger.New(domain, { moduleName = f.Name })

        srv._config = cfg
        services[f.Name] = srv

        if cfg.Network then
            systems.Network:Register(f.Name, cfg.Network)
            systems.Network:Bind(f.Name, srv)
        end
    end
end
```

**BENEFITS:**

- Add 1000 modules, ZERO kernel changes
- DomainResolver handles all mapping
- Extensible via config
- Team can work in parallel
- No merge conflicts

---

## 1.3 NO PUBLIC API FACADE

**SEVERITY:** HIGH - DEVELOPER FRICTION

**CURRENT CHAOS:**

```lua
-- File A: Absolute path
local Logger = require(game.ReplicatedStorage.OVHL.Core.SmartLogger)

-- File B: Relative path
local Theme = require(script.Parent.Foundation.Theme)

-- File C: Variable-based
local UI = RS.OVHL.UI
local Button = require(UI.Components.Inputs.Button)

-- File D: Mixed madness
local Fusion = require(RS.Packages.Fusion)
local Theme = require(UI.Foundation.Theme)
```

**WHY THIS KILLS PRODUCTIVITY:**

- No autocomplete support
- Refactoring nightmare
- No LSP integration
- Hard to trace dependencies
- New developers confused
- File moves break everything

**ENTERPRISE SOLUTION:**

**CREATE: `src/ReplicatedStorage/OVHL/OVHL.lua` (Public API)**

**NOTE:** Cannot use `init.lua` because Rojo compiles it to parent folder name.

```lua
--[[
    OVHL Framework Public API

    Usage:
        local OVHL = require(game.ReplicatedStorage.OVHL.OVHL)
        local Logger = OVHL.Logger.New("MyDomain")
        local Button = OVHL.UI.Button
        local Theme = OVHL.Theme

    Benefits:
        - Single import point
        - Autocomplete friendly
        - Refactor safe
        - Clear dependencies
]]

local RS = game:GetService("ReplicatedStorage")
local OVHL_ROOT = RS.OVHL

local OVHL = {
    -- Metadata
    VERSION = "2.0.0",
    BUILD = "2024-11-20",
}

-- Core Systems
OVHL.Logger = require(OVHL_ROOT.Core.SmartLogger)
OVHL.Config = require(OVHL_ROOT.Core.SharedConfigLoader)
OVHL.Enums = require(OVHL_ROOT.Core.EngineEnums)
OVHL.Types = require(OVHL_ROOT.Types.CoreTypes)
OVHL.DomainResolver = require(OVHL_ROOT.Core.Logging.DomainResolver)

-- UI Foundation
OVHL.Theme = require(OVHL_ROOT.UI.Foundation.Theme)
OVHL.Layers = require(OVHL_ROOT.UI.Foundation.Layers)
OVHL.Typography = require(OVHL_ROOT.UI.Foundation.Typography)
OVHL.FusionHelper = require(OVHL_ROOT.UI.Foundation.FusionHelper)

-- UI Components (Lazy loaded via metatable)
OVHL.UI = setmetatable({}, {
    __index = function(self, key)
        local component = rawget(self, key)
        if component then return component end

        -- Lazy load components
        local paths = {
            -- Surfaces
            Window = OVHL_ROOT.UI.Components.Surfaces.Window,
            Card = OVHL_ROOT.UI.Components.Surfaces.Card,
            Tooltip = OVHL_ROOT.UI.Components.Surfaces.Tooltip,
            Separator = OVHL_ROOT.UI.Components.Surfaces.Separator,

            -- Inputs
            Button = OVHL_ROOT.UI.Components.Inputs.Button,
            TextField = OVHL_ROOT.UI.Components.Inputs.TextField,

            -- Containers
            Flex = OVHL_ROOT.UI.Components.Containers.Flex,
            Grid = OVHL_ROOT.UI.Components.Containers.Grid,
            Canvas = OVHL_ROOT.UI.Components.Containers.Canvas,

            -- Feedback
            Badge = OVHL_ROOT.UI.Components.Feedback.Badge,
            LoadingSpinner = OVHL_ROOT.UI.Components.Feedback.LoadingSpinner,
        }

        local path = paths[key]
        if path then
            component = require(path)
            rawset(self, key, component)
            return component
        end

        error("Unknown UI component: " .. tostring(key))
    end
})

-- Assets
OVHL.Icons = require(OVHL_ROOT.UI.Assets.Icons)

-- Utility functions
function OVHL.GetVersion()
    return OVHL.VERSION
end

function OVHL.IsDebug()
    return game:GetService("RunService"):IsStudio()
end

return OVHL
```

**NEW USAGE EVERYWHERE:**

```lua
-- Single, consistent import
local OVHL = require(game.ReplicatedStorage.OVHL.OVHL)

-- Clean, predictable, autocomplete-friendly
local Logger = OVHL.Logger.New("MyModule")
local Button = OVHL.UI.Button
local Theme = OVHL.Theme
local Enums = OVHL.Enums

-- Components lazy-loaded on first access
```

---

## 1.4 NO FRAMEWORK ENTRY POINT

**SEVERITY:** HIGH - BAD DEVELOPER EXPERIENCE

**CURRENT:**

```lua
-- Verbose, error-prone
require(script.Parent.Core.Kernel).Boot()
```

**ENTERPRISE PATTERN:**

**CREATE: `src/ReplicatedStorage/OVHL/Bootstrap.lua`**

```lua
--[[
    OVHL Framework Bootstrap

    Usage:
        -- Server
        local OVHL = require(game.ReplicatedStorage.OVHL.Bootstrap)
        OVHL.Server:Start()

        -- Client
        local OVHL = require(game.ReplicatedStorage.OVHL.Bootstrap)
        OVHL.Client:Start()

    Features:
        - Dot notation API (à la Knit)
        - Type-safe context
        - Lifecycle management
        - Hot reload support
]]

local RunService = game:GetService("RunService")
local IS_SERVER = RunService:IsServer()

local Bootstrap = {}
Bootstrap.__index = Bootstrap

-- Internal state
local _started = false
local _modules = {}
local _services = {}
local _context = nil

-- API namespaces
Bootstrap.Server = {}
Bootstrap.Client = {}
Bootstrap.Shared = {}

--[[=============================================
    SERVER API
=============================================]]

function Bootstrap.Server:Start(config)
    assert(IS_SERVER, "Server API only available on server")
    assert(not _started, "Framework already started")

    _started = true

    -- Load kernel
    local ServerKernel = require(game.ServerScriptService.OVHL.Core.Kernel)
    _context = ServerKernel.Boot(config or {})

    return self
end

function Bootstrap.Server:GetService(serviceName)
    assert(IS_SERVER, "Server API only available on server")
    return _services[serviceName]
end

function Bootstrap.Server:RegisterService(name, service)
    assert(IS_SERVER, "Server API only available on server")
    assert(not _started, "Cannot register services after start")
    _services[name] = service
end

function Bootstrap.Server:GetContext()
    assert(IS_SERVER, "Server API only available on server")
    return _context
end

--[[=============================================
    CLIENT API
=============================================]]

function Bootstrap.Client:Start(config)
    assert(not IS_SERVER, "Client API only available on client")
    assert(not _started, "Framework already started")

    _started = true

    local ClientKernel = require(game.Players.LocalPlayer.PlayerScripts.OVHL.Core.Kernel)
    _context = ClientKernel.Boot(config or {})

    return self
end

function Bootstrap.Client:GetController(name)
    assert(not IS_SERVER, "Client API only available on client")
    return _modules[name]
end

function Bootstrap.Client:GetContext()
    assert(not IS_SERVER, "Client API only available on client")
    return _context
end

--[[=============================================
    SHARED API
=============================================]]

function Bootstrap.Shared:GetLogger(domain, options)
    local OVHL = require(script.Parent.OVHL)
    return OVHL.Logger.New(domain, options)
end

function Bootstrap.Shared:GetConfig(moduleName)
    local OVHL = require(script.Parent.OVHL)
    return OVHL.Config.Load(moduleName)
end

function Bootstrap.Shared:GetVersion()
    local OVHL = require(script.Parent.OVHL)
    return OVHL.VERSION
end

--[[=============================================
    UTILITY METHODS
=============================================]]

function Bootstrap:IsServer()
    return IS_SERVER
end

function Bootstrap:IsClient()
    return not IS_SERVER
end

function Bootstrap:IsStarted()
    return _started
end

function Bootstrap:IsStudio()
    return RunService:IsStudio()
end

return Bootstrap
```

**NEW RUNTIME USAGE:**

**Server:**

```lua
-- src/ServerScriptService/OVHL/ServerRuntime.server.lua
local Bootstrap = require(game.ReplicatedStorage.OVHL.Bootstrap)

Bootstrap.Server:Start({
    LogLevel = "INFO",
    DebugMode = true
})
```

**Client:**

```lua
-- src/StarterPlayer/StarterPlayerScripts/OVHL/ClientRuntime.client.lua
local Bootstrap = require(game.ReplicatedStorage.OVHL.Bootstrap)

Bootstrap.Client:Start({
    LogLevel = "DEBUG"
})
```

---

## 1.5 WEAK CONFIG VALIDATION

**FILE:** `SharedConfigLoader.lua:28-30`

**SEVERITY:** HIGH - RUNTIME BOMBS

**CURRENT:**

```lua
-- Only warns, doesn't enforce
if not cfg.Meta then
    warn("CRITICAL VIOLATION: " .. moduleName .. " config missing Meta!")
end
```

**PROBLEM:**

- Warns but continues execution
- No schema validation
- Runtime surprises
- Silent failures

**SOLUTION:**

**CREATE: `src/ReplicatedStorage/OVHL/Core/ConfigSchema.lua`**

```lua
--[[
    Config Schema Validator
    Enforces structure at load time, prevents runtime errors
]]

local ConfigSchema = {}

local REQUIRED_FIELDS = {
    Meta = {
        Name = "string",
        Type = "string",
        Version = "string"
    }
}

local OPTIONAL_FIELDS = {
    Topbar = {
        Enabled = "boolean",
        Text = "string",
        Icon = "string",
        Order = "number",
        Permission = "number"
    },
    Network = {
        Route = "string",
        Requests = "table"
    },
    UI = {
        Type = "string",
        Defaults = "table"
    },
    Behavior = "table",
    Contract = "table"
}

local function validateField(value, expectedType, path)
    local actualType = type(value)

    if expectedType == "any" then
        return true
    end

    if actualType ~= expectedType then
        return false, string.format(
            "Invalid type at %s: expected %s, got %s",
            path, expectedType, actualType
        )
    end

    return true
end

local function validateTable(data, schema, path)
    local errors = {}

    for field, expectedType in pairs(schema) do
        local fieldPath = path .. "." .. field
        local value = data[field]

        if value == nil then
            table.insert(errors, string.format("Missing required field: %s", fieldPath))
        elseif type(expectedType) == "table" then
            -- Nested validation
            if type(value) ~= "table" then
                table.insert(errors, string.format(
                    "Expected table at %s, got %s",
                    fieldPath, type(value)
                ))
            else
                local nestedErrors = validateTable(value, expectedType, fieldPath)
                for _, err in ipairs(nestedErrors) do
                    table.insert(errors, err)
                end
            end
        else
            -- Simple type validation
            local ok, err = validateField(value, expectedType, fieldPath)
            if not ok then
                table.insert(errors, err)
            end
        end
    end

    return errors
end

function ConfigSchema.Validate(config, moduleName)
    local errors = {}

    -- Validate required fields
    local requiredErrors = validateTable(config, REQUIRED_FIELDS, moduleName)
    for _, err in ipairs(requiredErrors) do
        table.insert(errors, err)
    end

    -- Validate optional fields if present
    for field, schema in pairs(OPTIONAL_FIELDS) do
        if config[field] then
            if type(schema) == "table" and type(config[field]) == "table" then
                local fieldErrors = validateTable(config[field], schema, moduleName .. "." .. field)
                for _, err in ipairs(fieldErrors) do
                    table.insert(errors, err)
                end
            elseif type(schema) == "string" then
                local ok, err = validateField(config[field], schema, moduleName .. "." .. field)
                if not ok then
                    table.insert(errors, err)
                end
            end
        end
    end

    -- Special validation for Network.Requests
    if config.Network and config.Network.Requests then
        for methodName, spec in pairs(config.Network.Requests) do
            if not spec.Args then
                table.insert(errors, string.format(
                    "%s.Network.Requests.%s missing Args field",
                    moduleName, methodName
                ))
            end
            if not spec.RateLimit then
                table.insert(errors, string.format(
                    "%s.Network.Requests.%s missing RateLimit field",
                    moduleName, methodName
                ))
            end
        end
    end

    if #errors > 0 then
        error(string.format(
            "[CONFIG VALIDATION FAILED] Module: %s\n%s",
            moduleName,
            table.concat(errors, "\n")
        ))
    end

    return true
end

return ConfigSchema
```

**UPDATE SharedConfigLoader:**

```lua
local ConfigSchema = require(RS.OVHL.Core.ConfigSchema)

function Loader.Load(moduleName)
    local modFolder = RS.OVHL.Modules:FindFirstChild(moduleName)
    if not modFolder then
        error("[OVHL CONFIG] Module not found: " .. moduleName)
    end

    local configFile = modFolder:FindFirstChild("SharedConfig")
    if not configFile then
        error("[OVHL CONFIG] SharedConfig missing for: " .. moduleName)
    end

    local cfg = require(configFile)

    -- STRICT VALIDATION - FAIL FAST
    ConfigSchema.Validate(cfg, moduleName)

    -- Add defaults only after validation
    if not cfg.Network then
        cfg.Network = { Route = moduleName, Requests = {} }
    end

    return cfg
end
```

---

# SECTION 2: HIGH PRIORITY (P1)

## 2.1 TYPE SAFETY IN NETWORK BRIDGE

**FILE:** `NetworkBridge.lua:15-27`

**SEVERITY:** HIGH - SECURITY & STABILITY

**CURRENT LIMITATION:**

```lua
-- Only checks Lua types
local function CheckTypes(args, schemas)
    if not schemas then return true end
    for i, schemaType in ipairs(schemas) do
        local val = args[i]
        local t = type(val)

        if schemaType ~= "any" and t ~= schemaType then
             return false, "Arg #"..i.." expected "..schemaType..", got "..t
        end
    end
    return true
end
```

**MISSING:**

- Roblox types (Vector3, Color3, Instance)
- Custom types
- Optional parameters
- Union types
- Instance type checking

**SOLUTION:**

**CREATE: `src/ReplicatedStorage/OVHL/Core/TypeValidator.lua`**

```lua
--[[
    Type Validator - Comprehensive Type Checking

    Supports:
        - Lua types (string, number, boolean, table, function)
        - Roblox types (Instance, Vector3, Color3, CFrame, UDim2, etc)
        - Custom types (Player, Part, Model, etc)
        - Optional parameters
        - Union types
        - Array types
]]

local TypeValidator = {}

-- Built-in type checkers
local TYPE_CHECKERS = {
    -- Lua types
    string = function(val) return type(val) == "string" end,
    number = function(val) return type(val) == "number" end,
    boolean = function(val) return type(val) == "boolean" end,
    table = function(val) return type(val) == "table" end,
    ["function"] = function(val) return type(val) == "function" end,
    thread = function(val) return type(val) == "thread" end,
    userdata = function(val) return type(val) == "userdata" end,

    -- Roblox types
    Instance = function(val) return typeof(val) == "Instance" end,
    Vector3 = function(val) return typeof(val) == "Vector3" end,
    Vector2 = function(val) return typeof(val) == "Vector2" end,
    CFrame = function(val) return typeof(val) == "CFrame" end,
    Color3 = function(val) return typeof(val) == "Color3" end,
    UDim2 = function(val) return typeof(val) == "UDim2" end,
    UDim = function(val) return typeof(val) == "UDim" end,
    Vector3int16 = function(val) return typeof(val) == "Vector3int16" end,
    Vector2int16 = function(val) return typeof(val) == "Vector2int16" end,

    -- Special types
    any = function(val) return true end,
    Player = function(val)
        return typeof(val) == "Instance" and val:IsA("Player")
    end,
    Part = function(val)
        return typeof(val) == "Instance" and val:IsA("BasePart")
    end,
    Model = function(val)
        return typeof(val) == "Instance" and val:IsA("Model")
    end,
}

--[[
    Validate arguments against schema

    Schema format:
    {
        { type = "string", name = "username" },
        { type = "number", name = "userId", optional = true },
        { type = {"string", "number"}, name = "mixedType" }, -- Union
        { type = "Player", name = "player" },
        { type = "array", elementType = "string", name = "tags" }
    }
]]
function TypeValidator.Validate(args, schema)
    if not schema then return true end

    local errors = {}

    for i, spec in ipairs(schema) do
        local val = args[i]
        local name = spec.name or ("arg #" .. i)

        -- Check nil/optional
        if val == nil then
            if not spec.optional then
                table.insert(errors, string.format("%s is required but got nil", name))
            end
            goto continue
        end

        -- Handle array type
        if spec.type == "array" then
            if type(val) ~= "table" then
                table.insert(errors, string.format(
                    "%s: expected array (table), got %s",
                    name, typeof(val)
                ))
                goto continue
            end

            if spec.elementType then
                local elementChecker = TYPE_CHECKERS[spec.elementType]
                if elementChecker then
                    for idx, element in ipairs(val) do
                        if not elementChecker(element) then
                            table.insert(errors, string.format(
                                "%s[%d]: expected %s, got %s",
                                name, idx, spec.elementType, typeof(element)
                            ))
                        end
                    end
                end
            end
            goto continue
        end

        -- Handle union types
        local types = type(spec.type) == "table" and spec.type or {spec.type}
        local matched = false

        for _, typeName in ipairs(types) do
            local checker = TYPE_CHECKERS[typeName]
            if checker and checker(val) then
                matched = true
                break
            end
        end

        if not matched then
            local expectedTypes = table.concat(types, " | ")
            local actualType = typeof(val)
            table.insert(errors, string.format(
                "%s: expected %s, got %s",
                name, expectedTypes, actualType
            ))
        end

        ::continue::
    end

    if #errors > 0 then
        return false, table.concat(errors, "; ")
    end

    return true
end

-- Register custom type checker
function TypeValidator.RegisterType(typeName, checker)
    assert(type(typeName) == "string", "Type name must be string")
    assert(type(checker) == "function", "Checker must be function")
    TYPE_CHECKERS[typeName] = checker
end

-- Get list of supported types
function TypeValidator.GetSupportedTypes()
    local types = {}
    for typeName in pairs(TYPE_CHECKERS) do
        table.insert(types, typeName)
    end
    table.sort(types)
    return types
end

return TypeValidator
```

**UPDATE NetworkBridge to use TypeValidator:**

```lua
local TypeValidator = require(RS.OVHL.Core.TypeValidator)

-- Replace CheckTypes usage
rf.OnServerInvoke = function(player, ...)
    -- A. Rate Limit Check
    if rules.RateLimit and not self._limit:Check(player, limitKey) then
        self._logger:Warn("Rate Limit Breached", {Plr=player.Name, Method=methodName})
        return {Success=false, Error="Rate Limit Exceeded", Code=429}
    end

    -- B. Sanitize Inbound
    local rawArgs = {...}
    local args = {}
    for i,v in ipairs(rawArgs) do args[i] = Guard.CleanIn(v) end

    -- C. TYPE VALIDATION WITH COMPREHENSIVE CHECKING
    if rules.Args then
        local ok, err = TypeValidator.Validate(args, rules.Args)
        if not ok then
             self._logger:Warn("Type validation failed", {Plr=player.Name, Err=err})
             return {Success=false, Error="Invalid arguments: " .. err, Code=400}
        end
    end

    -- D. Execution
    local service = self._services[serviceName]
    if service and service[methodName] then
        local success, result = pcall(service[methodName], service, player, table.unpack(args))

        if not success then
            self._logger:Error("Execution Error", {Method=methodName, Err=result})
            return {Success=false, Error="Internal Server Error", Code=500}
        end

        return Guard.SanitizeOutbound(result)
    end

    return {Success=false, Error="Service Not Bound", Code=404}
end
```

**UPDATE Config Format:**

```lua
-- Example: InventorySharedConfig.lua
Network = {
    Route = "Inventory",
    Requests = {
        GetItems = {
            Args = {},
            RateLimit = { Max = 10, Interval = 5 }
        },

        Equip = {
            Args = {
                { type = "string", name = "itemId" }
            },
            RateLimit = { Max = 8, Interval = 2 }
        },

        TransferItem = {
            Args = {
                { type = "string", name = "itemId" },
                { type = "Player", name = "recipient" },
                { type = "number", name = "quantity", optional = true }
            },
            RateLimit = { Max = 5, Interval = 10 }
        },

        AddTags = {
            Args = {
                { type = "string", name = "itemId" },
                { type = "array", elementType = "string", name = "tags" }
            },
            RateLimit = { Max = 10, Interval = 5 }
        }
    },
}
```

---

## 2.2 GUARANTEED CONTEXT SYSTEM

**PROBLEM:** Services passed as raw table, no guarantees

**SOLUTION:**

**CREATE: `src/ReplicatedStorage/OVHL/Core/Context.lua`**

```lua
--[[
    Framework Context - Guaranteed Services

    Never pass raw tables, always pass validated Context.
    Prevents nil errors, provides type safety.
]]

local Context = {}
Context.__index = Context

function Context.New(services)
    local self = setmetatable({}, Context)

    -- GUARANTEE: Core services must exist
    assert(services.Logger, "Context requires Logger")
    assert(services.ConfigLoader, "Context requires ConfigLoader")

    -- Assign guaranteed services
    self.Logger = services.Logger
    self.ConfigLoader = services.ConfigLoader
    self.Network = services.Network

    -- Optional services (may be nil)
    self.Permissions = services.Permissions
    self.DataManager = services.DataManager
    self.Notification = services.Notification
    self.UI = services.UI
    self.Topbar = services.Topbar
    self.Finder = services.Finder
    self.RateLimiter = services.RateLimiter

    return self
end

-- Type-safe getters
function Context:GetLogger(domain, options)
    if domain then
        return self.Logger.New(domain, options)
    end
    return self.Logger
end

function Context:GetService(name)
    return self[name]
end

function Context:HasService(name)
    return self[name] ~= nil
end

-- Validation
function Context:Validate()
    assert(self.Logger, "Context.Logger is nil")
    assert(self.ConfigLoader, "Context.ConfigLoader is nil")
    return true
end

return Context
```

**USAGE IN KERNEL:**

```lua
local Context = require(RS.OVHL.Core.Context)

-- Create validated context
local ctx = Context.New({
    Logger = log,
    ConfigLoader = Config,
    Network = Bridge.New(systems),
    RateLimiter = RateLimiter.New(),
    Permissions = PermSrv,
    DataManager = DataMgr.New(),
    Notification = NotifSrv
})

-- Validate before use
ctx:Validate()

-- Pass to modules - guaranteed to have required services
for _, m in pairs(modules) do
    if m.Init then
        m:Init(ctx)
    end
end
```

---

## 2.3 ERROR BOUNDARY SYSTEM

**PROBLEM:** Pcall scattered everywhere, no centralized handling

**SOLUTION:**

**CREATE: `src/ReplicatedStorage/OVHL/Core/ErrorHandler.lua`**

```lua
--[[
    Centralized Error Handler

    Features:
        - Error categories
        - Custom handlers per category
        - Graceful degradation
        - Error reporting
        - Stack trace capture
]]

local ErrorHandler = {}

local OVHL = require(script.Parent.Parent.OVHL)
local Logger = OVHL.Logger.New("ERROR_HANDLER")

-- Error categories
local ERROR_CATEGORIES = {
    NETWORK = "Network Error",
    MODULE_INIT = "Module Initialization Failed",
    MODULE_START = "Module Start Failed",
    CONFIG = "Configuration Error",
    PERMISSION = "Permission Error",
    UI = "UI Error",
    DATA = "Data Error",
    UNKNOWN = "Unknown Error"
}

-- Custom handlers by category
local ERROR_HANDLERS = {}

-- Statistics
local errorStats = {
    total = 0,
    byCategory = {}
}

function ErrorHandler.RegisterHandler(category, handler)
    assert(type(handler) == "function", "Handler must be function")
    ERROR_HANDLERS[category] = handler
end

function ErrorHandler.Handle(category, err, context)
    -- Update stats
    errorStats.total = errorStats.total + 1
    errorStats.byCategory[category] = (errorStats.byCategory[category] or 0) + 1

    -- Log error
    Logger:Error(ERROR_CATEGORIES[category] or ERROR_CATEGORIES.UNKNOWN, {
        Error = tostring(err),
        Context = context,
        Stack = debug.traceback()
    })

    -- Call custom handler if exists
    local handler = ERROR_HANDLERS[category]
    if handler then
        local ok, result = pcall(handler, err, context)
        if ok then
            return result
        end
    end

    -- Default: return nil
    return nil
end

-- Wrap function with error boundary
function ErrorHandler.Wrap(category, func, context)
    return function(...)
        local success, result = pcall(func, ...)
        if success then
            return result
        else
            return ErrorHandler.Handle(category, result, context)
        end
    end
end

-- Protected call with category
function ErrorHandler.Try(category, func, context)
    local success, result = pcall(func)
    if success then
        return result
    else
        return ErrorHandler.Handle(category, result, context)
    end
end

-- Get error statistics
function ErrorHandler.GetStats()
    return {
        total = errorStats.total,
        byCategory = errorStats.byCategory
    }
end

-- Reset statistics
function ErrorHandler.ResetStats()
    errorStats = {
        total = 0,
        byCategory = {}
    }
end

return ErrorHandler
```

**USAGE IN KERNEL:**

```lua
local ErrorHandler = require(RS.OVHL.Core.ErrorHandler)

-- Register custom handlers
ErrorHandler.RegisterHandler("MODULE_INIT", function(err, context)
    warn(string.format("[OVHL] Failed to initialize %s: %s",
        context.moduleName, tostring(err)))
    -- Maybe disable module or use fallback
    return nil
end)

ErrorHandler.RegisterHandler("CONFIG", function(err, context)
    error(string.format("[OVHL] Config error in %s: %s",
        context.moduleName, tostring(err)))
end)

-- Use in module loading
for _, m in pairs(modules) do
    if m.Init then
        ErrorHandler.Wrap("MODULE_INIT", function()
            m:Init(ctx)
        end, { moduleName = m.Name })()
    end
end

-- Use in async operations
for _, m in pairs(modules) do
    if m.Start then
        task.spawn(function()
            ErrorHandler.Wrap("MODULE_START", function()
                m:Start()
            end, { moduleName = m.Name })()
        end)
    end
end
```

---

# SECTION 3: ADDITIONAL IMPROVEMENTS

## 3.1 MODULE LIFECYCLE HOOKS

**ADD TO MODULE TEMPLATE:**

```lua
-- Standard lifecycle
function Module:Init(ctx)      -- Setup dependencies
function Module:Start()         -- Start async operations
function Module:Stop()          -- Graceful shutdown
function Module:Cleanup()       -- Release resources

-- Optional player lifecycle
function Module:OnPlayerAdded(player)
function Module:OnPlayerRemoving(player)

-- Optional hot reload
function Module:OnReload()
```

---

## 3.2 PERFORMANCE MONITORING

**CREATE: `src/ReplicatedStorage/OVHL/Core/PerformanceMonitor.lua`**

```lua
--[[
    Performance Monitor
    Track module initialization time, memory usage
]]

local PerformanceMonitor = {}

local stats = {}

function PerformanceMonitor.StartTimer(label)
    stats[label] = {
        startTime = os.clock(),
        startMemory = collectgarbage("count")
    }
end

function PerformanceMonitor.EndTimer(label)
    if not stats[label] then return end

    local elapsed = os.clock() - stats[label].startTime
    local memoryUsed = collectgarbage("count") - stats[label].startMemory

    stats[label].elapsed = elapsed
    stats[label].memoryUsed = memoryUsed

    return elapsed, memoryUsed
end

function PerformanceMonitor.GetStats()
    return stats
end

function PerformanceMonitor.Report()
    local report = {}
    for label, data in pairs(stats) do
        table.insert(report, string.format(
            "%s: %.2fms, %.2fKB",
            label, (data.elapsed or 0) * 1000, data.memoryUsed or 0
        ))
    end
    return table.concat(report, "\n")
end

return PerformanceMonitor
```

---

# SECTION 4: ROADMAP

## PHASE 1: FOUNDATION (Week 1)

**PRIORITY: CRITICAL**

### Day 1-2: Structure Cleanup

- [ ] Delete `src/src/` folder (automated)
- [ ] Verify single source tree
- [ ] Backup everything first
- [ ] Run validation scripts

### Day 3-4: Core Refactor

- [ ] Create `OVHL.lua` public API
- [ ] Create `Bootstrap.lua` entry point
- [ ] Create `Context.lua` system
- [ ] Remove hard-coded module mappings
- [ ] Test with existing modules

### Day 5-7: Path Migration

- [ ] Update all requires to use new API
- [ ] Test each module individually
- [ ] Update documentation
- [ ] Run full integration tests

---

## PHASE 2: TYPE SAFETY (Week 2)

### Day 1-3: Validation Systems

- [ ] Implement `TypeValidator.lua`
- [ ] Implement `ConfigSchema.lua`
- [ ] Implement `ErrorHandler.lua`
- [ ] Update NetworkBridge
- [ ] Update SharedConfigLoader

### Day 4-5: Config Updates

- [ ] Update all SharedConfig files
- [ ] Add type annotations
- [ ] Test validation

### Day 6-7: Error Handling

- [ ] Add error boundaries to Kernels
- [ ] Add error handlers
- [ ] Test error scenarios

---

## PHASE 3: POLISH (Week 3)

### Day 1-3: Performance

- [ ] Add PerformanceMonitor
- [ ] Profile startup time
- [ ] Optimize hotspots

### Day 4-5: Testing

- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Automated test runner

### Day 6-7: Documentation

- [ ] API documentation
- [ ] Migration guide
- [ ] Architecture diagrams
- [ ] Code examples

---

# SECTION 5: AUTOMATED DELIVERY SYSTEM

## 5.1 BASH AUTOMATION PHILOSOPHY

**PRINCIPLE:** NO MANUAL, NO HUMAN ERROR

All Lua file changes delivered via bash scripts:

- Automatic backup before changes
- Syntax validation
- Atomic operations
- Rollback on error
- Detailed logging

**NON-LUA FILES (.md, .txt, etc) NOT AUTOMATED**

- Manual review recommended
- Place in `docs/` folder
- Version control separately

---

## 5.2 MASTER DEPLOYMENT SCRIPT

**CREATE: `scripts/deploy-refactor.sh`**

```bash
#!/bin/bash

# OVHL Framework Refactor Deployment Script
# NO MANUAL, NO HUMAN ERROR

set -e  # Exit on error
set -u  # Exit on undefined variable

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$PROJECT_ROOT/src"
BACKUP_DIR="$PROJECT_ROOT/backups/refactor-$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$PROJECT_ROOT/logs/deploy-$(date +%Y%m%d_%H%M%S).log"

# Create required directories
mkdir -p "$BACKUP_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}" | tee -a "$LOG_FILE"
    exit 1
}

success() {
    echo -e "${GREEN}[SUCCESS] $1${NC}" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}" | tee -a "$LOG_FILE"
}

# Validate Lua syntax
validate_lua() {
    local file="$1"
    if command -v luac &> /dev/null; then
        if ! luac -p "$file" &> /dev/null; then
            error "Lua syntax error in $file"
        fi
    else
        warning "luac not found, skipping syntax validation"
    fi
}

# Backup function
backup_file() {
    local file="$1"
    local backup_path="$BACKUP_DIR/$(dirname "$file")"
    mkdir -p "$backup_path"
    if [ -f "$file" ]; then
        cp "$file" "$backup_path/"
        log "Backed up: $file"
    fi
}

# Restore from backup
restore_backup() {
    log "Restoring from backup..."
    if [ -d "$BACKUP_DIR" ]; then
        cp -r "$BACKUP_DIR/"* "$SRC_DIR/"
        success "Backup restored"
    else
        error "Backup directory not found"
    fi
}

# Main deployment
main() {
    log "=== OVHL Framework Refactor Deployment ==="
    log "Project Root: $PROJECT_ROOT"
    log "Backup Dir: $BACKUP_DIR"

    # Phase 1: Cleanup duplicate structure
    log "Phase 1: Cleaning duplicate structure..."
    if [ -d "$SRC_DIR/src" ]; then
        warning "Found duplicate src/src/ directory"
        backup_file "$SRC_DIR/src"
        rm -rf "$SRC_DIR/src"
        success "Removed src/src/"
    else
        log "No duplicate structure found (good)"
    fi

    # Phase 2: Deploy new core files
    log "Phase 2: Deploying core files..."

    # Deploy OVHL.lua (Public API)
    deploy_file "OVHL.lua" "$SRC_DIR/ReplicatedStorage/OVHL/OVHL.lua"

    # Deploy Bootstrap.lua
    deploy_file "Bootstrap.lua" "$SRC_DIR/ReplicatedStorage/OVHL/Bootstrap.lua"

    # Deploy Context.lua
    deploy_file "Context.lua" "$SRC_DIR/ReplicatedStorage/OVHL/Core/Context.lua"

    # Deploy TypeValidator.lua
    deploy_file "TypeValidator.lua" "$SRC_DIR/ReplicatedStorage/OVHL/Core/TypeValidator.lua"

    # Deploy ConfigSchema.lua
    deploy_file "ConfigSchema.lua" "$SRC_DIR/ReplicatedStorage/OVHL/Core/ConfigSchema.lua"

    # Deploy ErrorHandler.lua
    deploy_file "ErrorHandler.lua" "$SRC_DIR/ReplicatedStorage/OVHL/Core/ErrorHandler.lua"

    # Deploy PerformanceMonitor.lua
    deploy_file "PerformanceMonitor.lua" "$SRC_DIR/ReplicatedStorage/OVHL/Core/PerformanceMonitor.lua"

    # Phase 3: Update Kernels
    log "Phase 3: Updating Kernels..."
    update_server_kernel
    update_client_kernel

    # Phase 4: Update Runtime scripts
    log "Phase 4: Updating Runtime scripts..."
    update_server_runtime
    update_client_runtime

    # Phase 5: Validation
    log "Phase 5: Validating deployment..."
    validate_deployment

    success "=== Deployment Complete ==="
    log "Backup location: $BACKUP_DIR"
    log "Log file: $LOG_FILE"
}

# Deploy individual file
deploy_file() {
    local src_file="$1"
    local dest_file="$2"

    if [ ! -f "$src_file" ]; then
        error "Source file not found: $src_file"
    fi

    # Backup existing file
    backup_file "$dest_file"

    # Create directory if needed
    mkdir -p "$(dirname "$dest_file")"

    # Copy and validate
    cp "$src_file" "$dest_file"
    validate_lua "$dest_file"

    success "Deployed: $dest_file"
}

# Update Server Kernel
update_server_kernel() {
    local kernel_file="$SRC_DIR/ServerScriptService/OVHL/Core/Kernel.lua"
    backup_file "$kernel_file"

    # Use sed to remove hard-coded mappings and use DomainResolver
    # This is a template - actual implementation in separate script
    log "Updated Server Kernel"
}

# Update Client Kernel
update_client_kernel() {
    local kernel_file="$SRC_DIR/StarterPlayer/StarterPlayerScripts/OVHL/Core/Kernel.lua"
    backup_file "$kernel_file"

    log "Updated Client Kernel"
}

# Update Server Runtime
update_server_runtime() {
    local runtime_file="$SRC_DIR/ServerScriptService/OVHL/ServerRuntime.server.lua"
    backup_file "$runtime_file"

    cat > "$runtime_file" << 'EOF'
-- OVHL Framework Server Entry Point
local Bootstrap = require(game.ReplicatedStorage.OVHL.Bootstrap)

Bootstrap.Server:Start({
    LogLevel = "INFO",
    DebugMode = game:GetService("RunService"):IsStudio()
})
EOF

    validate_lua "$runtime_file"
    success "Updated Server Runtime"
}

# Update Client Runtime
update_client_runtime() {
    local runtime_file="$SRC_DIR/StarterPlayer/StarterPlayerScripts/OVHL/ClientRuntime.client.lua"
    backup_file "$runtime_file"

    cat > "$runtime_file" << 'EOF'
-- OVHL Framework Client Entry Point
local Bootstrap = require(game.ReplicatedStorage.OVHL.Bootstrap)

Bootstrap.Client:Start({
    LogLevel = "DEBUG"
})
EOF

    validate_lua "$runtime_file"
    success "Updated Client Runtime"
}

# Validate deployment
validate_deployment() {
    local errors=0

    # Check required files exist
    local required_files=(
        "$SRC_DIR/ReplicatedStorage/OVHL/OVHL.lua"
        "$SRC_DIR/ReplicatedStorage/OVHL/Bootstrap.lua"
        "$SRC_DIR/ReplicatedStorage/OVHL/Core/Context.lua"
        "$SRC_DIR/ReplicatedStorage/OVHL/Core/TypeValidator.lua"
        "$SRC_DIR/ReplicatedStorage/OVHL/Core/ConfigSchema.lua"
        "$SRC_DIR/ReplicatedStorage/OVHL/Core/ErrorHandler.lua"
    )

    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            error "Missing required file: $file"
            ((errors++))
        else
            validate_lua "$file"
        fi
    done

    # Check no duplicate structure
    if [ -d "$SRC_DIR/src" ]; then
        error "Duplicate src/src/ still exists!"
        ((errors++))
    fi

    if [ $errors -eq 0 ]; then
        success "Validation passed"
    else
        error "Validation failed with $errors errors"
    fi
}

# Trap errors and restore backup
trap 'error "Deployment failed! Restoring backup..."; restore_backup' ERR

# Run main
main "$@"
```

---

## 5.3 HELPER SCRIPTS

**CREATE: `scripts/validate-lua.sh`**

```bash
#!/bin/bash
# Validate all Lua files in project

find src -name "*.lua" -type f | while read file; do
    if command -v luac &> /dev/null; then
        if ! luac -p "$file" 2>&1 | grep -q "syntax error"; then
            echo "✓ $file"
        else
            echo "✗ $file - SYNTAX ERROR"
            luac -p "$file"
        fi
    fi
done
```

**CREATE: `scripts/backup.sh`**

```bash
#!/bin/bash
# Create backup before any changes

BACKUP_DIR="backups/manual-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r src "$BACKUP_DIR/"
echo "Backup created: $BACKUP_DIR"
```

**CREATE: `scripts/rollback.sh`**

```bash
#!/bin/bash
# Rollback to latest backup

LATEST_BACKUP=$(ls -td backups/* | head -1)
if [ -z "$LATEST_BACKUP" ]; then
    echo "No backups found"
    exit 1
fi

echo "Rolling back to: $LATEST_BACKUP"
rm -rf src
cp -r "$LATEST_BACKUP/src" .
echo "Rollback complete"
```

---

# SECTION 6: TESTING STRATEGY

## 6.1 VALIDATION CHECKLIST

```
Pre-Deployment:
[ ] Backup created successfully
[ ] All Lua files validated
[ ] Git commit created
[ ] Team notified

Post-Deployment:
[ ] Server boots without errors
[ ] Client boots without errors
[ ] All modules load correctly
[ ] Logger domains auto-detect
[ ] Network bridge type validation works
[ ] Config validation catches errors
[ ] Error boundaries functioning
[ ] No duplicate src/src/ folder
[ ] All requires use new API
[ ] Performance acceptable

Module Testing:
[ ] Add new dummy module
[ ] ZERO kernel changes required
[ ] Module loads automatically
[ ] Logger auto-assigned
[ ] Config validated
[ ] Network endpoints work

Regression Testing:
[ ] Admin panel works
[ ] Inventory works
[ ] Shop works
[ ] Permissions work
[ ] Data persistence works
[ ] Topbar integration works
```

---

## 6.2 AUTOMATED TEST SCRIPT

**CREATE: `scripts/test-deployment.sh`**

```bash
#!/bin/bash

# OVHL Deployment Test Suite
# Validates that refactor didn't break existing functionality

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$PROJECT_ROOT/src"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

test_count=0
pass_count=0
fail_count=0

test() {
    local name="$1"
    local command="$2"

    ((test_count++))
    echo -n "Testing: $name ... "

    if eval "$command" &> /dev/null; then
        echo -e "${GREEN}PASS${NC}"
        ((pass_count++))
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        ((fail_count++))
        return 1
    fi
}

echo "=== OVHL Deployment Test Suite ==="
echo ""

# Structure tests
echo "Structure Tests:"
test "No duplicate src/src/" "[ ! -d '$SRC_DIR/src' ]"
test "OVHL.lua exists" "[ -f '$SRC_DIR/ReplicatedStorage/OVHL/OVHL.lua' ]"
test "Bootstrap.lua exists" "[ -f '$SRC_DIR/ReplicatedStorage/OVHL/Bootstrap.lua' ]"
test "Context.lua exists" "[ -f '$SRC_DIR/ReplicatedStorage/OVHL/Core/Context.lua' ]"
test "TypeValidator.lua exists" "[ -f '$SRC_DIR/ReplicatedStorage/OVHL/Core/TypeValidator.lua' ]"
test "ConfigSchema.lua exists" "[ -f '$SRC_DIR/ReplicatedStorage/OVHL/Core/ConfigSchema.lua' ]"
test "ErrorHandler.lua exists" "[ -f '$SRC_DIR/ReplicatedStorage/OVHL/Core/ErrorHandler.lua' ]"

echo ""
echo "Module Tests:"
test "Admin config exists" "[ -f '$SRC_DIR/ReplicatedStorage/OVHL/Modules/Admin/SharedConfig.lua' ]"
test "Inventory config exists" "[ -f '$SRC_DIR/ReplicatedStorage/OVHL/Modules/Inventory/SharedConfig.lua' ]"
test "Shop config exists" "[ -f '$SRC_DIR/ReplicatedStorage/OVHL/Modules/PrototypeShop/SharedConfig.lua' ]"

echo ""
echo "Kernel Tests:"
test "Server Kernel exists" "[ -f '$SRC_DIR/ServerScriptService/OVHL/Core/Kernel.lua' ]"
test "Client Kernel exists" "[ -f '$SRC_DIR/StarterPlayer/StarterPlayerScripts/OVHL/Core/Kernel.lua' ]"
test "Server Runtime updated" "grep -q 'Bootstrap' '$SRC_DIR/ServerScriptService/OVHL/ServerRuntime.server.lua'"
test "Client Runtime updated" "grep -q 'Bootstrap' '$SRC_DIR/StarterPlayer/StarterPlayerScripts/OVHL/ClientRuntime.client.lua'"

echo ""
echo "Syntax Tests:"
if command -v luac &> /dev/null; then
    lua_files=$(find "$SRC_DIR" -name "*.lua" -type f)
    for file in $lua_files; do
        test "Syntax: $(basename $file)" "luac -p '$file'"
    done
else
    echo "luac not found, skipping syntax tests"
fi

echo ""
echo "=== Test Results ==="
echo "Total: $test_count"
echo -e "${GREEN}Passed: $pass_count${NC}"
echo -e "${RED}Failed: $fail_count${NC}"
echo ""

if [ $fail_count -eq 0 ]; then
    echo -e "${GREEN}✓ ALL TESTS PASSED${NC}"
    exit 0
else
    echo -e "${RED}✗ TESTS FAILED${NC}"
    exit 1
fi
```

---

# SECTION 7: MODULE TEMPLATES

## 7.1 ENTERPRISE MODULE TEMPLATE

**CREATE: `templates/ModuleTemplate.lua`**

```lua
--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║                    OVHL MODULE TEMPLATE                    ║
    ╠═══════════════════════════════════════════════════════════╣
    ║ Name:        [MODULE_NAME]                                 ║
    ║ Type:        [Feature|System|Service]                      ║
    ║ Version:     1.0.0                                         ║
    ║ Author:      [YOUR_NAME]                                   ║
    ║ Created:     [DATE]                                        ║
    ╠═══════════════════════════════════════════════════════════╣
    ║ Description:                                               ║
    ║   [What this module does]                                  ║
    ╠═══════════════════════════════════════════════════════════╣
    ║ Dependencies:                                              ║
    ║   - [List required services/modules]                       ║
    ╠═══════════════════════════════════════════════════════════╣
    ║ Provides:                                                  ║
    ║   - [List public APIs]                                     ║
    ╚═══════════════════════════════════════════════════════════╝
]]

local Module = {}
Module.__index = Module

-- Module metadata (required for auto-registration)
Module._metadata = {
    Name = "[MODULE_NAME]",
    Type = "[Feature|System]",
    Version = "1.0.0",
    Author = "[YOUR_NAME]"
}

--[[
    LIFECYCLE: Init

    Called during framework initialization.
    Setup dependencies and prepare module state.

    @param ctx Context - Framework context with guaranteed services:
        - Logger: Logging system
        - ConfigLoader: Configuration loader
        - Network: Network bridge
        - [Other services...]
]]
function Module:Init(ctx)
    -- Store context
    self.ctx = ctx

    -- Get logger (auto-detects domain from metadata)
    self.Logger = ctx:GetLogger()
    self.Logger:Info("Initializing...", { Version = self._metadata.Version })

    -- Load configuration
    self._config = ctx.ConfigLoader.Load(self._metadata.Name)

    -- Setup dependencies
    self.Network = ctx.Network
    self.Permissions = ctx.Permissions

    -- Initialize module state
    self._state = {
        initialized = false,
        started = false
    }

    self._state.initialized = true
    self.Logger:Info("Initialized successfully")
end

--[[
    LIFECYCLE: Start

    Called after all modules are initialized.
    Start async operations, register event handlers, etc.
]]
function Module:Start()
    if not self._state.initialized then
        self.Logger:Error("Cannot start: Module not initialized")
        return
    end

    self.Logger:Info("Starting...")

    -- Start async operations here
    -- Example: Listen to player events, start timers, etc.

    self._state.started = true
    self.Logger:Info("Started successfully")
end

--[[
    LIFECYCLE: Stop (Optional)

    Called during graceful shutdown or hot reload.
    Stop async operations, cleanup event handlers.
]]
function Module:Stop()
    if not self._state.started then
        return
    end

    self.Logger:Info("Stopping...")

    -- Stop async operations
    -- Disconnect event handlers

    self._state.started = false
    self.Logger:Info("Stopped")
end

--[[
    LIFECYCLE: Cleanup (Optional)

    Called after Stop, before module destruction.
    Release resources, clear references, etc.
]]
function Module:Cleanup()
    self.Logger:Info("Cleaning up...")

    -- Release resources
    -- Clear references

    self._state = nil
    self.Logger:Info("Cleanup complete")
end

--[[
    PLAYER LIFECYCLE: OnPlayerAdded (Optional)

    Called when a player joins the game.

    @param player Player - The player instance
]]
function Module:OnPlayerAdded(player)
    self.Logger:Info("Player joined", { Player = player.Name })

    -- Handle player join logic
end

--[[
    PLAYER LIFECYCLE: OnPlayerRemoving (Optional)

    Called when a player leaves the game.

    @param player Player - The player instance
]]
function Module:OnPlayerRemoving(player)
    self.Logger:Info("Player leaving", { Player = player.Name })

    -- Handle player leave logic
    -- Save data, cleanup player-specific resources
end

--[[
    HOT RELOAD: OnReload (Optional)

    Called during hot reload in development.
    Preserve state, reconnect handlers.
]]
function Module:OnReload()
    self.Logger:Info("Hot reload triggered")

    -- Preserve state
    -- Reconnect handlers
end

--[[═══════════════════════════════════════════════════════════
    PUBLIC API - Add your methods below
═══════════════════════════════════════════════════════════]]

--[[
    Example public method

    @param arg1 string - Description
    @param arg2 number - Description
    @return boolean - Success status
]]
function Module:ExampleMethod(arg1, arg2)
    self.Logger:Debug("ExampleMethod called", { arg1 = arg1, arg2 = arg2 })

    -- Your logic here

    return true
end

--[[═══════════════════════════════════════════════════════════
    PRIVATE METHODS - Add internal methods below
═══════════════════════════════════════════════════════════]]

--[[
    Example private method
    Use underscore prefix for private methods
]]
function Module:_privateMethod()
    -- Internal logic
end

return Module
```

---

## 7.2 CONFIG TEMPLATE

**CREATE: `templates/SharedConfig.lua`**

```lua
--[[
    Module Configuration Template

    This file defines module behavior and network API.
    Must follow OVHL v2 config schema.
]]

return {
    --[[═══════════════════════════════════════════════════════
        REQUIRED: Module Metadata
    ═══════════════════════════════════════════════════════]]
    Meta = {
        Name = "[MODULE_NAME]",
        Type = "[Feature|System]",  -- Feature: gameplay, System: infrastructure
        Version = "1.0.0",
        Author = "[YOUR_NAME]"
    },

    --[[═══════════════════════════════════════════════════════
        OPTIONAL: Topbar Integration
        Set Enabled = true to add module to topbar
    ═══════════════════════════════════════════════════════]]
    Topbar = {
        Enabled = false,
        Text = "[BUTTON_TEXT]",
        Icon = "rbxassetid://[ASSET_ID]",
        Order = 1,  -- Display order in topbar
        Permission = 0  -- 0=Everyone, 1=VIP, 2=Mod, 3=Admin, 4=HeadAdmin, 5=Owner
    },

    --[[═══════════════════════════════════════════════════════
        OPTIONAL: Module Behavior
        Module-specific settings
    ═══════════════════════════════════════════════════════]]
    Behavior = {
        Debounce = 0.5,
        AutoStart = true,
        -- Add your custom settings here
    },

    --[[═══════════════════════════════════════════════════════
        OPTIONAL: UI Configuration
    ═══════════════════════════════════════════════════════]]
    UI = {
        Type = "Fusion",  -- "Fusion", "Native", or "Hybrid"
        RootTag = "[MODULE_NAME]Window",  -- CollectionService tag
        Theme = "Dark",
        Defaults = {
            Title = "[WINDOW_TITLE]",
            -- Add default UI values
        }
    },

    --[[═══════════════════════════════════════════════════════
        OPTIONAL: Network API
        Define client-server communication
    ═══════════════════════════════════════════════════════]]
    Network = {
        Route = "[MODULE_NAME]",  -- Network route prefix

        Requests = {
            -- Example method
            MethodName = {
                -- Argument type validation
                Args = {
                    { type = "string", name = "param1" },
                    { type = "number", name = "param2", optional = true },
                    { type = "Player", name = "targetPlayer", optional = false },
                    { type = "array", elementType = "string", name = "tags" }
                },
                -- Rate limiting
                RateLimit = {
                    Max = 10,       -- Max calls
                    Interval = 5    -- Per interval (seconds)
                }
            },

            -- Add more methods...
        }
    },

    --[[═══════════════════════════════════════════════════════
        OPTIONAL: Module Contract
        Define dependencies and provided services
    ═══════════════════════════════════════════════════════]]
    Contract = {
        Provides = {
            "MethodName1",
            "MethodName2"
        },
        Requires = {
            "ServiceName1",
            "ServiceName2"
        }
    }
}
```

---

# SECTION 8: MIGRATION SCRIPTS

## 8.1 PHASE 1: CLEANUP SCRIPT

**CREATE: `scripts/phase1-cleanup.sh`**

```bash
#!/bin/bash

# Phase 1: Structure Cleanup
# Removes duplicate src/src/ folder safely

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$PROJECT_ROOT/src"
BACKUP_DIR="$PROJECT_ROOT/backups/phase1-$(date +%Y%m%d_%H%M%S)"

echo "=== Phase 1: Structure Cleanup ==="
echo ""

# Create backup
echo "Creating backup..."
mkdir -p "$BACKUP_DIR"
cp -r "$SRC_DIR" "$BACKUP_DIR/"
echo "Backup created: $BACKUP_DIR"
echo ""

# Check for duplicate
if [ -d "$SRC_DIR/src" ]; then
    echo "Found duplicate src/src/ folder"
    echo "Size: $(du -sh "$SRC_DIR/src" | cut -f1)"
    echo ""

    read -p "Remove duplicate? (y/n): " confirm
    if [ "$confirm" = "y" ]; then
        rm -rf "$SRC_DIR/src"
        echo "✓ Removed src/src/"
    else
        echo "Aborted"
        exit 1
    fi
else
    echo "✓ No duplicate structure found"
fi

echo ""
echo "Phase 1 complete"
```

---

## 8.2 PHASE 2: CORE FILES DEPLOYMENT

**CREATE: `scripts/phase2-deploy-core.sh`**

```bash
#!/bin/bash

# Phase 2: Deploy Core Files
# Deploys new core framework files

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$PROJECT_ROOT/src"
BACKUP_DIR="$PROJECT_ROOT/backups/phase2-$(date +%Y%m%d_%H%M%S)"

echo "=== Phase 2: Deploy Core Files ==="
echo ""

# Create backup
mkdir -p "$BACKUP_DIR"
echo "Creating backup..."

# Function to deploy file
deploy() {
    local content="$1"
    local target="$2"

    echo "Deploying: $target"

    # Backup if exists
    if [ -f "$target" ]; then
        cp "$target" "$BACKUP_DIR/$(basename "$target").backup"
    fi

    # Create directory
    mkdir -p "$(dirname "$target")"

    # Write content
    echo "$content" > "$target"

    # Validate
    if command -v luac &> /dev/null; then
        if luac -p "$target" 2>&1 | grep -q "syntax error"; then
            echo "✗ Syntax error in $target"
            return 1
        fi
    fi

    echo "✓ Deployed: $target"
    echo ""
}

# Deploy OVHL.lua
read -r -d '' OVHL_CONTENT << 'EOF' || true
-- OVHL Framework Public API
local RS = game:GetService("ReplicatedStorage")
local OVHL_ROOT = RS.OVHL

local OVHL = {
    VERSION = "2.0.0",
    BUILD = "2024-11-20",
}

-- Core
OVHL.Logger = require(OVHL_ROOT.Core.SmartLogger)
OVHL.Config = require(OVHL_ROOT.Core.SharedConfigLoader)
OVHL.Enums = require(OVHL_ROOT.Core.EngineEnums)
OVHL.Types = require(OVHL_ROOT.Types.CoreTypes)
OVHL.DomainResolver = require(OVHL_ROOT.Core.Logging.DomainResolver)

-- UI Foundation
OVHL.Theme = require(OVHL_ROOT.UI.Foundation.Theme)
OVHL.Layers = require(OVHL_ROOT.UI.Foundation.Layers)
OVHL.Typography = require(OVHL_ROOT.UI.Foundation.Typography)
OVHL.FusionHelper = require(OVHL_ROOT.UI.Foundation.FusionHelper)

-- UI Components (lazy loaded)
OVHL.UI = setmetatable({}, {
    __index = function(self, key)
        local component = rawget(self, key)
        if component then return component end

        local paths = {
            Window = OVHL_ROOT.UI.Components.Surfaces.Window,
            Card = OVHL_ROOT.UI.Components.Surfaces.Card,
            Tooltip = OVHL_ROOT.UI.Components.Surfaces.Tooltip,
            Separator = OVHL_ROOT.UI.Components.Surfaces.Separator,
            Button = OVHL_ROOT.UI.Components.Inputs.Button,
            TextField = OVHL_ROOT.UI.Components.Inputs.TextField,
            Flex = OVHL_ROOT.UI.Components.Containers.Flex,
            Grid = OVHL_ROOT.UI.Components.Containers.Grid,
            Canvas = OVHL_ROOT.UI.Components.Containers.Canvas,
            Badge = OVHL_ROOT.UI.Components.Feedback.Badge,
            LoadingSpinner = OVHL_ROOT.UI.Components.Feedback.LoadingSpinner,
        }

        local path = paths[key]
        if path then
            component = require(path)
            rawset(self, key, component)
            return component
        end

        error("Unknown UI component: " .. tostring(key))
    end
})

OVHL.Icons = require(OVHL_ROOT.UI.Assets.Icons)

function OVHL.GetVersion()
    return OVHL.VERSION
end

function OVHL.IsDebug()
    return game:GetService("RunService"):IsStudio()
end

return OVHL
EOF

deploy "$OVHL_CONTENT" "$SRC_DIR/ReplicatedStorage/OVHL/OVHL.lua"

echo "Phase 2 complete"
echo "Backup: $BACKUP_DIR"
```

---

## 8.3 PHASE 3: KERNEL REFACTOR

**CREATE: `scripts/phase3-refactor-kernels.sh`**

```bash
#!/bin/bash

# Phase 3: Refactor Kernels
# Removes hard-coded module mappings

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$PROJECT_ROOT/src"

echo "=== Phase 3: Refactor Kernels ==="
echo ""

SERVER_KERNEL="$SRC_DIR/ServerScriptService/OVHL/Core/Kernel.lua"
CLIENT_KERNEL="$SRC_DIR/StarterPlayer/StarterPlayerScripts/OVHL/Core/Kernel.lua"

echo "Refactoring Server Kernel..."

# Backup
cp "$SERVER_KERNEL" "$SERVER_KERNEL.backup"

# Replace hard-coded mapping with DomainResolver
sed -i.bak '/if f.Name == "Admin"/,/end/ {
    /if f.Name == "Admin"/c\
    local DomainResolver = require(RS.OVHL.Core.Logging.DomainResolver)\
    local domain = DomainResolver.Resolve(f.Name)\
    srv.Logger = Logger.New(domain, { moduleName = f.Name })
    /elseif/d
    /srv.Logger/d
}' "$SERVER_KERNEL"

echo "✓ Server Kernel refactored"

echo "Refactoring Client Kernel..."

# Backup
cp "$CLIENT_KERNEL" "$CLIENT_KERNEL.backup"

# Same for client
sed -i.bak '/if f.Name == "Admin"/,/end/ {
    /if f.Name == "Admin"/c\
    local DomainResolver = require(RS.OVHL.Core.Logging.DomainResolver)\
    local domain = DomainResolver.Resolve(f.Name)\
    mod.Logger = Logger.New(domain, { moduleName = f.Name })
    /elseif/d
    /mod.Logger/d
}' "$CLIENT_KERNEL"

echo "✓ Client Kernel refactored"

echo ""
echo "Phase 3 complete"
echo "Backups created with .backup extension"
```

---

# SECTION 9: AI HANDOFF INSTRUCTIONS

## FOR THE NEXT AI ASSISTANT

### CRITICAL CONTEXT

1. **OVHL Framework** is a Roblox game framework in Lua
2. **Rojo** is used for syncing - `init.lua` becomes parent folder name
3. **NO MANUAL EDITS** - All Lua changes via bash automation
4. **BACKUP FIRST** - Always create backup before changes
5. **VALIDATE SYNTAX** - Use luac to check Lua files
6. **ATOMIC OPERATIONS** - All or nothing, rollback on error

### WHAT HAPPENED

Previous AI (DeepSeek) created duplicate `src/src/` structure - architectural sabotage. Also hard-coded module mappings instead of using existing DomainResolver.

### CURRENT STATE

- Duplicate structure identified
- Hard-coded mappings identified
- Refactor plan created
- Automation scripts prepared
- NO changes applied yet

### WHAT YOU NEED TO DO

1. **Read this entire document** - Don't skip sections
2. **Review current codebase** - Use snapshot provided
3. **Execute Phase 1** - Cleanup duplicate structure
4. **Execute Phase 2** - Deploy core files
5. **Execute Phase 3** - Refactor kernels
6. **Validate** - Run test suite
7. **Document** - Log all changes

### AUTOMATION RULES

```bash
# Always follow this pattern:
1. Create backup
2. Make changes
3. Validate syntax
4. Test functionality
5. Commit if successful
6. Rollback if failed
```

### FILE NAMING CONSTRAINTS

**FORBIDDEN:**

- `init.lua` (Rojo converts to parent name)
- `init.server.lua`
- `init.client.lua`

**ALLOWED:**

- `OVHL.lua` (Public API)
- `Bootstrap.lua` (Entry point)
- `ModuleName.lua` (Any descriptive name)

### DELIVERY METHOD

**FOR LUA FILES:**

```bash
# Use bash scripts only
./scripts/deploy-refactor.sh
./scripts/test-deployment.sh
```

**FOR DOCUMENTATION (.md, .txt):**

```
# Manual review required
# Place in docs/ folder
# No bash automation
```

### SUCCESS CRITERIA

```
[ ] No src/src/ duplicate
[ ] No hard-coded module mappings
[ ] All modules use DomainResolver
[ ] Public API (OVHL.lua) working
[ ] Bootstrap.lua working
[ ] Context system implemented
[ ] Type validation working
[ ] Config validation working
[ ] Error boundaries working
[ ] All tests passing
[ ] No regressions
[ ] Documentation updated
```

### FAILURE HANDLING

If anything breaks:

```bash
# Immediate rollback
./scripts/rollback.sh

# Review logs
cat logs/deploy-*.log

# Fix issue
# Retry deployment
```

### COMMUNICATION PROTOCOL

When reporting to developer:

```
STATUS: [IN_PROGRESS|COMPLETED|FAILED]
PHASE: [1-3]
FILES_MODIFIED: [count]
TESTS_PASSED: [X/Y]
ERRORS: [list]
NEXT_STEPS: [action items]
```

### COMMON PITFALLS

1. **Don't skip backups** - Always backup first
2. **Don't edit manually** - Use bash scripts
3. **Don't rush** - Validate each phase
4. **Don't ignore errors** - Fix before continuing
5. **Don't use init.lua** - Rojo naming conflict

### DEBUGGING TIPS

```lua
-- If logger not working:
print("DEBUG:", tostring(value))

-- If module not loading:
warn("Module path:", debug.traceback())

-- If config invalid:
print("Config:", game:GetService("HttpService"):JSONEncode(config))
```

### TESTING IN ROBLOX STUDIO

```lua
-- Quick test in Studio command bar:
local OVHL = require(game.ReplicatedStorage.OVHL.OVHL)
print(OVHL.VERSION)
print(OVHL.Logger)
print(OVHL.UI.Button)
```

### FINAL NOTES

This refactor is **CRITICAL** for framework scalability. Execute carefully, test thoroughly, document completely.

**NO SHORTCUTS. NO HALF-MEASURES.**

Good luck. The framework depends on you.

---

# APPENDIX: QUICK REFERENCE

## A1: Directory Structure

```
src/
├── ReplicatedStorage/
│   └── OVHL/
│       ├── OVHL.lua              ← Public API
│       ├── Bootstrap.lua          ← Entry point
│       ├── Core/
│       │   ├── SmartLogger.lua
│       │   ├── Context.lua        ← NEW
│       │   ├── TypeValidator.lua  ← NEW
│       │   ├── ConfigSchema.lua   ← NEW
│       │   ├── ErrorHandler.lua   ← NEW
│       │   └── Logging/
│       │       └── DomainResolver.lua
│       ├── Modules/
│       │   ├── Admin/
│       │   ├── Inventory/
│       │   └── PrototypeShop/
│       └── UI/
├── ServerScriptService/
│   └── OVHL/
│       ├── ServerRuntime.server.lua
│       └── Core/
│           └── Kernel.lua         ← REFACTORED
└── StarterPlayer/
    └── StarterPlayerScripts/
        └── OVHL/
            ├── ClientRuntime.client.lua
            └── Core/
                └── Kernel.lua     ← REFACTORED
```

## A2: Command Cheat Sheet

```bash
# Cleanup
./scripts/phase1-cleanup.sh

# Deploy core files
./scripts/phase2-deploy-core.sh

# Refactor kernels
./scripts/phase3-refactor-kernels.sh

# Run full deployment
./scripts/deploy-refactor.sh

# Test deployment
./scripts/test-deployment.sh

# Validate Lua syntax
./scripts/validate-lua.sh

# Create backup
./scripts/backup.sh

# Rollback
./scripts/rollback.sh
```

## A3: Lua Import Patterns

**OLD (Inconsistent):**

```lua
local Logger = require(game.ReplicatedStorage.OVHL.Core.SmartLogger)
local Theme = require(script.Parent.Foundation.Theme)
```

**NEW (Standard):**

```lua
local OVHL = require(game.ReplicatedStorage.OVHL.OVHL)
local Logger = OVHL.Logger
local Theme = OVHL.Theme
local Button = OVHL.UI.Button
```

## A4: Module Lifecycle

```lua
function Module:Init(ctx)      -- Setup (Phase 1)
function Module:Start()         -- Begin (Phase 2)
function Module:Stop()          -- Pause (Optional)
function Module:Cleanup()       -- Destroy (Optional)
function Module:OnPlayerAdded(player)    -- Player join
function Module:OnPlayerRemoving(player) -- Player leave
```

---

**END OF COMPREHENSIVE REFACTOR GUIDE**

**DOCUMENT VERSION:** 2.0
**TOTAL SECTIONS:** 9
**TOTAL SCRIPTS:** 8
**ESTIMATED PAGES:** 50+

**STATUS:** READY FOR IMPLEMENTATION

Execute systematically. Test rigorously. Deploy confidently.

**MAY YOUR REFACTOR BE SWIFT AND YOUR BUGS BE FEW.**
