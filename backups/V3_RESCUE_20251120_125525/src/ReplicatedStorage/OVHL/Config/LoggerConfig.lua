return {
    DefaultLevel = "INFO",
    UseEmoji = true,
    UseColor = true,
    ShowTimestamp = true,

    -- COMPREHENSIVE DOMAIN MAPPING FROM SNAPSHOT
    Domains = {
        -- System & Core
        SYSTEM      = "⚙️ SYSTEM",
        KERNEL      = "⚙️ SYSTEM",
        LOGGER      = "📝 LOGGER",
        CONFIG      = "⚙️ CONFIG",
        TYPE        = "📐 TYPE",
        ENUM        = "🔢 ENUM",
        
        -- Permission & Security
        PERMISSION  = "🔐 PERMISSION",
        HDADMIN     = "🛡️ HDADMIN",
        POLICY      = "📜 POLICY",
        SECURITY    = "🔐 SECURITY",
        
        -- Data & Storage
        DATA        = "💾 DATA",
        ASSET       = "🖼️ ASSET",
        
        -- Network
        NETWORK     = "🌐 NETWORK",
        
        -- UI & Interface
        UI          = "🎨 UI",
        TOPBAR      = "🔘 TOPBAR",
        FINDER      = "🔍 FINDER",
        
        -- Business Features
        ADMIN       = "👑 ADMIN",
        INVENTORY   = "🎒 INVENTORY",
        SHOP        = "🏪 SHOP",
        NOTIFICATION = "🔔 NOTIFICATION",
        
        -- Fallback
        DEFAULT     = "📝 GENERAL"
    },

    Levels = {
        DEBUG    = { Weight = 1, Color = Color3.fromRGB(150, 150, 150), Icon = "🔍" },
        INFO     = { Weight = 2, Color = Color3.fromRGB(85, 170, 255),  Icon = "ℹ️" },
        WARN     = { Weight = 3, Color = Color3.fromRGB(255, 170, 0),   Icon = "⚠️" },
        ERROR    = { Weight = 4, Color = Color3.fromRGB(255, 85, 85),   Icon = "❌" },
        CRITICAL = { Weight = 5, Color = Color3.fromRGB(255, 0, 0),     Icon = "💀" }
    }
}
