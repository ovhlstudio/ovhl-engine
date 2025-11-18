--[[
OVHL ENGINE V1.0.0
@Component: SmartLogger (Foundation)
@Path: ReplicatedStorage.OVHL.Systems.Foundation.SmartLogger
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.0.0 - SMART LOGGER SYSTEM
Version: 1.0.1
Path: ReplicatedStorage.OVHL.Systems.Foundation.SmartLogger

FEATURES:
- 4 Model System: SILENT, NORMAL, DEBUG, VERBOSE
- Emoji-based domains dengan color coding
- Structured metadata logging
- Performance-aware (zero overhead in production)
--]]

local SmartLogger = {}
SmartLogger.__index = SmartLogger

-- Private state
local _currentModel = "DEBUG"
local _formatter = nil
local _initialized = false

function SmartLogger.new()
    local self = setmetatable({}, SmartLogger)
    self:_initialize()
    return self
end

function SmartLogger:_initialize()
    -- Load config and formatter FIRST without self-calls
    local config = self:_loadConfig()
    _currentModel = config.Model or "DEBUG"
    _formatter = self:_loadFormatter()
    
    -- Mark as initialized but don't log yet (avoid circular dependency)
    _initialized = true
    
    -- Use direct print for initialization message
    print("🐛 LOGGER - SmartLogger initialized {model=" .. _currentModel .. "}")
end

function SmartLogger:_loadConfig()
    local success, config = pcall(function()
        return require(script.Parent.Parent.Parent.Config.LoggerConfig)
    end)
    return success and config or {}
end

function SmartLogger:_loadFormatter()
    local success, formatter = pcall(function()
        return require(script.Parent.Parent.Parent.Systems.Foundation.StudioFormatter)
    end)
    return success and formatter.new() or nil
end

function SmartLogger:_shouldLog(level)
    if not _initialized then return false end
    
    local config = self:_loadConfig()
    local modelConfig = config.Models[_currentModel] or config.Models.DEBUG
    
    for _, allowedLevel in ipairs(modelConfig.Levels or {}) do
        if allowedLevel == level then
            return true
        end
    end
    return false
end

function SmartLogger:_output(level, domain, message, metadata)
    if not self:_shouldLog(level) then
        return
    end
    
    local formattedMessage, color = "[FORMATTER_ERROR] " .. message, Color3.new(1, 0, 0)
    
    if _formatter then
        formattedMessage, color = _formatter:FormatMessage(level, domain, message, metadata)
    end
    
    -- Output dengan color coding
    if level == "ERROR" or level == "CRITICAL" then
        warn(formattedMessage)
    else
        print(formattedMessage)
    end
end

-- PUBLIC API
function SmartLogger:SetModel(modelName)
    local config = self:_loadConfig()
    if config.Models[modelName] then
        _currentModel = modelName
        self:Info("LOGGER", "Logger model changed", {model = modelName})
        return true
    end
    return false
end

function SmartLogger:GetModel()
    return _currentModel
end

function SmartLogger:IsModel(modelName)
    return _currentModel == modelName
end

function SmartLogger:Initialize(logger)
    -- For SystemRegistry compatibility
    self:_initialize()
end

-- LOGGING METHODS
function SmartLogger:Debug(domain, message, metadata)
    self:_output("DEBUG", domain, message, metadata)
end

function SmartLogger:Info(domain, message, metadata)
    self:_output("INFO", domain, message, metadata)
end

function SmartLogger:Warn(domain, message, metadata)
    self:_output("WARN", domain, message, metadata)
end

function SmartLogger:Error(domain, message, metadata)
    self:_output("ERROR", domain, message, metadata)
end

function SmartLogger:Critical(domain, message, metadata)
    self:_output("CRITICAL", domain, message, metadata)
end

-- PERFORMANCE LOGGING (Verbose only)
function SmartLogger:Performance(domain, message, metadata)
    if _currentModel == "VERBOSE" then
        self:_output("DEBUG", "PERFORMANCE", message, metadata)
    end
end

return SmartLogger

--[[
@End: SmartLogger.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

