--[[
OVHL ENGINE V3.0.0 - GLOBAL CONSTANTS
Version: 3.0.0
Path: ReplicatedStorage.OVHL.Shared.Modules.Global.Constants
--]]

return {
    ENGINE = {
        VERSION = "3.0.0",
        NAME = "OVHL Engine",
        AUTHOR = "Omniverse Highland Studio"
    },
    
    NETWORKING = {
        DEFAULT_TIMEOUT = 10,
        MAX_RETRIES = 3,
        RETRY_DELAY = 1
    },
    
    UI = {
        DEFAULT_THEME = "Dark",
        Z_INDEX = {
            BACKGROUND = 0,
            CONTENT = 10,
            HEADER = 20,
            OVERLAY = 50,
            TOOLTIP = 100,
            NOTIFICATION = 1000
        }
    },
    
    LOGGING = {
        DOMAINS = {
            SYSTEM = "SYSTEM",
            GAME = "GAME",
            NETWORK = "NETWORK",
            DATA = "DATA",
            UI = "UI"
        }
    }
}
