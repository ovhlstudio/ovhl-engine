-- [[ OVHL LOGGER (ABSOLUTE STANDARD) ]]
local Logger = {}
local Config = nil
local LEVELS = { DEBUG = 0, INFO = 1, WARN = 2, ERROR = 3, CRITICAL = 4 }
local EMOJIS = { DEBUG = "🐛", INFO = "ℹ️", WARN = "⚠️", ERROR = "❌", CRITICAL = "💥" }

local DOMAINS = {
    SERVER="🚀", CLIENT="🎮", CORE="🏗️", DATA="📊", UI="📱", PERMISSION="🔐",
    NETWORK="🌐", SECURITY="🛡️", SHOP="💰", NOTIFICATION="🔔", BOOTSTRAP="🏁", LOADER="📦"
}
local ALIASES = {
    PERM="PERMISSION", NET="NETWORK", SEC="SECURITY", NOTIF="NOTIFICATION", NAV="UI", INIT="BOOTSTRAP"
}

function Logger:LoadConfig()
    if Config then return end
    pcall(function()
        -- ABSOLUTE PATH
        Config = require(game:GetService("ReplicatedStorage").OVHL_Shared.Library.SharedConfig).Logging
    end)
    Config = Config or { Default = "INFO", Domains = {} }
end

function Logger:Format(level, domain, message, metadata)
    local cleanDomain = ALIASES[domain] or domain
    local levelIcon = EMOJIS[level] or "📝"
    local domainIcon = DOMAINS[cleanDomain] or "⚙️"
    
    local metaStr = ""
    if metadata and type(metadata) == "table" then
        local parts = {}
        for k,v in pairs(metadata) do table.insert(parts, string.format("%s=%s", k, tostring(v))) end
        if #parts > 0 then metaStr = " {" .. table.concat(parts, " ") .. "}" end
    end
    
    return string.format("%s [%s %s] %s%s", levelIcon, domainIcon, cleanDomain, tostring(message), metaStr)
end

function Logger:Log(levelStr, levelNum, domain, message, metadata)
    self:LoadConfig()
    local cleanDomain = ALIASES[domain] or domain
    local targetLevelStr = Config.Domains[cleanDomain] or Config.Default or "INFO"
    local targetLevelNum = LEVELS[targetLevelStr] or LEVELS.INFO
    
    if levelNum >= targetLevelNum then
        local msg = self:Format(levelStr, cleanDomain, message, metadata)
        if levelNum >= LEVELS.WARN then warn(msg) else print(msg) end
    end
end

function Logger:Debug(d, m, meta) self:Log("DEBUG", LEVELS.DEBUG, d, m, meta) end
function Logger:Info(d, m, meta)  self:Log("INFO", LEVELS.INFO, d, m, meta) end
function Logger:Warn(d, m, meta)  self:Log("WARN", LEVELS.WARN, d, m, meta) end
function Logger:Error(d, m, meta) self:Log("ERROR", LEVELS.ERROR, d, m, meta) end
function Logger:Critical(d, m, meta) self:Log("CRITICAL", LEVELS.CRITICAL, d, m, meta) end

return Logger
