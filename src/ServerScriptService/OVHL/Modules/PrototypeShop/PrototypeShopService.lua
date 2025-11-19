--[[
    OVHL ENGINE V1.2.2
    @Component: PrototypeShopService
    @Path: ServerScriptService.OVHL.Modules.PrototypeShop.PrototypeShopService
    @Fixes: Added missing Rate Limit Registration loop
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local PrototypeShopService = Knit.CreateService { Name = "PrototypeShopService", Client = {} }

function PrototypeShopService:KnitInit()
    self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
    self.Logger = self.OVHL.GetSystem("SmartLogger")
    
    -- Load Config (Merge Shared + Server)
    self.Config = self.OVHL.GetConfig("PrototypeShop", nil, "Server")
    
    self.InputValidator = self.OVHL.GetSystem("InputValidator")
    self.RateLimiter = self.OVHL.GetSystem("RateLimiter")
    
    -- 1. Register Validation Schemas
    if self.Config.Security and self.Config.Security.Schemas then
        for name, schema in pairs(self.Config.Security.Schemas) do
            self.InputValidator:AddSchema(name, schema)
        end
    end

    -- [[ CRITICAL FIX: REGISTER RATE LIMITS ]]
    -- Tanpa ini, RateLimiter tidak tahu aturan mainnya
    if self.Config.Security and self.Config.Security.RateLimits then
        for action, limit in pairs(self.Config.Security.RateLimits) do
            self.RateLimiter:SetLimit(action, limit.max, limit.window)
            self.Logger:Debug("SHOP", "Registered Limit", {action=action, max=limit.max})
        end
    else
        self.Logger:Warn("SHOP", "No RateLimits found in Config!")
    end
end

function PrototypeShopService:KnitStart() end

function PrototypeShopService.Client:BuyItem(player, data)
    -- 1. Validate Input (Sanitasi & Schema)
    local valid, err = self.Server.InputValidator:Validate("BuyItem", data)
    if not valid then
        warn("❌ [SHOP SERVER] Invalid Input:", err)
        return false, "Invalid Input"
    end
    
    -- 2. Validate Rate Limit (CEK CONFIG SHARED)
    -- Config bilang: Max 3 request per 10 detik
    if not self.Server.RateLimiter:Check(player, "BuyItem") then
        warn("❌ [SHOP SERVER] Spam Detected from " .. player.Name)
        return false, "Spam Detected! Slow down."
    end

    -- 3. Business Logic
    print("💰 [SHOP SERVER] Transaction Success: " .. player.Name .. " bought " .. data.itemId)
    return true, "Success"
end

-- FUNCTION TEST LEAK (UTK BUKTIKAN NETWORK GUARD)
function PrototypeShopService.Client:TestSecretLeak(player)
    -- Mencoba mengirim seluruh config (termasuk ServerConfig) ke Client
    return self.Server.Config
end

return PrototypeShopService
