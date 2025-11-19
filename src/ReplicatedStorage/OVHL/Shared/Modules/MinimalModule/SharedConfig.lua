--[[
    OVHL ENGINE V1.2.0
    @Component: SharedConfig
    @Path: src/ReplicatedStorage/OVHL/Shared/Modules/MinimalModule/SharedConfig.lua
    @Purpose: Configuration Data for MinimalModule
    @Created: Wed, Nov 19, 2025 09:10:48
--]]

return {
    Identity = { Name = "MinimalModule", Version = "2.0.0" },
    
    -- UI Configuration
    UI = {
        Mode = "FUSION", -- Force Fusion Mode
    },
    
    -- Topbar Configuration
    Topbar = {
        Enabled = true,
        Type = "Toggle",
        Text = "HELLO SOP",
        Icon = "rbxassetid://112605442047022",
        Order = 1,
        Permission = 0 -- Guest Access
    },
    
    -- Security Configuration (Minimal)
    Security = {
        Schemas = {},
        RateLimit = { Action = { Max = 5, Window = 10 } }
    }
}
