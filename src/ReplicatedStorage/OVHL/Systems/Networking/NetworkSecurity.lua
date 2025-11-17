--[[
OVHL ENGINE V3.0.0 - NETWORK SECURITY MIDDLEWARE
Version: 3.0.0
Path: ReplicatedStorage.OVHL.Systems.Networking.NetworkSecurity

FEATURES:
- Security middleware untuk NetworkingRouter
- Automatic input validation
- Rate limiting integration
- Permission checking
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

function NetworkSecurity:Initialize(logger, ovhl)
    self._logger = logger
    self._ovhl = ovhl
    self._logger:Info("NETWORKSECURITY", "Network Security initialized")
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
        local valid, error = self._ovhl:ValidateInput(config.validationSchema, data)
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
    -- Same security checks for requests
    return self:_onReceive(player, route, data)
end

function NetworkSecurity:ConfigureRoute(route, config)
    self._routeConfigs[route] = config
    
    self._logger:Debug("NETWORKSECURITY", "Route security configured", {
        route = route,
        hasValidation = config.validationSchema ~= nil,
        hasRateLimit = config.rateLimit ~= nil,
        hasPermission = config.permission ~= nil
    })
    
    return true
end

function NetworkSecurity:ConfigureModuleRoutes(moduleName, routeConfigs)
    local configuredCount = 0
    
    for route, config in pairs(routeConfigs) do
        local fullRoute = moduleName .. "." .. route
        if self:ConfigureRoute(fullRoute, config) then
            configuredCount = configuredCount + 1
        end
    end
    
    self._logger:Info("NETWORKSECURITY", "Module routes security configured", {
        module = moduleName,
        routes = configuredCount
    })
    
    return configuredCount
end

function NetworkSecurity:GetRouteConfig(route)
    return self._routeConfigs[route]
end

function NetworkSecurity:GetAllConfigs()
    return self._routeConfigs
end

function NetworkSecurity:CleanupModule(moduleName)
    local removedCount = 0
    
    for route, _ in pairs(self._routeConfigs) do
        if string.find(route, "^" .. moduleName .. "%.") then
            self._routeConfigs[route] = nil
            removedCount = removedCount + 1
        end
    end
    
    self._logger:Info("NETWORKSECURITY", "Module security configs cleaned up", {
        module = moduleName,
        removed = removedCount
    })
    
    return removedCount
end

return NetworkSecurity
