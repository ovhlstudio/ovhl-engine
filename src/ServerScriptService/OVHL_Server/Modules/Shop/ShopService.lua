local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.OVHL_Shared
local OVHL = require(Shared) -- Absolute
local ConfigLoader = require(Shared.Systems.ConfigLoader)
local SecurityHelper = require(Shared.Library.Security.SecurityHelper)

local ShopConfig = ConfigLoader.GetConfig("Shop")
local ShopService = OVHL.CreateService({ 
    Name = "ShopService", 
    Client = { BuyItem = OVHL.Network.CreateFunction() },
    Dependencies = {"DataService", "RateLimiter"}
})

function ShopService:OnStart()
    self.RateLimiter = OVHL.GetSystem("RateLimiter")
    self.DataService = OVHL.GetSystem("DataService")
    for a,l in pairs(ShopConfig.Limits or {}) do if self.RateLimiter then self.RateLimiter:SetLimit(a, l.max, l.window) end end
    OVHL.Logger:Info("SHOP", "Service Ready")
end

function ShopService.Client:BuyItem(player, data)
    local s, e = SecurityHelper.ValidateRequest(player, self.Server.OVHL, data, {RateLimit="BuyItem", Schema={type="table",fields={ItemId={type="string"},Amount={type="number"}}}})
    if not s then return false, e end
    local item = ShopConfig.Items[data.ItemId]
    if not item then return false, "Unknown Item" end
    local profile = self.Server.DataService:Get(player)
    if not profile then return false, "Data Error" end
    if profile.Coins >= item.Price * data.Amount then
        profile.Coins -= item.Price * data.Amount
        OVHL.Logger:Info("SHOP", "Purchased: "..data.ItemId)
        return true, "Purchased!"
    end
    return false, "Not enough coins"
end
return ShopService
