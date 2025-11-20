--[[ @Component: SmartLogger (V17 - Dynamic Auto-Labeling) ]]
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Config = require(game:GetService("ReplicatedStorage").OVHL.Config.LoggerConfig)

local SmartLogger = {}
SmartLogger.__index = SmartLogger

local IS_SERVER = RunService:IsServer()
local CONTEXT = IS_SERVER and "[SERVER]" or "[CLIENT]"

function SmartLogger.New(domain, overrides)
    local self = setmetatable({}, SmartLogger)
    
    -- Raw Domain (Simpan string aslinya buat filtering di Studio)
    self._rawDomain = domain or "SYSTEM"
    
    -- Resolve Display Label
    -- Logic V17: Kalau ada di Config pake Config, kalau gak ada BIKIN SENDIRI.
    local mapped = Config.Domains[self._rawDomain]
    if mapped then
        self._domainDisplay = mapped
    else
        -- Auto-Generate Label: "📦 NAMADOMAIN"
        self._domainDisplay = string.format("📦 %s", self._rawDomain:upper())
    end
    
    local defLvl = Config.DefaultLevel or "INFO"
    local myLvl = (overrides and overrides.LogLevel) or defLvl
    self._weight = Config.Levels[myLvl] and Config.Levels[myLvl].Weight or 2
    
    return self
end

function SmartLogger:_safeFormat(level, message, data)
    if not message then return nil end
    
    local cfg = Config.Levels[level]
    if not cfg then return nil end
    
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
    
    -- FORMAT: [ICON] [SIDE] [DOMAIN_LABEL] -> Message
    -- Contoh: ℹ️ [CLIENT] 📦 TOPBAR -> Icon registered...
    return string.format("%s %s %s\n   └── %s%s", 
        levelIcon, CONTEXT, self._domainDisplay, message, meta)
end

function SmartLogger:_log(level, message, data)
    local cfg = Config.Levels[level]
    if not cfg or cfg.Weight < self._weight then return end
    
    local logMessage = self:_safeFormat(level, message, data)
    if not logMessage then return end
    
    if level == "ERROR" or level == "CRITICAL" then
        warn(logMessage)
    else
        print(logMessage)
    end
end

function SmartLogger:Debug(m, d) self:_log("DEBUG", m, d) end
function SmartLogger:Info(m, d)  self:_log("INFO", m, d) end
function SmartLogger:Warn(m, d)  self:_log("WARN", m, d) end
function SmartLogger:Error(m, d) self:_log("ERROR", m, d) end

return SmartLogger
