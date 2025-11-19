local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local PrototypeShopService = Knit.CreateService {
	Name = "PrototypeShopService",
	Client = {}
}

function PrototypeShopService:KnitInit()
	self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
	self.Logger = self.OVHL.GetSystem("SmartLogger")
	self.Config = self.OVHL.GetConfig("PrototypeShop", nil, "Server")
	
	self.InputValidator = self.OVHL.GetSystem("InputValidator")
	self.RateLimiter = self.OVHL.GetSystem("RateLimiter")
	self.PermissionCore = self.OVHL.GetSystem("PermissionCore")
	
	-- Register Security Schemas
	self:_registerSecurity()
end

function PrototypeShopService:KnitStart() end

function PrototypeShopService:_registerSecurity()
	local sec = self.Config.Security
	if sec and sec.ValidationSchemas then
		for k,v in pairs(sec.ValidationSchemas) do self.InputValidator:AddSchema(k,v) end
	end
	if sec and sec.RateLimits then
		for k,v in pairs(sec.RateLimits) do self.RateLimiter:SetLimit(k, v.max, v.window) end
	end
end

-- Fungsi Utama dengan Step-by-Step Logging
function PrototypeShopService:ProcessBuy(player, data)
	self.Logger:Info("SHOP", "📥 [SERVER] Request Received", {player=player.Name, data=data})

	-- STEP 1: INPUT VALIDATION
	self.Logger:Debug("SHOP", "🔍 [1/4] Validating Input...")
	local valid, err = self.InputValidator:Validate("BuyItem", data)
	if not valid then
		self.Logger:Warn("SHOP", "❌ Input Validation Failed", {error=err})
		return false, "Invalid Input: " .. tostring(err)
	end

	-- STEP 2: RATE LIMITING
	self.Logger:Debug("SHOP", "⏱️ [2/4] Checking Rate Limit...")
	if not self.RateLimiter:Check(player, "BuyItem") then
		self.Logger:Warn("SHOP", "❌ Rate Limit Exceeded", {player=player.Name})
		return false, "Spam Detected! Please wait."
	end

	-- STEP 3: PERMISSION CHECK
	self.Logger:Debug("SHOP", "🔐 [3/4] Checking Permissions...")
	local hasPerm, permErr = self.PermissionCore:Check(player, "PrototypeShop.BuyItem")
	if not hasPerm then
		self.Logger:Warn("SHOP", "❌ Permission Denied", {error=permErr})
		return false, "Access Denied: " .. tostring(permErr)
	end

	-- STEP 4: BUSINESS LOGIC
	self.Logger:Info("SHOP", "✅ [4/4] ALL CHECKS PASSED. Processing Transaction...")
	
	-- (Simulasi deduct money & give item)
	task.wait(0.5) -- Simulasi delay database

	self.Logger:Info("SHOP", "💰 [SUCCESS] Item Given to " .. player.Name)
	return true, "Transaction Complete! Enjoy your Sword."
end

function PrototypeShopService.Client:RequestBuy(player, data)
	-- Wrapper untuk Client
	return self.Server:ProcessBuy(player, data)
end

return PrototypeShopService
