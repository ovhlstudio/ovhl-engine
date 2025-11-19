local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)
local MinimalController = Knit.CreateController { Name = "MinimalController" }

function MinimalController:KnitInit()
    self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
    self.UIManager = self.OVHL.GetSystem("UIManager")
    self.Config = self.OVHL.GetClientConfig("MinimalModule")
    self.Scope = Fusion.scoped(Fusion)
    self.IsVisible = self.Scope:Value(false)
end

function MinimalController:KnitStart()
    local View = require(script.Parent.Views.ClientView)
    View.Create(self.Config, { IsVisible = self.IsVisible })
    self.UIManager:RegisterTopbar("MinimalModule", self.Config.Topbar)
    
    -- [UPDATE] Gunakan state dari event
    self.UIManager.OnTopbarClick:Connect(function(id, state)
        if id == "MinimalModule" then
            -- State Synchronization: UI ngikutin Icon
            self.IsVisible:set(state)
        end
    end)
end
return MinimalController
