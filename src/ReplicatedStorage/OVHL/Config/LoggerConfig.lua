return {
    -- Global Log Level
    DefaultLevel = "DEBUG", 

    -- Format Setting
    UseEmoji = true,
    UseColor = true,
    ShowTimestamp = true,

    -- EMOJI DOMAINS (V1 Style)
    Domains = {
        KERNEL      = "⚡",
        SYSREG      = "🔧",
        NET         = "🌐",
        DATA        = "💾",
        PERM        = "🔐",
        UX          = "🖱️",
        SHOP        = "💰",
        NOTIF       = "🔔",
        ERROR       = "💥",
        DEFAULT     = "📝"
    },

    -- LEVEL MAPPING
    Levels = {
        DEBUG    = { Weight = 1, Color = Color3.fromRGB(150, 150, 150), Icon = "🐛" },
        INFO     = { Weight = 2, Color = Color3.fromRGB(85, 170, 255),  Icon = "ℹ️" },
        WARN     = { Weight = 3, Color = Color3.fromRGB(255, 170, 0),   Icon = "⚠️" },
        ERROR    = { Weight = 4, Color = Color3.fromRGB(255, 85, 85),   Icon = "❌" },
        CRITICAL = { Weight = 5, Color = Color3.fromRGB(255, 0, 0),     Icon = "☠️" }
    }
}
