--[[
OVHL ENGINE V1.0.0
@Component: LoggerConfig (Module)
@Path: ReplicatedStorage.OVHL.Config.LoggerConfig
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.0.0 - LOGGER CONFIGURATION
Version: 1.0.1
Path: ReplicatedStorage.OVHL.Config.LoggerConfig
--]]

return {
    -- MAIN MODEL SETTING
    Model = "DEBUG", -- SILENT, NORMAL, DEBUG, VERBOSE

    -- MODEL-SPECIFIC SETTINGS
    Models = {
        SILENT = {
            Levels = { "CRITICAL" },
            PerformanceLogging = false,
            InternalLogging = false,
            EmojiEnabled = false,
        },
        NORMAL = {
            Levels = { "INFO", "WARN", "ERROR", "CRITICAL" },
            PerformanceLogging = false,
            InternalLogging = false,
            EmojiEnabled = true,
        },
        DEBUG = {
            Levels = { "DEBUG", "INFO", "WARN", "ERROR", "CRITICAL" },
            PerformanceLogging = false,
            InternalLogging = false,
            EmojiEnabled = true,
        },
        VERBOSE = {
            Levels = { "DEBUG", "INFO", "WARN", "ERROR", "CRITICAL" },
            PerformanceLogging = true,
            InternalLogging = true,
            EmojiEnabled = true,
            AdditionalDomains = { "PERFORMANCE", "INTERNAL", "MEMORY", "TIMING" },
        },
    },

    -- EMOJI DOMAIN SYSTEM
    Domains = {
        -- Core Sections
        SERVER = { Emoji = "🚀", Color = Color3.fromRGB(255, 100, 100) },
        CLIENT = { Emoji = "🎮", Color = Color3.fromRGB(100, 150, 255) },
        DOMAIN = { Emoji = "🏗️", Color = Color3.fromRGB(100, 200, 100) },
        DATA = { Emoji = "📊", Color = Color3.fromRGB(200, 150, 50) },

        -- Module-specific domains
        CONFIG = { Emoji = "⚙️", Color = Color3.fromRGB(150, 150, 150) },
        SERVICE = { Emoji = "🔧", Color = Color3.fromRGB(200, 120, 50) },
        CONTROLLER = { Emoji = "🎯", Color = Color3.fromRGB(50, 200, 150) },
        NETWORK = { Emoji = "🌐", Color = Color3.fromRGB(50, 150, 200) },
        UI = { Emoji = "📱", Color = Color3.fromRGB(100, 100, 200) },
        PERMISSION = { Emoji = "🔐", Color = Color3.fromRGB(200, 100, 200) },
        STATE = { Emoji = "💾", Color = Color3.fromRGB(100, 200, 200) },
        MODULE = { Emoji = "📦", Color = Color3.fromRGB(200, 200, 100) },
        PERFORMANCE = { Emoji = "⚡", Color = Color3.fromRGB(255, 200, 50) },
        DEBUG = { Emoji = "🐛", Color = Color3.fromRGB(150, 150, 150) },
    },

    -- LEVEL EMOJI MAPPING
    LevelEmojis = {
        DEBUG = "🐛",
        INFO = "ℹ️",
        WARN = "⚠️",
        ERROR = "❌",
        CRITICAL = "💥",
    },

    -- ENVIRONMENT OVERRIDES
    EnvironmentOverrides = {
        Development = "DEBUG",
        Testing = "NORMAL",
        Production = "SILENT",
    },
}

--[[
@End: LoggerConfig.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

