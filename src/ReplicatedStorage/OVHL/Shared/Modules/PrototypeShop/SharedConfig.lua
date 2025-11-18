--[[
OVHL ENGINE V1.0.0
@Component: PrototypeShop (Shared Config)
--]]
return {
    ModuleName = "PrototypeShop",
    Version = "0.1.1",
    Enabled = true,
    UI = {
        DefaultMode = "NATIVE",
        Topbar = { 
            Enabled = true, -- [FIX] Enable this
            Icon = "rbxassetid://6031225837", 
            Text = "SHOP",
            Order = 5
        }
    },
    Security = {
        ValidationSchemas = { BuyItem = { type = "table", fields = { itemId = { type = "string" }, amount = { type = "number" } } } },
        RateLimits = { BuyItem = { max = 3, window = 10 } }
    },
    Permissions = { BuyItem = { Rank = "NonAdmin" } }
}
