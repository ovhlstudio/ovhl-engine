return {
    -- Global Log Level
    DefaultLevel = "INFO", 

    -- Format Settings
    UseEmoji = true,
    UseColor = true,
    ShowTimestamp = true,

    -- DESCRIPTIVE DOMAINS (No abbreviations)
    Domains = {
        SYSTEM      = "⚙️ SYSTEM",
        NETWORK     = "🌐 NETWORK", 
        SECURITY    = "🔐 SECURITY",
        USER_INTERFACE = "🎨 UI",
        DATA        = "💾 DATA",
        INVENTORY   = "🎒 INVENTORY",
        SHOP        = "🏪 SHOP", 
        ADMIN       = "👑 ADMIN",
        DEBUG       = "🐛 DEBUG",
        PERFORMANCE = "⚡ PERFORMANCE",
        ERROR       = "💥 ERROR"
    },

    -- LEVEL MAPPING
    Levels = {
        DEBUG    = { Weight = 1, Color = Color3.fromRGB(150, 150, 150), Icon = "🔍" },
        INFO     = { Weight = 2, Color = Color3.fromRGB(85, 170, 255),  Icon = "ℹ️" },
        WARN     = { Weight = 3, Color = Color3.fromRGB(255, 170, 0),   Icon = "⚠️" },
        ERROR    = { Weight = 4, Color = Color3.fromRGB(255, 85, 85),   Icon = "❌" },
        CRITICAL = { Weight = 5, Color = Color3.fromRGB(255, 0, 0),     Icon = "💀" }
    }
}
