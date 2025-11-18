--[[
OVHL ENGINE V1.0.0
@Component: UIEngine (UI)
@Path: ReplicatedStorage.OVHL.Systems.UI.UIEngine
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.0.0 - UI ENGINE (FINAL)
Version: 1.0.1
Path: ReplicatedStorage.OVHL.Systems.UI.UIEngine
FIXES: Fusion 0.3 Event Binding & Scope Management
--]]

local UIEngine = {}
UIEngine.__index = UIEngine

function UIEngine.new()
    local self = setmetatable({}, UIEngine)
    self._logger = nil
    self._activeScreens = {}
    self._availableFrameworks = { FUSION = false, NATIVE = true }
    
    pcall(function()
        local Fusion = require(game:GetService("ReplicatedStorage").Packages.Fusion)
        if Fusion and Fusion.scoped then
            self._availableFrameworks.FUSION = true
        end
    end)
    return self
end

function UIEngine:Initialize(logger)
    self._logger = logger
end

function UIEngine:CreateScreen(screenName, moduleConfig)
    local screenConfig = moduleConfig.UI.Screens[screenName]
    if not screenConfig then return nil end
    
    if screenConfig.Mode == "FUSION" and self._availableFrameworks.FUSION then
        return self:_createFusionScreen(screenName)
    else
        return self:_createNativeScreen(screenName)
    end
end

function UIEngine:_createFusionScreen(screenName)
    local Fusion = require(game:GetService("ReplicatedStorage").Packages.Fusion)
    local scope = Fusion.scoped(Fusion)
    local OnEvent = Fusion.OnEvent
    
    local screenGui = scope:New "ScreenGui" {
        Name = screenName,
        Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"),
        Enabled = false,
        
        [Fusion.Children] = {
            scope:New "Frame" {
                Name = "MainFrame",
                BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                Size = UDim2.new(0, 300, 0, 200),
                Position = UDim2.new(0.5, -150, 0.5, -100),
                
                [Fusion.Children] = {
                    scope:New "TextLabel" {
                        Name = "Title",
                        Text = "Fusion UI: " .. screenName,
                        TextColor3 = Color3.new(1, 1, 1),
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 40),
                        TextScaled = true
                    },
                    scope:New "TextButton" {
                        Name = "CloseButton",
                        Text = "Close",
                        Size = UDim2.new(0.8, 0, 0, 40),
                        Position = UDim2.new(0.1, 0, 0.7, 0),
                        
                        -- FIX: Using OnEvent properly with closure capture
                        [OnEvent "Activated"] = function()
                            print("🔘 Close Button Clicked via Fusion Event")
                            self:HideScreen(screenName)
                        end
                    },
                    scope:New "TextButton" {
                        Name = "ActionButton",
                        Text = "Test Action",
                        Size = UDim2.new(0.8, 0, 0, 40),
                        Position = UDim2.new(0.1, 0, 0.4, 0)
                    }
                }
            }
        }
    }
    
    -- Attach scope to instance for cleanup
    self._activeScreens[screenName] = {
        Instance = screenGui,
        Scope = scope
    }
    
    return screenGui
end

function UIEngine:_createNativeScreen(screenName)
    local sg = Instance.new("ScreenGui")
    sg.Name = screenName
    sg.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    return sg
end

function UIEngine:ShowScreen(screenName)
    local screenData = self._activeScreens[screenName]
    if screenData and screenData.Instance then
        screenData.Instance.Enabled = true
        return true
    end
    -- Try finding by name if not in active list (Native fallback)
    local pGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        local s = pGui:FindFirstChild(screenName)
        if s then s.Enabled = true return true end
    end
    return false
end

function UIEngine:HideScreen(screenName)
    local screenData = self._activeScreens[screenName]
    if screenData and screenData.Instance then
        screenData.Instance.Enabled = false
        return true
    end
    -- Try finding by name
    local pGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        local s = pGui:FindFirstChild(screenName)
        if s then s.Enabled = false return true end
    end
    return false
end

function UIEngine:GetScreen(screenName)
    return self._activeScreens[screenName]
end

function UIEngine:GetAvailableFrameworks()
    return self._availableFrameworks
end

return UIEngine

--[[
@End: UIEngine.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

