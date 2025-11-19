--[[
    OVHL ENGINE V1.2.0
    @Component: ClientView
    @Path: src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypeShop/Views/ClientView.lua
    @Purpose: Fusion Fallback View for Shop
    @Created: Wed, Nov 19, 2025 09:10:48
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local New, Children, OnEvent = Fusion.New, Fusion.Children, Fusion.OnEvent

local ClientView = {}

-- View ini dipanggil jika Native Scanner GAGAL menemukan UI di PlayerGui
function ClientView.CreateFallback(config, props)
    print("⚠️ [SHOP VIEW] Activiting Fusion Fallback UI (Native Missing)")
    
    local scope = Fusion.scoped(Fusion)
    
    local screen = scope:New "ScreenGui" {
        Name = "ShopFallbackScreen",
        Parent = game.Players.LocalPlayer.PlayerGui,
        Enabled = props.IsVisible,
        
        [Children] = {
            scope:New "Frame" {
                Size = UDim2.fromOffset(400, 300),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(40, 30, 60), -- Warna Ungu (Beda dari Native Merah)
                
                [Children] = {
                    scope:New "UICorner" { CornerRadius = UDim.new(0, 10) },
                    
                    -- Header
                    scope:New "TextLabel" {
                        Text = "⚠️ FALLBACK UI: " .. (config.Topbar.Text or "SHOP"),
                        Size = UDim2.new(1, 0, 0, 50),
                        BackgroundTransparency = 1,
                        TextColor3 = Color3.new(1, 0.5, 0.5),
                        Font = Enum.Font.GothamBlack
                    },
                    
                    -- Buy Button
                    scope:New "TextButton" {
                        Text = "BUY SWORD (FALLBACK MODE)",
                        Size = UDim2.new(0.8, 0, 0, 50),
                        Position = UDim2.fromScale(0.1, 0.4),
                        BackgroundColor3 = Color3.fromRGB(100, 100, 255),
                        TextColor3 = Color3.new(1,1,1),
                        
                        [OnEvent "Activated"] = function()
                            if props.OnBuy then props.OnBuy() end
                        end,
                        [Children] = { scope:New "UICorner" { CornerRadius = UDim.new(0,6) } }
                    },
                    
                    -- Close Button
                    scope:New "TextButton" {
                        Text = "CLOSE",
                        Size = UDim2.new(0.8, 0, 0, 40),
                        Position = UDim2.fromScale(0.1, 0.8),
                        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
                        TextColor3 = Color3.new(1,1,1),
                        
                        [OnEvent "Activated"] = function()
                            props.IsVisible:set(false)
                        end,
                        [Children] = { scope:New "UICorner" { CornerRadius = UDim.new(0,6) } }
                    }
                }
            }
        }
    }
    return screen, scope
end

return ClientView
