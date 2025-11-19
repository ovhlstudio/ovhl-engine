-- [[ OVHL SHARED CONFIG V2 (VERBOSE) ]]
return {
    Debug = true,
    
    Adapters = {
        Permission = "HDAdminAdapter", 
        Navbar = "TopbarPlusAdapter"
    },

    Logging = {
        Default = "INFO", 
        Domains = {
            BOOTSTRAP   = "INFO", -- Biar keliatan start up
            CORE        = "INFO",
            NET         = "DEBUG", -- Liat traffic
            DATA        = "INFO",
            UI          = "DEBUG", -- Biar keliatan Topbar/Icon logic
            PERMISSION  = "INFO",
            SHOP        = "DEBUG"
        }
    },

    Shop = {
        Items = {
            Sword = { Price = 10, MaxStack = 1 },
            Potion = { Price = 5, MaxStack = 99 }
        },
        Limits = {
            BuyItem = { max = 3, window = 5 }
        }
    },

    Data = {
        Key = "OVHL_PlayerDatav3",
        AutoSave = 60,
        Template = { Coins = 100, Inventory = {}, Meta = {LastLogin=0} }
    }
}
