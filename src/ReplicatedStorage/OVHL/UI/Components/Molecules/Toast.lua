local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.OVHL.UI.Core.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)
return function(scope, props)
    local anim = scope:Value(0); task.spawn(function() anim:set(1) end)
    local col = props.Type == "Success" and Theme.Colors.Success or Theme.Colors.Primary
    return scope:New "Frame" {
        Size = UDim2.fromOffset(300, 50), BackgroundColor3 = Theme.Colors.Panel,
        [Fusion.Children] = {
            scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius },
            scope:New "UIStroke" { Color = col, Thickness = 1 },
            scope:New "UIScale" { Scale = scope:Spring(anim, 40, 0.8) },
            scope:New "Frame" { Size=UDim2.new(0,6,1,0), BackgroundColor3=col, [Fusion.Children]={scope:New "UICorner"{CornerRadius=UDim.new(1,0)}} },
            scope:New "TextLabel" { Text=props.Message, Position=UDim2.fromOffset(15,0), Size=UDim2.new(1,-15,1,0), BackgroundTransparency=1, TextColor3=Theme.Colors.TextWhite, Font=Theme.Fonts.Body, TextSize=14, TextXAlignment="Left" }
        }
    }
end
