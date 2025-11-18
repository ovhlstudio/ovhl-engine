--[[
OVHL ENGINE V1.0.0
@Component: Constants (Module)
@Path: ReplicatedStorage.OVHL.Shared.Modules.Global.Constants
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

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

--[[
@End: Constants.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

