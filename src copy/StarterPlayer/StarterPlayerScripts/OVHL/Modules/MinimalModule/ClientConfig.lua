--[[
OVHL ENGINE V3.0.0 - MINIMALMODULE CLIENT CONFIG
Version: 3.0.0
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
