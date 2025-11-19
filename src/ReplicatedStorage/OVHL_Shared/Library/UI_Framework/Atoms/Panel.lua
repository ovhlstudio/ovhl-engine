local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Theme = require(script.Parent.Parent.Theme)

local New, Children = Fusion.New, Fusion.Children

return function(props)
    return New "Frame" {
        Name = props.Name or "AtomPanel",
        Size = props.Size or UDim2.fromOffset(300, 200),
        Position = props.Position or UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Colors.Background,
        
        [Children] = {
            New "UICorner" { CornerRadius = Theme.Radius.Medium },
            New "UIStroke" { Color = Theme.Colors.Secondary, Thickness = 2 },
            props.Children
        }
    }
end
