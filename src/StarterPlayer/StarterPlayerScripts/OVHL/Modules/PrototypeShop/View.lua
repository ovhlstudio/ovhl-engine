--[[ @Component: ShopView (V9 - Modernized) ]]
local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)

local OVHL = require(RS.OVHL.OVHL)
local UI = OVHL.UI
local Theme = OVHL.Theme -- Consistent Usage

local Window = UI.Window
local Button = UI.Button
local Flex   = UI.Flex

local scoped = Fusion.scoped
local Children = Fusion.Children

local View = {}

function View.New(cfgUI, cb)
    local scope = scoped(Fusion)
    local txt = cfgUI.Defaults 
    
    local contentBody = Flex(scope, {
        Direction = "Vertical", Gap = 16, Padding = 0,
        Content = {
            scope:New "Frame" { 
                Name = "ProductInfo",
                Size = UDim2.new(1, 0, 0, 100),
                BackgroundColor3 = Theme.Colors.Surface,
                [Children] = {
                     scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius.Small },
                     scope:New "TextLabel" {
                        Text = txt.InfoLabel, 
                        Size = UDim2.fromScale(1, 1),
                        BackgroundTransparency = 1,
                        TextColor3 = Theme.Colors.TextDim, 
                        Font = Theme.Fonts.Body,
                        TextSize = 18, 
                        TextXAlignment = "Center"
                    }
                }
            },
            -- Modern UI Calls
            Button(scope, {
                Text = txt.BuyBtn, 
                Color = Theme.Colors.Success, 
                OnClick = function() cb.OnBuy("Sword") end
            }),
            Button(scope, {
                Text = txt.CancelBtn,
                Color = Theme.Colors.Surface,
                OnClick = cb.OnClose
            })
        }
    })

    local windowFrame = Window(scope, {
        Title = txt.HeaderLabel,
        Size = UDim2.fromOffset(360, 350), 
        OnClose = cb.OnClose,
        Content = { contentBody }
    })

    local gui = scope:New "ScreenGui" {
        Name = "Shop_Fusion_V9",
        Parent = game.Players.LocalPlayer.PlayerGui,
        Enabled = false,
        DisplayOrder = 50,
        [Children] = { windowFrame }
    }
    
    return {
        Instance = gui,
        Toggle = function(v) gui.Enabled = v end,
        Destroy = function() scope:doCleanup() end
    }
end
return View
