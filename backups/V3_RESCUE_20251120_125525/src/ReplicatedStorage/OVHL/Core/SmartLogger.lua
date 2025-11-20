--[[ @Component: SmartLogger (Enterprise Grade with Auto-Detection) ]]
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Config = require(game:GetService("ReplicatedStorage").OVHL.Config.LoggerConfig)
local DomainResolver = require(game:GetService("ReplicatedStorage").OVHL.Core.Logging.DomainResolver)

local SmartLogger = {}
SmartLogger.__index = SmartLogger

local IS_SERVER = RunService:IsServer()
local CONTEXT = IS_SERVER and "[SERVER]" or "[CLIENT]"

function SmartLogger.New(domain, overrides)
    local self = setmetatable({}, SmartLogger)
    
    -- Auto-detect domain if not provided
    self._domain = domain or "SYSTEM"
    if self._domain == "SYSTEM" and overrides and overrides.moduleName then
        self._domain = DomainResolver.Resolve(overrides.moduleName)
    end
    
    self._domainDisplay = Config.Domains[self._domain] or Config.Domains.DEFAULT
    
    local defLvl = Config.DefaultLevel or "INFO"
    local myLvl = (overrides and overrides.LogLevel) or defLvl
    self._weight = Config.Levels[myLvl] and Config.Levels[myLvl].Weight or 2
    
    -- Health tracking
    self._health = {
        totalLogs = 0,
        failedLogs = 0,
        domain = self._domain
    }
    
    return self
end

function SmartLogger:_safeFormat(level, message, data)
    if not message or type(message) ~= "string" then
        return nil, "Invalid message: " .. type(message)
    end
    
    local cfg = Config.Levels[level]
    if not cfg then
        return nil, "Invalid level: " .. tostring(level)
    end
    
    local meta = ""
    if data ~= nil then
        local success, result = pcall(function()
            if type(data) == "table" then
                local ok, json = pcall(HttpService.JSONEncode, HttpService, data)
                return ok and " │ " .. json or " │ " .. tostring(data)
            else
                return " │ " .. tostring(data)
            end
        end)
        meta = success and result or ""
    end

    local levelIcon = cfg.Icon or "📝"
    local domainDisplay = self._domainDisplay or "📝 SYSTEM"
    
    local success, result = pcall(string.format, "%s %s %s\n   └── %s%s", 
        levelIcon, CONTEXT, domainDisplay, message, meta)
        
    return success and result or nil
end

function SmartLogger:_log(level, message, data)
    local cfg = Config.Levels[level]
    if not cfg or cfg.Weight < self._weight then return end
    
    self._health.totalLogs += 1
    
    local logMessage, err = self:_safeFormat(level, message, data)
    if not logMessage then
        self._health.failedLogs += 1
        return
    end
    
    local success = pcall(function()
        if level == "ERROR" or level == "CRITICAL" then
            warn(logMessage)
        else
            print(logMessage)
        end
    end)
    
    if not success then
        self._health.failedLogs += 1
    end
end

-- Public API
function SmartLogger:Debug(m, d) if self:_validateCall("Debug", m) then self:_log("DEBUG", m, d) end end
function SmartLogger:Info(m, d)  if self:_validateCall("Info", m) then self:_log("INFO", m, d) end end
function SmartLogger:Warn(m, d)  if self:_validateCall("Warn", m) then self:_log("WARN", m, d) end end
function SmartLogger:Error(m, d) if self:_validateCall("Error", m) then self:_log("ERROR", m, d) end end
function SmartLogger:Critical(m, d) if self:_validateCall("Critical", m) then self:_log("CRITICAL", m, d) end end

function SmartLogger:_validateCall(method, message)
    if not message or type(message) ~= "string" then return false end
    return true
end

function SmartLogger:GetHealth()
    return {
        domain = self._domain,
        totalLogs = self._health.totalLogs,
        failedLogs = self._health.failedLogs,
        successRate = (self._health.totalLogs > 0) and 
                     ((self._health.totalLogs - self._health.failedLogs) / self._health.totalLogs) or 1
    }
end

return SmartLogger
