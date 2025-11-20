--[[ @Component: LoggerFactory (Enterprise Dependency Injection) ]]
local SmartLogger = require(script.Parent.SmartLogger)

local LoggerFactory = {}
LoggerFactory._cache = {}

function LoggerFactory.Create(domain, overrides)
    local key = domain .. (overrides and overrides.LogLevel or "")
    
    if not LoggerFactory._cache[key] then
        LoggerFactory._cache[key] = SmartLogger.New(domain, overrides)
    end
    
    return LoggerFactory._cache[key]
end

-- Pre-defined domains for consistency
function LoggerFactory.System() return LoggerFactory.Create("SYSTEM") end
function LoggerFactory.Admin() return LoggerFactory.Create("ADMIN") end
function LoggerFactory.Inventory() return LoggerFactory.Create("INVENTORY") end
function LoggerFactory.Shop() return LoggerFactory.Create("SHOP") end
function LoggerFactory.UI() return LoggerFactory.Create("USER_INTERFACE") end
function LoggerFactory.Network() return LoggerFactory.Create("NETWORK") end
function LoggerFactory.Security() return LoggerFactory.Create("SECURITY") end
function LoggerFactory.Data() return LoggerFactory.Create("DATA") end

return LoggerFactory
