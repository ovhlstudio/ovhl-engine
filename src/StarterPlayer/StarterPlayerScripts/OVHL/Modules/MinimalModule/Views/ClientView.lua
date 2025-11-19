--[[
    OVHL ENGINE V1.2.0
    @Component: ClientView
    @Path: src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/MinimalModule/Views/ClientView.lua
    @Purpose: Fusion UI Constructor
    @Created: Wed, Nov 19, 2025 09:10:48
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local New, Children, OnEvent = Fusion.New, Fusion.Children, Fusion.OnEvent

local ClientView = {}

function ClientView.Create(config, props)
    local scope = Fusion.scoped(Fusion)
    
    local screen = scope:New "ScreenGui" {
        Name = "MinimalFusionScreen",
        Parent = game.Players.LocalPlayer.PlayerGui,
        Enabled = props.IsVisible,
        
        [Children] = {
            scope:New "Frame" {
                Size = UDim2.fromOffset(250, 150),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                
                [Children] = {
                    scope:New "UICorner" { CornerRadius = UDim.new(0, 8) },
                    
                    scope:New "TextLabel" {
                        Text = "👋 " .. (config.Topbar.Text or "HELLO"),
                        Size = UDim2.new(1, 0, 0.5, 0),
                        BackgroundTransparency = 1,
                        TextColor3 = Color3.new(1,1,1),
                        Font = Enum.Font.GothamBold
                    },
                    
                    scope:New "TextButton" {
                        Text = "CLOSE",
                        Size = UDim2.new(0.8, 0, 0.3, 0),
                        Position = UDim2.fromScale(0.1, 0.6),
                        BackgroundColor3 = Color3.fromRGB(200, 60, 60),
                        TextColor3 = Color3.new(1,1,1),
                        
                        [OnEvent "Activated"] = function()
                            props.IsVisible:set(false)
                        end,
                        
                        [Children] = { scope:New "UICorner" { CornerRadius = UDim.new(0, 4) } }
                    }
                }
            }
        }
    }
    
    return screen, scope
end

return ClientView
