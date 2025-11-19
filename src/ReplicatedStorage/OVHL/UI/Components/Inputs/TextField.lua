--[[ @Component: TextField (Restored) ]]
local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)

local Children = Fusion.Children

return function(scope, props)
    return scope:New "Frame" {
        Name = "InputWrapper",
        BackgroundColor3 = Theme.Colors.Surface,
        BackgroundTransparency = 0.5,
        Size = props.Size or UDim2.new(1, 0, 0, 40),
        
        [Children] = {
            scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius.Small },
            scope:New "UIStroke" { Color = Theme.Colors.Border, Transparency = 0.5, Thickness = 1 },
            
            scope:New "TextBox" {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -16, 1, 0),
                Position = UDim2.fromOffset(8, 0),
                Text = props.Text or "",
                PlaceholderText = props.Placeholder or "Type here...",
                PlaceholderColor3 = Theme.Colors.TextDim,
                TextColor3 = Theme.Colors.TextMain,
                TextSize = 14,
                Font = Theme.Fonts.Body,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false
            }
        }
    }
end
