--[[ @Component: ShopView (Revised Design) ]]
local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)

local UI = RS.OVHL.UI
local Theme  = require(UI.Foundation.Theme)
local Window = require(UI.Components.Surfaces.Window)
local Button = require(UI.Components.Inputs.Button)
local Flex   = require(UI.Components.Containers.Flex)

local scoped = Fusion.scoped
local View = {}

function View.New(cfg, cb)
    local scope = scoped(Fusion)
    local TextData = cfg.Defaults
    
    local contentBody = Flex(scope, {
        Direction = "Vertical", Gap = 16, Padding = 0,
        Content = {
            scope:New "Frame" { -- Product Card
                Name = "ProductInfo",
                Size = UDim2.new(1, 0, 0, 100),
                BackgroundColor3 = Theme.Colors.Surface,
                
                [Fusion.Children] = {
                     scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius.Small },
                     scope:New "TextLabel" {
                        Text = TextData.InfoLabel, 
                        Size = UDim2.fromScale(1, 1),
                        BackgroundTransparency = 1,
                        TextColor3 = Theme.Colors.TextDim, 
                        Font = Theme.Fonts.Body,
                        TextSize = 18, -- Large Readable Text
                        TextXAlignment = "Center"
                    }
                }
            },
            
            Button(scope, {
                Text = TextData.BuyBtn, 
                Color = Theme.Colors.Success, -- Green
                OnClick = function() cb.OnBuy("Sword") end
            }),
            
            Button(scope, {
                Text = TextData.CancelBtn,
                Color = Theme.Colors.Surface, -- Grey
                OnClick = cb.OnClose
            })
        }
    })

    local windowFrame = Window(scope, {
        Title = TextData.HeaderLabel,
        Size = UDim2.fromOffset(360, 350), 
        OnClose = cb.OnClose,
        Content = { contentBody }
    })

    local gui = scope:New "ScreenGui" {
        Name = "Shop_Fusion_View",
        Parent = game.Players.LocalPlayer.PlayerGui,
        Enabled = false,
        DisplayOrder = require(UI.Foundation.Layers).Window,
        [Fusion.Children] = { windowFrame }
    }
    
    return {
        Instance = gui,
        Toggle = function(v) gui.Enabled = v end,
        Destroy = function() scope:doCleanup() end
    }
end
return View
