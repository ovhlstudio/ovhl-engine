-- [[ SHOP CONTROLLER (WITH INTERACTION LOGS) ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedPath = ReplicatedStorage.OVHL_Shared
local OVHL = require(SharedPath)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local ShopView = require(script.Parent.Views.ShopView)

local ShopController = OVHL.CreateController({ 
    Name = "ShopController",
    Dependencies = {"UIManager"} 
})

OVHL.RegisterSystem("ShopController", ShopController)

local isVisible = Fusion.Value(false)

function ShopController:OnStart()
    local UIManager = OVHL.GetSystem("UIManager")
    self.Service = OVHL.GetService("ShopService")
    self.Notif = OVHL.GetSystem("NotificationController") -- Use GetSystem
    
    if UIManager then
        UIManager:RegisterApp("Shop", {Text="WEAPON SHOP"}, function(state)
            OVHL.Logger:Debug("UI", "🔘 Topbar Clicked: Shop", {newState=state})
            isVisible:set(state)
        end)
    end
    
    ShopView({
        Visible = isVisible,
        OnBuy = function() 
            OVHL.Logger:Debug("UI", "🖱️ Interaction: Buy Button Clicked")
            self:Buy() 
        end,
        OnClose = function() 
            OVHL.Logger:Debug("UI", "🖱️ Interaction: Close Button Clicked")
            isVisible:set(false) 
        end
    })
    
    OVHL.Logger:Info("SHOP", "Controller Ready")
end

function ShopController:Buy()
    task.spawn(function()
        local s, m = self.Service:BuyItem({ItemId="Sword", Amount=1})
        if self.Notif then 
            self.Notif:Add(m, s and "Success" or "Error") 
        end
    end)
end

return ShopController
