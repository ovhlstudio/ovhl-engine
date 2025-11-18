--[[
OVHL ENGINE V1.0.0
@Component: ServerConfig (Module)
@Path: ServerScriptService.OVHL.Modules.MinimalModule.ServerConfig
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.0.0 - MINIMALMODULE SERVER CONFIG  
Version: 3.0.0
Path: ServerScriptService.OVHL.Modules.MinimalModule.ServerConfig
--]]

return {
    -- Security & Permissions (Server-only)
    Permissions = {
        BasicAction = {Ranks = {0, 10, 20}, Users = {}},
        AdminAction = {Ranks = {255, 254}, Users = {123456789}},
    },
    
    -- Server Features
    DebugMode = false,
    EnableHotReload = false,
    
    -- Server Overrides
    SomeSetting = "server_override_value",
    MaxRetries = 3,
    
    -- Sensitive Data (Never replicated)
    API = {
        Endpoint = "https://api.example.com",
        APIKey = "secret_key_12345",
    },
    
    -- Performance Settings
    Performance = {
        CacheDuration = 300,
        MaxConnections = 100
    }
}

--[[
@End: ServerConfig.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

