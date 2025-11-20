return {
    DefaultLevel = "INFO",
    UseEmoji = true,
    UseColor = true,
    ShowTimestamp = true,

    Domains = {
        -- Core
        SYSTEM      = "⚙️ SYSTEM",
        NETWORK     = "🌐 NETWORK", 
        SECURITY    = "🔐 SECURITY",
        DATA        = "💾 DATA",
        
        -- Features
        INVENTORY   = "🎒 INVENTORY",
        SHOP        = "🏪 SHOP", 
        ADMIN       = "👑 ADMIN",
        PERMISSION  = "🔐 PERMISSION", -- [TARGET OPERASI KITA]
        
        -- UI Stuff
        UX             = "👆 UX",       -- Button clicks
        USER_INTERFACE = "🎨 UI",       -- General UI
        TOPBAR         = "🔘 TOPBAR",   -- Topbar specific
        
        -- Fallback
        DEFAULT     = "📦 GENERAL"
    },

    Levels = {
        DEBUG    = { Weight=1, Icon="🔍" },
        INFO     = { Weight=2, Icon="ℹ️" },
        WARN     = { Weight=3, Icon="⚠️" },
        ERROR    = { Weight=4, Icon="❌" },
        CRITICAL = { Weight=5, Icon="💀" }
    }
}
