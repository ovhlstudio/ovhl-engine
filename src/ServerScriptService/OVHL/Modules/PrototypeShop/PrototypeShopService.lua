--[[
OVHL ENGINE V1.0.0
@Component: PrototypeShopService (Module)
@Path: ServerScriptService.OVHL.Modules.PrototypeShop.PrototypeShopService
@Purpose: Validates full security pipeline (Validator -> RateLimit -> Permission)
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local PrototypeShopService = Knit.CreateService {
    Name = "PrototypeShopService",
    Client = {}
}

function PrototypeShopService:KnitInit()
    self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
    self.Logger = self.OVHL.GetSystem("SmartLogger")
    self.InputValidator = self.OVHL.GetSystem("InputValidator")
    self.RateLimiter = self.OVHL.GetSystem("RateLimiter")
    self.PermissionCore = self.OVHL.GetSystem("PermissionCore")
    
    -- LOAD CONFIG
    self.Config = self.OVHL.GetConfig("PrototypeShop", nil, "Server")
    
    -- REGISTER SECURITY (CRITICAL STEP)
    self:_registerSecurity()
    
    self.Logger:Info("SERVICE", "PrototypeShopService Initialized & Security Registered")
end

function PrototypeShopService:_registerSecurity()
    local security = self.Config.Security
    if not security then return end
    
    -- 1. Register Schemas
    if security.ValidationSchemas then
        for name, schema in pairs(security.ValidationSchemas) do
            self.InputValidator:AddSchema(name, schema)
            self.Logger:Debug("SECURITY", "Schema registered", {schema=name})
        end
    end
    
    -- 2. Register Rate Limits
    if security.RateLimits then
        for action, limit in pairs(security.RateLimits) do
            self.RateLimiter:SetLimit(action, limit.max, limit.window)
            self.Logger:Debug("SECURITY", "RateLimit registered", {action=action})
        end
    end
end

function PrototypeShopService:ProcessBuy(player, data)
    -- 1. Input Validation
    local valid, err = self.InputValidator:Validate("BuyItem", data)
    if not valid then
        self.Logger:Warn("SECURITY", "PrototypeShop: Invalid Input", {player=player.Name, error=err})
        return false, "Invalid Input: " .. tostring(err)
    end
    
    -- 2. Rate Limiting
    if not self.RateLimiter:Check(player, "BuyItem") then
        self.Logger:Warn("SECURITY", "PrototypeShop: Rate Limit Exceeded", {player=player.Name})
        return false, "Rate Limit Exceeded"
    end
    
    -- 3. Permission
    if not self.PermissionCore:Check(player, "PrototypeShop.BuyItem") then
        self.Logger:Warn("SECURITY", "PrototypeShop: Permission Denied", {player=player.Name})
        return false, "Permission Denied"
    end
    
    -- 4. Logic (Success)
    self.Logger:Info("BUSINESS", "PrototypeShop: Item Bought", {
        player = player.Name,
        item = data.itemId,
        amount = data.amount
    })
    
    return true, "Purchase Successful"
end

function PrototypeShopService.Client:RequestBuy(player, data)
    return self.Server:ProcessBuy(player, data)
end

return PrototypeShopService
--[[
@End: PrototypeShopService.lua
@Version: 1.0.1 (Fix Registration)
--]]
