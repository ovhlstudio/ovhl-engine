--[[
OVHL FRAMEWORK V.1.0.1
@Component: NetworkSecurity (Security)
@Path: ReplicatedStorage.OVHL.Systems.Networking.NetworkSecurity
@Purpose: Security Middleware (Auto-Integrated)
--]]

local NetworkSecurity = {}
NetworkSecurity.__index = NetworkSecurity

function NetworkSecurity.new()
    local self = setmetatable({}, NetworkSecurity)
    self._logger = nil
    self._ovhl = nil
    self._routeConfigs = {}
    return self
end

-- [PHASE 4 FIX] Removed 'ovhl' param, fetch it internally to prevent nil error
function NetworkSecurity:Initialize(logger)
    self._logger = logger
    self._ovhl = require(script.Parent.Parent.Parent.Core.OVHL)
    self._logger:Info("NETWORKSECURITY", "Network Security initialized")
end

-- [PHASE 4 FIX] Auto-register to Router on Start
function NetworkSecurity:Start()
    local router = self._ovhl.GetSystem("NetworkingRouter")
    if router and router.AddMiddleware then
        router:AddMiddleware(self:CreateMiddleware())
        self._logger:Info("NETWORKSECURITY", "Security Middleware attached to Router")
    else
        self._logger:Warn("NETWORKSECURITY", "Failed to attach to NetworkingRouter")
    end
end

function NetworkSecurity:CreateMiddleware()
    return {
        name = "NetworkSecurity",
        
        onReceive = function(player, route, data)
            return self:_onReceive(player, route, data)
        end,
        
        onRequest = function(player, route, data)
            return self:_onRequest(player, route, data)
        end
    }
end

function NetworkSecurity:_onReceive(player, route, data)
    local config = self._routeConfigs[route]
    if not config then
        return true -- No security config, allow
    end
    
    -- Input Validation
    if config.validationSchema then
        local valid, error = self._ovhl.ValidateInput(config.validationSchema, data)
        if not valid then
            self._logger:Warn("NETWORKSECURITY", "Input validation failed", {
                player = player.Name,
                route = route,
                error = error
            })
            return false
        end
    end
    
    -- Rate Limiting
    if config.rateLimit then
        local allowed = self._ovhl:CheckRateLimit(player, config.rateLimit.action or route)
        if not allowed then
            self._logger:Warn("NETWORKSECURITY", "Rate limit exceeded", {
                player = player.Name,
                route = route
            })
            return false
        end
    end
    
    -- Permission Check
    if config.permission then
        local hasPermission, error = self._ovhl:CheckPermission(player, config.permission)
        if not hasPermission then
            self._logger:Warn("NETWORKSECURITY", "Permission denied", {
                player = player.Name,
                route = route,
                permission = config.permission
            })
            return false
        end
    end
    
    return true
end

function NetworkSecurity:_onRequest(player, route, data)
    return self:_onReceive(player, route, data)
end

function NetworkSecurity:ConfigureRoute(route, config)
    self._routeConfigs[route] = config
    return true
end

return NetworkSecurity
