> START OF ./docs/OVHL_API/01_LOGGER_GUIDE.md

# 🎯 OVHL ENGINE - SMART LOGGER GUIDE

**Version:** 2.0.0  
**Status:** ACTIVE  
**Last Updated:** November 17, 2025

## 📖 DAFTAR ISI

- [Overview](#overview)
- [Quick Start](#quick-start)
- [API Reference](#api-reference)
- [Domain System](#domain-system)
- [Model System](#model-system)
- [Best Practices](#best-practices)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)

## 🚀 OVERVIEW

**SmartLogger** adalah foundation logging system OVHL Engine dengan fitur:

- ✅ **4 Model System** - SILENT, NORMAL, DEBUG, VERBOSE
- ✅ **Emoji-based Domains** - 20+ predefined domains dengan visual identifier
- ✅ **Structured Metadata** - Key-value pairs untuk contextual logging
- ✅ **Studio Optimization** - Color-coded output dengan formatting optimal
- ✅ **Performance Aware** - Zero overhead di production mode

## ⚡ QUICK START

### Basic Usage

```lua
local OVHL = require(game:GetService("ReplicatedStorage").OVHL.Core.OVHL)
local Logger = OVHL:GetSystem("SmartLogger")

-- Simple logging
Logger:Info("SERVER", "Engine started", {version = "1.0.0"})

-- Dengan metadata
Logger:Debug("DATA", "Processing request", {
    userId = 123,
    action = "purchase",
    timestamp = os.time()
})
```

### Expected Studio Output

```
🐛 LOGGER - SmartLogger initialized {model=DEBUG}
🚀 SERVER - Engine started {version=1.0.0}
📊 DATA - Processing request {userId=123 action=purchase timestamp=1700000000}
❌ SERVICE - Operation failed {error="Timeout", retries=3}
```

## 📚 API REFERENCE

### Core Logging Methods

```lua
-- Debug information (development only)
Logger:Debug(domain, message, metadata)

-- General information
Logger:Info(domain, message, metadata)

-- Potential issues
Logger:Warn(domain, message, metadata)

-- Recoverable errors
Logger:Error(domain, message, metadata)

-- System-breaking errors
Logger:Critical(domain, message, metadata)
```

### Model Management

```lua
-- Set logging model
Logger:SetModel("DEBUG")    -- Development
Logger:SetModel("NORMAL")   -- Testing
Logger:SetModel("SILENT")   -- Production
Logger:SetModel("VERBOSE")  -- Deep analysis

-- Get current model
local currentModel = Logger:GetModel()

-- Check model state
if Logger:IsModel("DEBUG") then
    -- Debug-specific logic
end
```

### Advanced Logging

```lua
-- Performance logging (VERBOSE mode only)
Logger:Performance("TIMING", "Database query", {duration=0.15, rows=50})

-- Internal system logging (VERBOSE mode only)
Logger:Internal("MEMORY", "Garbage collection", {freed=1024, time=0.01})
```

## 🎨 DOMAIN SYSTEM

### Core Domains

| Domain   | Emoji | Purpose                | Color  |
| -------- | ----- | ---------------------- | ------ |
| `SERVER` | 🚀    | Server-side operations | Red    |
| `CLIENT` | 🎮    | Client-side operations | Blue   |
| `DOMAIN` | 🏗️    | Business logic         | Green  |
| `DATA`   | 📊    | Data flow & state      | Yellow |

### System Domains

| Domain       | Emoji | Purpose               |
| ------------ | ----- | --------------------- |
| `CONFIG`     | ⚙️    | Configuration systems |
| `SERVICE`    | 🔧    | Service operations    |
| `CONTROLLER` | 🎯    | Controller logic      |
| `NETWORK`    | 🌐    | Networking & remotes  |
| `UI`         | 📱    | User interface        |
| `PERMISSION` | 🔐    | Auth & permissions    |
| `STATE`      | 💾    | State management      |
| `MODULE`     | 📦    | Module lifecycle      |

### Advanced Domains

| Domain        | Emoji | Purpose             |
| ------------- | ----- | ------------------- |
| `PERFORMANCE` | ⚡    | Performance metrics |
| `DEBUG`       | 🐛    | Debug information   |
| `MEMORY`      | 🧠    | Memory usage        |
| `TIMING`      | ⏱️    | Timing measurements |
| `INTERNAL`    | 🔍    | Internal systems    |

## ⚙️ MODEL SYSTEM

### Model Comparison

| Model       | Levels                              | Performance     | Use Case              |
| ----------- | ----------------------------------- | --------------- | --------------------- |
| **SILENT**  | CRITICAL only                       | Zero impact     | Production live games |
| **NORMAL**  | INFO+WARN+ERROR+CRITICAL            | Minimal impact  | Standard testing      |
| **DEBUG**   | DEBUG+INFO+WARN+ERROR+CRITICAL      | Moderate impact | Active development    |
| **VERBOSE** | All levels + PERFORMANCE + INTERNAL | High impact     | System analysis       |

### Model Configuration

```lua
-- EngineConfig.lua
Logging = {
    Model = "DEBUG",  -- SILENT, NORMAL, DEBUG, VERBOSE

    Models = {
        SILENT = {
            Levels = {"CRITICAL"},
            PerformanceLogging = false,
            InternalLogging = false
        },
        DEBUG = {
            Levels = {"DEBUG", "INFO", "WARN", "ERROR", "CRITICAL"},
            PerformanceLogging = false,
            InternalLogging = false
        },
        VERBOSE = {
            Levels = {"DEBUG", "INFO", "WARN", "ERROR", "CRITICAL"},
            PerformanceLogging = true,
            InternalLogging = true
        }
    }
}
```

## 🏆 BEST PRACTICES

### Domain Selection

```lua
-- ✅ GOOD - Specific domain
Logger:Info("SERVICE", "User service started", {users=150})

-- ❌ BAD - Generic domain
Logger:Info("SYSTEM", "Something happened")

-- ✅ GOOD - Appropriate level
Logger:Debug("NETWORK", "Packet details", {size=256, type="RELIABLE"})
Logger:Warn("PERFORMANCE", "Slow operation", {duration=0.25})
```

### Metadata Usage

```lua
-- ✅ GOOD - Structured metadata
Logger:Error("DATABASE", "Query failed", {
    query = "SELECT * FROM users",
    error = errMessage,
    retries = 3
})

-- ❌ BAD - Unstructured message
Logger:Error("DATABASE", "Query SELECT * FROM users failed with error: " .. errMessage)

-- ✅ GOOD - Sensitive data filtering
Logger:Info("AUTH", "Login attempt", {
    userId = 123,
    success = true,
    -- ❌ JANGAN log: password, token, personal data
})
```

### Performance Considerations

```lua
-- ✅ GOOD - Conditional debugging
if Logger:IsModel("DEBUG") then
    Logger:Debug("NETWORK", "Raw packet data", {data = largeData})
end

-- ✅ GOOD - Lazy metadata evaluation
local function expensiveCalculation()
    -- Heavy computation
end

Logger:Debug("PERFORMANCE", "Operation completed", {
    -- Calculation only happens in DEBUG mode
    metric = Logger:IsModel("DEBUG") and expensiveCalculation() or nil
})
```

## 📝 EXAMPLES

### Service Implementation

```lua
-- MyService.lua
local MyService = Knit.CreateService {
    Name = "MyService",
    Client = {}
}

function MyService:KnitInit()
    self.OVHL = require(game:GetService("ReplicatedStorage").OVHL.Core.OVHL)
    self.Logger = self.OVHL:GetSystem("SmartLogger")
    self.Config = self.OVHL:GetConfig("MyModule")

    self.Logger:Info("SERVICE", "MyService initialized", {
        version = self.Config.Version,
        features = #self.Config.Features
    })
end

function MyService:ProcessOrder(player, orderData)
    self.Logger:Debug("DOMAIN", "Processing order", {
        player = player.Name,
        orderId = orderData.id,
        amount = orderData.amount
    })

    -- Business logic
    local success, result = pcall(function()
        return self:_validateOrder(orderData)
    end)

    if not success then
        self.Logger:Error("DOMAIN", "Order validation failed", {
            player = player.Name,
            error = result,
            orderId = orderData.id
        })
        return false, "Validation failed"
    end

    self.Logger:Info("DOMAIN", "Order processed successfully", {
        player = player.Name,
        orderId = orderData.id,
        amount = orderData.amount
    })

    return true, "Success"
end
```

### Controller Implementation

```lua
-- MyController.lua
local MyController = Knit.CreateController {
    Name = "MyController"
}

function MyController:KnitInit()
    self.OVHL = require(game:GetService("ReplicatedStorage").OVHL.Core.OVHL)
    self.Logger = self.OVHL:GetSystem("SmartLogger")
    self.Router = self.OVHL:GetSystem("NetworkingRouter")

    self.Logger:Info("CONTROLLER", "MyController ready", {
        theme = self.Config.UI.Theme
    })
end

function MyController:OnButtonClick(buttonId)
    self.Logger:Debug("UI", "Button clicked", {
        buttonId = buttonId,
        timestamp = os.time()
    })

    self.Router:SendServer("ButtonAction", {id = buttonId})
end

function MyController:ShowNotification(message, type)
    self.Logger:Info("UI", "Showing notification", {
        type = type,
        length = #message
    })

    -- UI implementation
end
```

### System Module Implementation

```lua
-- ConfigLoader.lua
local ConfigLoader = {}
ConfigLoader.__index = ConfigLoader

function ConfigLoader:ResolveConfig(moduleName, context)
    self.Logger:Debug("CONFIG", "Resolving config", {
        module = moduleName,
        context = context,
        layers = 3
    })

    local startTime = os.clock()

    -- Config resolution logic
    local config = self:_loadLayers(moduleName, context)

    local duration = os.clock() - startTime
    self.Logger:Performance("TIMING", "Config resolution", {
        module = moduleName,
        duration = duration,
        keys = #config
    })

    if not config then
        self.Logger:Error("CONFIG", "Config resolution failed", {
            module = moduleName,
            context = context
        })
    end

    return config
end
```

## 🐛 TROUBLESHOOTING

### Common Issues

**Problem:** No log output in Studio

```lua
-- Solution: Check current model
print("Current model:", Logger:GetModel())

-- Solution: Ensure logger is initialized
local Logger = OVHL:GetSystem("SmartLogger")
if Logger then
    Logger:Info("DEBUG", "Logger test", {working = true})
end
```

**Problem:** Metadata not showing

```lua
-- ✅ GOOD - Table metadata
Logger:Info("TEST", "Message", {key = "value", number = 42})

-- ❌ BAD - Non-table metadata
Logger:Info("TEST", "Message", "string_metadata")
```

**Problem:** Domain not recognized

```lua
-- ✅ GOOD - Use predefined domains
Logger:Info("SERVER", "Message")  -- 🚀 SERVER

-- ❌ BAD - Unknown domain
Logger:Info("CUSTOM", "Message")  -- 📄 CUSTOM (fallback)
```

### Performance Optimization

```lua
-- Use string interpolation sparingly
local playerName = player.Name
-- ✅ GOOD
Logger:Debug("GAME", "Player action", {player = playerName, action = "jump"})

-- ❌ BAD - String concatenation in log call
Logger:Debug("GAME", "Player " .. playerName .. " performed action: jump")

-- Use conditional logging for expensive operations
if Logger:IsModel("DEBUG") then
    local debugInfo = self:_collectDebugInfo()
    Logger:Debug("SYSTEM", "Debug data", debugInfo)
end
```

## 🔧 CONFIGURATION

### Engine-Level Configuration

```lua
-- ReplicatedStorage.OVHL.Config.EngineConfig.lua
return {
    Logging = {
        Model = "DEBUG",
        EnableFileLogging = false,
        EnableColors = true,

        Models = {
            DEBUG = {
                Levels = {"DEBUG", "INFO", "WARN", "ERROR", "CRITICAL"},
                PerformanceLogging = false,
                InternalLogging = false
            }
            -- ... other models
        }
    }
}
```

### Module-Level Override

```lua
-- ServerScriptService.OVHL.Modules.MyModule.ServerConfig.lua
return {
    Logging = {
        Model = "NORMAL",  -- Override for this module
        CustomDomains = {
            PAYMENT = { Emoji = "💳", Color = Color3.fromRGB(100, 200, 100) },
            ANALYTICS = { Emoji = "📈", Color = Color3.fromRGB(200, 100, 200) }
        }
    }
}
```

## 📞 SUPPORT

### Getting Help

- **Documentation:** `./docs/01_OVHL_ENGINE.md` - Architecture overview
- **Examples:** `MinimalModule/` - Reference implementation
- **Issues:** Check `03_DEV_LOG.md` for known problems and solutions

### Reporting Issues

When reporting logger issues, include:

- Current logging model
- Domain and level used
- Expected vs actual output
- Any error messages or stack traces

---

> END OF ./docs/OVHL_API/01_LOGGER_GUIDE.md
