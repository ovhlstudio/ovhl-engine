--[[ @Component: SmartLogger (Enterprise Grade) ]]
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Config = require(game:GetService("ReplicatedStorage").OVHL.Config.LoggerConfig)

local SmartLogger = {}
SmartLogger.__index = SmartLogger

local IS_SERVER = RunService:IsServer()
local CONTEXT = IS_SERVER and "[SERVER]" or "[CLIENT]"

function SmartLogger.New(domain, overrides)
    local self = setmetatable({}, SmartLogger)
    self._domain = domain or "SYSTEM"
    
    local defLvl = Config.DefaultLevel or "INFO"
    local myLvl = (overrides and overrides.LogLevel) or defLvl
    
    self._weight = Config.Levels[myLvl] and Config.Levels[myLvl].Weight or 2
    return self
end

function SmartLogger:_log(level, message, data)
    local cfg = Config.Levels[level]
    if not cfg or cfg.Weight < self._weight then return end

    local domainConfig = Config.Domains[self._domain] or Config.Domains.DEFAULT
    local levelIcon = cfg.Icon or ""

    -- Safe data serialization
    local meta = ""
    if data ~= nil then
        if type(data) == "table" then
            local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
            if ok then
                meta = " │ " .. json
            else
                local keyValues = {}
                for k, v in pairs(data) do
                    table.insert(keyValues, k .. "=" .. tostring(v))
                end
                meta = " │ " .. table.concat(keyValues, ", ")
            end
        else
            meta = " │ " .. tostring(data)
        end
    end

    -- Clean log message
    local logMessage = string.format("%s %s %s\n   └── %s%s", 
        levelIcon, CONTEXT, domainConfig, message, meta)

    if level == "ERROR" or level == "CRITICAL" then
        warn(logMessage)
    else
        print(logMessage)
    end
end

function SmartLogger:Debug(message, data) 
    self:_log("DEBUG", message, data) 
end

function SmartLogger:Info(message, data)  
    self:_log("INFO", message, data) 
end

function SmartLogger:Warn(message, data)  
    self:_log("WARN", message, data) 
end

function SmartLogger:Error(message, data) 
    self:_log("ERROR", message, data) 
end

function SmartLogger:Critical(message, data) 
    self:_log("CRITICAL", message, data) 
end

return SmartLogger
