--[[
OVHL ENGINE V1.0.0
@Component: ClientConfig (Module)
@Path: StarterPlayer.StarterPlayerScripts.OVHL.Modules.MinimalModule.ClientConfig
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.0.0 - MINIMALMODULE CLIENT CONFIG
Version: 1.0.1
Path: StarterPlayer.StarterPlayerScripts.OVHL.Modules.MinimalModule.ClientConfig
--]]

return {
    -- UI Preferences
    UI = {
        AutoCreateUI = true,
        Theme = "Dark",
        AnimationDuration = 0.3,
    },
    
    -- Performance Settings
    Performance = {
        EnableAnimations = true,
        LowEndMode = false,
    },
    
    -- Client Overrides
    SomeSetting = "client_preference",
    LocalVolume = 0.8,
    
    -- Input Settings
    Input = {
        Keybinds = {
            ToggleUI = Enum.KeyCode.M,
            QuickAction = Enum.KeyCode.Q
        }
    }
}

--[[
@End: ClientConfig.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

