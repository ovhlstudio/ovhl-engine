local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.OVHL.UI.Core.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)

return function(scope, props)
    return scope:New "Frame" {
        BackgroundColor3 = props.Color or Theme.Colors.Panel,
        BackgroundTransparency = 0,
        Size = props.Size or UDim2.fromScale(1, 1),
        LayoutOrder = props.LayoutOrder,
        [Fusion.Children] = {
            scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius },
            props.HasStroke and scope:New "UIStroke" {
                Color = props.StrokeColor or Theme.Colors.Border, Thickness = 1, ApplyStrokeMode = "Border"
            } or nil,
            props[Fusion.Children]
        }
    }
end
