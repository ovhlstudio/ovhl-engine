--[[
    OVHL ENGINE V1.2.0
    @Component: SharedConfig
    @Path: src/ReplicatedStorage/OVHL/Shared/Modules/PrototypeShop/SharedConfig.lua
    @Purpose: Complex Config with Schemas & Fallbacks
    @Created: Wed, Nov 19, 2025 09:10:48
--]]

return {
    Identity = { Name = "PrototypeShop", Version = "2.1.0" },

    -- UI CONFIGURATION
    UI = {
        Mode = "AUTO", -- Controller akan coba Native dulu, baru Fallback
        TargetName = "ShopNativeScreen", -- Target untuk Scanner
        
        -- Component Mapping (Config Driven No Hardcode)
        Components = {
            MainFrame = "MainFrame",
            Title     = "HeaderTitle",
            BuyButton = "Btn_BuySword",
            CloseButton = "Btn_Close"
        }
    },

    -- TOPBAR CONFIGURATION
    Topbar = {
        Enabled = true,
        Type = "Toggle", -- Simple toggle for now
        Text = "SHOP COMPLEX",
        Icon = "rbxassetid://6031225837",
        Order = 5,
        Permission = 0 -- Accessible to everyone
    },

    -- SECURITY CONFIGURATION
    Security = {
        -- Validation Schemas (InputValidator)
        Schemas = {
            BuyItem = { 
                type = "table", 
                fields = { 
                    itemId = { type = "string" },
                    amount = { type = "number", min = 1, max = 99 }
                } 
            }
        },
        -- Rate Limiting
        RateLimits = { 
            BuyItem = { max = 3, window = 10 } -- Anti Spam
        }
    },

    -- SERVER PERMISSIONS
    Permissions = {
        BuyItem = 0, -- Guest can buy
        Restock = 3  -- Only Admin can restock (Future Proof)
    }
}
