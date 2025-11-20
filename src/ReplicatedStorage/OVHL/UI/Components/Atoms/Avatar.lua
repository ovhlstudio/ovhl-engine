local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.OVHL.UI.Core.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)

return function(scope, props)
    return scope:New "ImageLabel" {
        Size = props.Size or UDim2.fromOffset(40, 40),
        Image = "rbxthumb://type=AvatarHeadShot&id="..(props.UserId or 1).."&w=150&h=150",
        BackgroundColor3 = Theme.Colors.Input,
        [Fusion.Children] = {
            scope:New "UICorner" { CornerRadius = UDim.new(1, 0) },
            scope:New "UIStroke" { Color = props.StrokeColor or Theme.Colors.Border, Thickness = 2 }
        }
    }
end
