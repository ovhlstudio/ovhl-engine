--[[
OVHL ENGINE V3.0.0
@Component: MinimalController
@Path: StarterPlayer.StarterPlayerScripts.OVHL.Modules.MinimalModule.MinimalController
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local MinimalController = Knit.CreateController { Name = "MinimalController" }

function MinimalController:KnitInit()
    self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
    self.Logger = self.OVHL.GetSystem("SmartLogger")
    self.Config = self.OVHL.GetClientConfig("MinimalModule")
    self.UIEngine = self.OVHL.GetSystem("UIEngine")
    self.UIManager = self.OVHL.GetSystem("UIManager")
    self.AssetLoader = self.OVHL.GetSystem("AssetLoader")
    self.Service = Knit.GetService("MinimalService")
end

function MinimalController:KnitStart()
    self:SetupUI()
    self:SetupInput()
    self:SetupTopbar()
end

function MinimalController:SetupUI()
    -- Explicit Name: MinimalMain
    local success, mainScreen = pcall(function() return self.UIEngine:CreateScreen("MinimalMain", self.Config) end)
    if success and mainScreen then
        self.UIManager:RegisterScreen("MinimalMain", mainScreen)
        self:_setupUIComponents(mainScreen)
    end
end

function MinimalController:_setupUIComponents(screen)
    local actionBtn = self.UIManager:FindComponent("MinimalMain", "ActionButton")
    if actionBtn then
        self.UIManager:BindEvent(actionBtn, "Activated", function()
            self:DoClientAction({ action = "test", data = { type = "click" } })
        end)
    end
end

function MinimalController:SetupInput()
    if self.Config.Input and self.Config.Input.Keybinds and self.Config.Input.Keybinds.ToggleUI then
        self.AssetLoader:RegisterKeybind(self.Config.Input.Keybinds.ToggleUI, function() self:ToggleMainUI() end, {triggerOnPress=true})
    end
end

function MinimalController:SetupTopbar()
    -- PASS EXPLICIT ONCLICK FUNCTION TO AVOID AMBIGUITY
    self.UIManager:SetupTopbar("MinimalModule", self.Config, function()
        self:ToggleMainUI()
    end)
end

function MinimalController:ToggleMainUI()
    self.UIManager:ToggleScreen("MinimalMain")
end

function MinimalController:DoClientAction(data)
    if self.Service then self.Service:DoAction(data) end
end

return MinimalController
