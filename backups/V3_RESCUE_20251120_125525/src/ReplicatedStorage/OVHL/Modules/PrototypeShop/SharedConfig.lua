return {
    Meta = {
        Name = "PrototypeShop",
        Type = "Feature",
        Version = "2.1.0", 
        Author = "OVHL Principal"
    },

    -- [FIXED] DIKEMBALIKAN AGAR TOPBAR PLUS DETECT
    Topbar = {
        Enabled = true,
        Text = "SHOP",
        Icon = "rbxassetid://4882429582", -- Shop Icon
        Order = 2
    },

    Behavior = { InteractionDistance = 10, OneTimePurchase = true },

    UI = {
        Type = "Hybrid",
        NativeTarget = "ShopNativeUI",
        Components = {
            HeaderLabel = { Name = "Txt_Header" },
            InfoLabel   = { Name = "Txt_Info" },
            BuyBtn      = { Name = "Btn_Buy" },
            CancelBtn   = { Name = "Btn_Close" } 
        },
        Defaults = {
            HeaderLabel = "LEGENDARY ARMORY",
            InfoLabel   = "Item: Fire Sword\nPrice: 1.500 Coins",
            BuyBtn      = "PURCHASE SWORD",
            CancelBtn   = "CLOSE MENU"
        }
    },

    Network = {
        Route = "PrototypeShop",
        Requests = {
            BuyItem = { Args = {"string"}, RateLimit = {Max=10, Interval=3} } -- UPDATED: Less restrictive
        }
    }
}
