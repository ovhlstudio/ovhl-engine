-- [[ SHOP VIEW V2 (ATOMIC) ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local SharedPath = ReplicatedStorage.OVHL_Shared

-- Import Atoms
local Theme = require(SharedPath.Library.UI_Framework.Theme)
local Button = require(SharedPath.Library.UI_Framework.Atoms.Button)
local Panel = require(SharedPath.Library.UI_Framework.Atoms.Panel)

local New, Children = Fusion.New, Fusion.Children

return function(props)
    -- Props: Visible (Fusion.Value), OnBuy, OnClose
    
    return New "ScreenGui" {
        Name = "OVHL_ShopUI",
        Parent = game.Players.LocalPlayer.PlayerGui,
        Enabled = props.Visible,
        
        [Children] = {
            Panel({
                Size = UDim2.fromOffset(350, 250),
                [Children] = {
                    -- Title
                    New "TextLabel" {
                        Text = "WEAPON SHOP",
                        Font = Theme.Fonts.Title,
                        TextColor3 = Theme.Colors.Text,
                        TextSize = 24,
                        Size = UDim2.new(1, 0, 0, 50),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 10)
                    },
                    
                    -- Content Area
                    Button({
                        Name = "BuyBtn",
                        Text = "BUY SWORD (10G)",
                        Color = Theme.Colors.Success,
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Size = UDim2.fromOffset(200, 50),
                        OnClick = props.OnBuy
                    }),
                    
                    -- Footer / Close
                    Button({
                        Name = "CloseBtn",
                        Text = "CLOSE",
                        Color = Theme.Colors.Danger,
                        Position = UDim2.fromScale(0.5, 0.85),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Size = UDim2.fromOffset(100, 30),
                        OnClick = props.OnClose
                    })
                }
            })
        }
    }
end
