--[[ @Component: SmartLogger (Standardized V2.2) ]]
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Config = require(game:GetService("ReplicatedStorage").OVHL.Config.LoggerConfig)

local SmartLogger = {}
SmartLogger.__index = SmartLogger

local IS_SERVER = RunService:IsServer()
local CONTEXT = IS_SERVER and "SRV" or "CLI"

function SmartLogger.New(domain, overrides)
    local self = setmetatable({}, SmartLogger)
    self._domain = string.upper(domain or "SYS")
    
    local defLvl = Config.DefaultLevel or "INFO"
    local myLvl = (overrides and overrides.LogLevel) or defLvl
    
    self._weight = Config.Levels[myLvl] and Config.Levels[myLvl].Weight or 1
    return self
end

function SmartLogger:_log(level, msg, data)
    local cfg = Config.Levels[level]
    if not cfg or cfg.Weight < self._weight then return end

    local iconDom = Config.Domains[self._domain] or "📝"
    local iconLvl = cfg.Icon or ""

    -- Safe Serialize
    local meta = ""
    if data ~= nil then
        if type(data) == "table" then
            local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
            if ok then
                -- Clean output formatting
                meta = "\n   └─ " .. json
            else
                -- Fallback dump keys
                local keys = {}
                for k,_ in pairs(data) do table.insert(keys, tostring(k)) end
                meta = "\n   └─ [Unserializable] Keys: " .. table.concat(keys, ", ")
            end
        else
            meta = "\n   └─ " .. tostring(data)
        end
    end

    local text = string.format("%s [%s]%s %s: %s%s", 
        iconLvl, CONTEXT, iconDom, self._domain, tostring(msg), meta)

    if level == "ERROR" or level == "CRITICAL" then
        warn(text)
    else
        print(text)
    end
end

function SmartLogger:Debug(m, d) self:_log("DEBUG", m, d) end
function SmartLogger:Info(m, d)  self:_log("INFO", m, d) end
function SmartLogger:Warn(m, d)  self:_log("WARN", m, d) end
function SmartLogger:Error(m, d) self:_log("ERROR", m, d) end

return SmartLogger
