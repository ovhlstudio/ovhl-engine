--[[
OVHL ENGINE V1.0.0
@Component: SecurityHelper (Security)
@Path: ReplicatedStorage.OVHL.Systems.Security.SecurityHelper
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.0.0 - SECURITY HELPER
Version: 3.0.0
Path: ReplicatedStorage.OVHL.Systems.Security.SecurityHelper

FEATURES:
- Unified security validation for services
- Standardized security patterns
- Easy integration dengan Knit services
--]]

local SecurityHelper = {}
SecurityHelper.__index = SecurityHelper

function SecurityHelper.new()
    local self = setmetatable({}, SecurityHelper)
    self._ovhl = nil
    self._logger = nil
    return self
end

function SecurityHelper:Initialize(ovhl, logger)
    self._ovhl = ovhl
    self._logger = logger
    self._logger:Info("SECURITYHELPER", "Security Helper initialized")
end

-- 🎯 STANDARD SECURITY VALIDATION PATTERN
function SecurityHelper:ValidateRequest(player, action, data, options)
    options = options or {}
    local schemaName = options.schema or "ActionData"
    local permissionNode = options.permission or "Default.Action"
    local rateLimitAction = options.rateLimit or action
    
    -- 1. Input Validation
    local valid, validationError = self._ovhl:ValidateInput(schemaName, data)
    if not valid then
        return false, "Validation failed: " .. validationError
    end
    
    -- 2. Rate Limiting
    local allowed = self._ovhl:CheckRateLimit(player, rateLimitAction)
    if not allowed then
        return false, "Rate limit exceeded"
    end
    
    -- 3. Permission Check
    local hasPermission, permissionError = self._ovhl:CheckPermission(player, permissionNode)
    if not hasPermission then
        return false, "Permission denied: " .. permissionError
    end
    
    self._logger:Debug("SECURITYHELPER", "Security validation passed", {
        player = player.Name,
        action = action,
        permission = permissionNode
    })
    
    return true, "Validation passed"
end

-- 🎯 QUICK SECURITY WRAPPER FOR KNIT SERVICE METHODS
function SecurityHelper:WrapServiceMethod(service, methodName, securityConfig)
    local originalMethod = service[methodName]
    
    if not originalMethod then
        self._logger:Error("SECURITYHELPER", "Method not found for wrapping", {
            service = service.Name,
            method = methodName
        })
        return false
    end
    
    service[methodName] = function(...)
        local args = {...}
        local player = args[1] -- First argument is typically player
        
        if not player or not player:IsA("Player") then
            return false, "Invalid player"
        end
        
        local data = args[2] or {}
        
        -- Apply security validation
        local valid, errorMsg = self:ValidateRequest(player, methodName, data, securityConfig)
        if not valid then
            return false, errorMsg
        end
        
        -- Call original method
        return originalMethod(...)
    end
    
    self._logger:Debug("SECURITYHELPER", "Service method wrapped with security", {
        service = service.Name,
        method = methodName
    })
    
    return true
end

-- 🎯 BULK SECURITY SETUP FOR SERVICE
function SecurityHelper:SetupServiceSecurity(service, securityConfigs)
    local wrappedCount = 0
    
    for methodName, config in pairs(securityConfigs) do
        local success = self:WrapServiceMethod(service, methodName, config)
        if success then
            wrappedCount = wrappedCount + 1
        end
    end
    
    self._logger:Info("SECURITYHELPER", "Service security setup completed", {
        service = service.Name,
        methods = wrappedCount,
        total = table.size(securityConfigs)
    })
    
    return wrappedCount
end

-- 🎯 SECURITY AUDIT TOOLS
function SecurityHelper:AuditPlayer(player)
    local audit = {
        Player = player.Name,
        UserId = player.UserId,
        Permissions = {},
        RateLimits = {},
        SecurityScore = 0
    }
    
    -- Get permission overview
    local PermissionCore = self._ovhl:GetSystem("PermissionCore")
    if PermissionCore then
        audit.Permissions = PermissionCore:GetPlayerPermissions(player)
    end
    
    -- Get rate limit status
    local RateLimiter = self._ovhl:GetSystem("RateLimiter")
    if RateLimiter then
        audit.RateLimits = RateLimiter:GetPlayerStats(player)
    end
    
    -- Calculate security score (simplified)
    local score = 100
    for _, limitInfo in pairs(audit.RateLimits) do
        local usagePercent = (limitInfo.current / limitInfo.limit) * 100
        if usagePercent > 80 then
            score = score - 10
        end
    end
    
    audit.SecurityScore = math.max(0, score)
    
    return audit
end

return SecurityHelper

--[[
@End: SecurityHelper.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

