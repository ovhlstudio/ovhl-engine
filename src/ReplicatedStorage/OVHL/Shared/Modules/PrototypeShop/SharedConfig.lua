--[[
OVHL ENGINE V1.0.0
@Component: PrototypeShop (Shared Config)
@Path: ReplicatedStorage.OVHL.Shared.Modules.PrototypeShop.SharedConfig
@Purpose: Configuration for testing security pipeline
@Stability: EXPERIMENTAL
--]]

return {
    ModuleName = "PrototypeShop",
    Version = "0.1.0",
    
    UI = {
        DefaultMode = "NATIVE", -- Simple native UI for testing
        Topbar = { Enabled = false }
    },
    
    Security = {
        ValidationSchemas = {
            BuyItem = {
                type = "table",
                fields = {
                    itemId = { type = "string", min = 3, max = 20 },
                    amount = { type = "number", min = 1, max = 99 }
                }
            }
        },
        RateLimits = {
            BuyItem = { max = 3, window = 10 } -- Strict limit for testing
        }
    },
    
    Permissions = {
        BuyItem = { Rank = "NonAdmin", Description = "Allow buying items" },
        AdminRestock = { Rank = "Admin", Description = "Admin only restock" }
    }
}
--[[
@End: SharedConfig.lua
@Version: 1.0.0
--]]
