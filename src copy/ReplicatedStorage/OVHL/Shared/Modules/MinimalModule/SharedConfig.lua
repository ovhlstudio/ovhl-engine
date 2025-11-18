--[[
OVHL ENGINE V3.0.0 - MINIMALMODULE CONFIG (HD ADMIN STYLE)
Version: 3.1.0
Path: ReplicatedStorage.OVHL.Shared.Modules.MinimalModule.SharedConfig
--]]

return {
    ModuleName = "MinimalModule",
    Version = "3.0.0",
    Author = "OVHL Team",
    Enabled = true,
    
    UI = {
        DefaultMode = "AUTO",
        Screens = {
            MainUI = { Mode = "FUSION", NativePath = "MainUI", FallbackMode = "NATIVE" },
            Settings = { Mode = "FUSION", FallbackMode = "NATIVE" }
        },
        Topbar = { Enabled = true, Icon = "rbxassetid://1234567890", Text = "Minimal Module" }
    },
    
    -- HD ADMIN STYLE PERMISSIONS
    Permissions = {
        BasicAction = { Rank = "NonAdmin", Description = "Basic stuff" },
        AdminAction = { Rank = "Admin", Description = "Admin stuff" },
        
        -- TEST ACTION (Permission Rule Added)
        test = { 
            Rank = "NonAdmin", -- 0 (Everyone)
            Description = "Test button action" 
        }
    },
    
    Security = {
        RateLimits = {
            DoAction = { max = 10, window = 60 },
            GetData = { max = 5, window = 30 }
        },
        ValidationSchemas = {
            ActionData = {
                type = "table",
                fields = {
                    action = { type = "string" },
                    data = { type = "table", optional = true },
                    target = { type = "string", optional = true },
                    amount = { type = "number", optional = true }
                }
            }
        }
    }
}
