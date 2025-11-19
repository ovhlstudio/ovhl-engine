--[[ @Component: ShopView (Fusion 0.3 Scoped) ]]
local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)

-- Fusion 0.3 Essentials
local scoped = Fusion.scoped

local View = {}

function View.New(cfg, cb)
    -- 1. Create a Scope (Memory Management Unit)
    local scope = scoped(Fusion)
    
    -- 2. Use scope:New instead of Fusion.New
    local gui = scope:New "ScreenGui" {
        Name = "FallbackShop_F03",
        Parent = game.Players.LocalPlayer.PlayerGui,
        Enabled = false,
        
        [Fusion.Children] = {
            scope:New "Frame" {
                Name = "MainFrame",
                Size = UDim2.fromOffset(320, 240),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(35, 35, 45),
                
                [Fusion.Children] = {
                    scope:New "UICorner" { CornerRadius = UDim.new(0, 8) },
                    
                    scope:New "TextLabel" {
                        Text = cfg.Defaults.Title or "SHOP",
                        Size = UDim2.new(1, 0, 0, 50),
                        BackgroundTransparency = 1,
                        TextColor3 = Color3.new(1, 1, 1),
                        Font = Enum.Font.GothamBold,
                        TextSize = 24
                    },
                    
                    scope:New "TextButton" {
                        Name = "BuyBtn",
                        Text = "PURCHASE SWORD (SCOPED)",
                        Size = UDim2.new(0.8, 0, 0, 50),
                        Position = UDim2.fromScale(0.1, 0.5),
                        BackgroundColor3 = Color3.fromRGB(0, 120, 255),
                        TextColor3 = Color3.new(1,1,1),
                        
                        [Fusion.Children] = { 
                            scope:New "UICorner" { CornerRadius = UDim.new(0,6) } 
                        },
                        
                        [Fusion.OnEvent "Activated"] = function()
                            cb.OnBuy("Sword")
                        end
                    }
                }
            }
        }
    }
    
    return {
        Instance = gui,
        Toggle = function(v) gui.Enabled = v end,
        Destroy = function() scope:doCleanup() end -- Clean memory if needed
    }
end

return View
