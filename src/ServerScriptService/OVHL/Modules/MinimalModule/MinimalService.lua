--[[
OVHL ENGINE V1.0.0
@Component: MinimalService (Module)
@Path: ServerScriptService.OVHL.Modules.MinimalModule.MinimalService
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.0.0 - MINIMALMODULE SERVER SERVICE (CLEAN)
Version: 1.0.1
Path: ServerScriptService.OVHL.Modules.MinimalModule.MinimalService
FIXES: Removed SystemRegistry call (Knit handles it)
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local MinimalService = Knit.CreateService {
    Name = "MinimalService",
    Client = {}
}

function MinimalService:KnitInit()
    self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
    self.Logger = self.OVHL.GetSystem("SmartLogger")
    self.Config = self.OVHL.GetConfig("MinimalModule", nil, "Server")
    
    self.InputValidator = self.OVHL.GetSystem("InputValidator")
    self.RateLimiter = self.OVHL.GetSystem("RateLimiter") 
    self.PermissionCore = self.OVHL.GetSystem("PermissionCore")
    
    -- FIX: Removed SystemRegistry registration to prevent double logging
    
    self.Logger:Info("SERVICE", "MinimalService initialized", {
        module = self.Config.ModuleName,
        security = (self.InputValidator ~= nil)
    })
end

function MinimalService:KnitStart()
    self.Logger:Info("SERVICE", "MinimalService started")
end

function MinimalService:ProcessAction(player, actionData)
    local startTime = os.clock()
    
    -- 1. Input Validation
    local valid, validationError = self.InputValidator:Validate("ActionData", actionData)
    if not valid then
        self.Logger:Warn("SECURITY", "Input validation failed", {player=player.Name, error=validationError})
        return false, validationError
    end
    
    -- 2. Rate Limiting
    if not self.RateLimiter:Check(player, "DoAction") then
        return false, "Rate limit exceeded"
    end
    
    -- 3. Permission Check (HD Admin Style)
    local permissionNode = "MinimalModule." .. actionData.action
    local hasPermission, permissionError = self.PermissionCore:Check(player, permissionNode)
    if not hasPermission then
        self.Logger:Warn("SECURITY", "Permission denied", {
            player = player.Name,
            permission = permissionNode,
            error = permissionError
        })
        return false, permissionError
    end
    
    -- 4. Business Logic
    local success, result = self:_executeBusinessLogic(player, actionData)
    
    self.Logger:Performance("TIMING", "Action processed", {
        action = actionData.action,
        duration = os.clock() - startTime,
        success = success
    })
    
    return success, result
end

function MinimalService:_executeBusinessLogic(player, actionData)
    if actionData.action == "test" then
        self.Logger:Debug("BUSINESS", "Test action executed", {player=player.Name})
        return true, "Test completed successfully"
    elseif actionData.action == "admin" then
        -- Admin specific logic logic
        return true, "Admin action completed"
    else
        return false, "Unknown action"
    end
end

function MinimalService:CheckPermission(player, action)
    -- Legacy wrapper using PermissionCore
    if self.PermissionCore then
        return self.PermissionCore:Check(player, "MinimalModule." .. action)
    end
    return false
end

function MinimalService.Client:DoAction(player, actionData)
    return self.Server:ProcessAction(player, actionData)
end

function MinimalService.Client:GetData(player)
    if not self.Server.RateLimiter:Check(player, "GetData") then return {success=false} end
    local clientConfig = self.Server.OVHL.GetClientConfig("MinimalModule")
    return {success=true, data={version=clientConfig.Version}}
end

return MinimalService

--[[
@End: MinimalService.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

