local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)
local Children = Fusion.Children

return function(scope, props)
    return scope:New "Frame" {
        BackgroundColor3 = Theme.Colors.Surface, BackgroundTransparency = 0.4,
        Size = props.Size or UDim2.fromScale(1,1),
        [Children] = {
            scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius.Small },
            scope:New "UIStroke" { Color = Color3.new(1,1,1), Transparency = 0.85 },
            props.Content
        }
    }
end
