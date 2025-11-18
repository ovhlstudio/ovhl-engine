--[[
OVHL ENGINE V1.0.0
@Component: StudioFormatter (Foundation)
@Path: ReplicatedStorage.OVHL.Systems.Foundation.StudioFormatter
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.0.0 - STUDIO OUTPUT FORMATTER
Version: 3.0.0
Path: ReplicatedStorage.OVHL.Systems.Foundation.StudioFormatter
--]]

local StudioFormatter = {}
StudioFormatter.__index = StudioFormatter

function StudioFormatter.new()
    local self = setmetatable({}, StudioFormatter)
    return self
end

function StudioFormatter:FormatMessage(level, domain, message, metadata)
    local loggerConfig = self:GetLoggerConfig()
    local levelEmoji = loggerConfig.LevelEmojis[level] or "📝"
    local domainConfig = loggerConfig.Domains[domain] or {Emoji = "📄", Color = Color3.fromRGB(200, 200, 200)}
    
    -- Format: [EMOJI] [DOMAIN] - Message {metadata}
    local formattedMessage = string.format(
        "%s %s - %s",
        levelEmoji,
        domain,
        tostring(message)
    )
    
    -- Add metadata if present
    if metadata and next(metadata) then
        local metadataStr = ""
        for k, v in pairs(metadata) do
            metadataStr = metadataStr .. string.format(" %s=%s", k, tostring(v))
        end
        formattedMessage = formattedMessage .. " {" .. metadataStr:sub(2) .. "}"
    end
    
    return formattedMessage, domainConfig.Color
end

function StudioFormatter:GetLoggerConfig()
    -- Load logger config dengan safe require
    local success, config = pcall(function()
        return require(script.Parent.Parent.Parent.Config.LoggerConfig)
    end)
    
    if success then
        return config
    else
        -- Fallback config
        return {
            LevelEmojis = {
                DEBUG = "🐛", INFO = "ℹ️", WARN = "⚠️", ERROR = "❌", CRITICAL = "💥"
            },
            Domains = {
                SERVER = { Emoji = "🚀", Color = Color3.fromRGB(255, 100, 100) },
                CLIENT = { Emoji = "🎮", Color = Color3.fromRGB(100, 150, 255) },
                DOMAIN = { Emoji = "🏗️", Color = Color3.fromRGB(100, 200, 100) },
                DATA = { Emoji = "📊", Color = Color3.fromRGB(200, 150, 50) }
            }
        }
    end
end

return StudioFormatter

--[[
@End: StudioFormatter.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

