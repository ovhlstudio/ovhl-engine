--[[
OVHL ENGINE V3.0.0 - MINIMAL CONTROLLER (FINAL COMPLIANT)
Version: 3.0.5
Path: StarterPlayer.StarterPlayerScripts.OVHL.Modules.MinimalModule.MinimalController
FIXES: Sending Table data to pass strict InputValidation
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local MinimalController = Knit.CreateController { Name = "MinimalController" }

function MinimalController:KnitInit()
    self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
    self.Logger = self.OVHL:GetSystem("SmartLogger")
    self.Config = self.OVHL:GetClientConfig("MinimalModule")
    
    self.UIEngine = self.OVHL:GetSystem("UIEngine")
    self.UIManager = self.OVHL:GetSystem("UIManager")
    self.AssetLoader = self.OVHL:GetSystem("AssetLoader")
    self.Service = Knit.GetService("MinimalService")
end

function MinimalController:KnitStart()
    self:SetupUI()
    self:SetupInput()
    self:SetupTopbar()
end

function MinimalController:SetupUI()
    if not self.UIEngine or not self.Config then return end
    
    local success, mainScreen = pcall(function()
        return self.UIEngine:CreateScreen("MainUI", self.Config)
    end)
    
    if success and mainScreen then
        self._mainScreen = mainScreen
        if self.UIManager then
            self.UIManager:RegisterScreen("MainUI", mainScreen)
            self:_setupUIComponents(mainScreen)
        end
        if self.Logger then self.Logger:Info("UI", "MainUI created") end
    else
        if self.Logger then self.Logger:Error("UI", "Failed to create MainUI", {error = tostring(mainScreen)}) end
    end
end

function MinimalController:_setupUIComponents(screen)
    if not screen or not self.UIManager then return end
    
    -- Bind Action Button
    local actionBtn = self.UIManager:FindComponent("MainUI", "ActionButton")
    if actionBtn then
        self.UIManager:BindEvent(actionBtn, "Activated", function()
            -- FIX: Sending a TABLE payload to satisfy strict validation
            self:DoClientAction({
                action = "test", 
                data = { type = "click", source = "ui_button" } 
            })
        end)
    end
end

function MinimalController:SetupInput()
    if not self.AssetLoader or not self.Config then return end
    if self.Config.Input and self.Config.Input.Keybinds then
        local kb = self.Config.Input.Keybinds
        if kb.ToggleUI then
            self.AssetLoader:RegisterKeybind(kb.ToggleUI, function() self:ToggleMainUI() end, {triggerOnPress=true})
        end
        if kb.QuickAction then
            self.AssetLoader:RegisterKeybind(kb.QuickAction, function() self:QuickAction() end, {triggerOnPress=true})
        end
    end
end

function MinimalController:SetupTopbar()
    if self.UIManager then
        self.UIManager:SetupTopbar("MinimalModule", self.Config)
    end
end

function MinimalController:ToggleMainUI()
    if self.UIManager then self.UIManager:ToggleScreen("MainUI") end
end

function MinimalController:DoClientAction(data)
    if not self.Service then return end
    
    -- Promise handling
    self.Service:DoAction(data):andThen(function(result)
        if self.Logger then self.Logger:Info("ACTION", "Success", {result=result}) end
    end):catch(function(err)
        if self.Logger then self.Logger:Warn("ACTION", "Failed", {error=tostring(err)}) end
    end)
end

function MinimalController:QuickAction()
    -- FIX: Sending TABLE here too
    self:DoClientAction({
        action = "test",
        target = "quick_action",
        amount = 1,
        data = { type = "hotkey", source = "keyboard" }
    })
end

function MinimalController:FetchModuleData()
    if not self.Service then return end
    
    self.Service:GetData():andThen(function(response)
        if response.success then
            if self.Logger then 
                self.Logger:Info("DATA", "Module Data Received", {
                    version = response.data.version
                }) 
            end
        end
    end):catch(function(err)
        if self.Logger then self.Logger:Error("DATA", "Fetch Failed", {error=tostring(err)}) end
    end)
end

return MinimalController
