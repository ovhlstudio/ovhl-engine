local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)
local Children = Fusion.Children

return function(scope, props)
    return scope:New "Frame" {
        BackgroundColor3 = props.Color or Theme.Colors.Primary, BackgroundTransparency = 0.2,
        Size = props.Size or UDim2.fromOffset(60, 20),
        [Children] = {
            scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius.Small },
            scope:New "TextLabel" {
                BackgroundTransparency = 1, Size = UDim2.fromScale(1,1),
                Text = string.upper(props.Text or ""), TextColor3 = Theme.Colors.TextMain,
                TextSize = 10, Font = Theme.Fonts.Body
            }
        }
    }
end
