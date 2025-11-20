local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.OVHL.UI.Core.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)

return function(scope, props)
    local focus = scope:Value(false)
    return scope:New "Frame" {
        Size = props.Size or UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.Colors.Background,
        [Fusion.Children] = {
            scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius },
            scope:New "UIStroke" {
                Color = scope:Computed(function(use) return use(focus) and Theme.Colors.Primary or Theme.Colors.Border end),
                Thickness = 1.5
            },
            scope:New "TextBox" {
                Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = props.Text or "", PlaceholderText = props.Placeholder,
                TextColor3 = Theme.Colors.TextWhite, PlaceholderColor3 = Theme.Colors.TextGray,
                Font = Theme.Fonts.Body, TextSize = 14, TextXAlignment = "Left",
                [Fusion.OnEvent "Focused"] = function() focus:set(true) end,
                [Fusion.OnEvent "FocusLost"] = function() focus:set(false) end,
                [Fusion.OnChange "Text"] = props.OnChange
            }
        }
    }
end
