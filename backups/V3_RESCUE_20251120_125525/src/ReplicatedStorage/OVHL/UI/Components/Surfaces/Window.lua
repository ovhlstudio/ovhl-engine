local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)
local Layers = require(RS.OVHL.UI.Foundation.Layers)
local Icons = require(RS.OVHL.UI.Assets.Icons)
local Logger = require(RS.OVHL.Core.SmartLogger).New("UX")
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

return function(scope, props)
    local title = props.Title or "Window"
    return scope:New "Frame" {
        Name = title.."_Win", Size = props.Size or UDim2.fromOffset(400,300),
        Position = UDim2.fromScale(0.5,0.5), AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = Theme.Colors.Background, ZIndex = Layers.Window,
        [Children] = {
            scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius.Medium },
            scope:New "UIStroke" { Color = Theme.Colors.Border, Thickness = 2 },
            scope:New "Frame" { -- Header
                Size = UDim2.new(1,0,0,40), BackgroundTransparency = 1,
                [Children] = {
                    scope:New "UIPadding" { PaddingLeft=UDim.new(0,12), PaddingRight=UDim.new(0,12) },
                    scope:New "TextLabel" {
                        Text = title:upper(), Size = UDim2.fromScale(0.8,1), BackgroundTransparency = 1,
                        TextColor3 = Theme.Colors.TextMain, Font = Theme.Fonts.Title, TextSize = 16, TextXAlignment="Left"
                    },
                    scope:New "ImageButton" {
                        Image = Icons.General.Close, Size = UDim2.fromOffset(20,20), AnchorPoint=Vector2.new(1,0.5),
                        Position = UDim2.new(1,0,0.5,0), BackgroundTransparency=1, ImageColor3 = Theme.Colors.Danger,
                        [OnEvent "Activated"] = function()
                             Logger:Info("Window Close", {Target=title})
                             if props.OnClose then props.OnClose() end
                        end
                    }
                }
            },
            scope:New "Frame" { -- Content
                Size = UDim2.new(1,0,1,-40), Position = UDim2.new(0,0,0,40), BackgroundTransparency=1,
                [Children] = {
                     scope:New "UIPadding" { PaddingTop=UDim.new(0,8), PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8) },
                     props.Content
                }
            }
        }
    }
end
