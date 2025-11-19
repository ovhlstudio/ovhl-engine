--[[ @Component: Tooltip (Restored) ]]
local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)
local Children = Fusion.Children

return function(scope, props)
    return scope:New "Frame" {
        Name = "Tooltip",
        BackgroundColor3 = Theme.Colors.Background,
        Size = props.Size or UDim2.fromOffset(140, 32),
        ZIndex = 100,
        
        [Children] = {
            scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius.Small },
            scope:New "UIStroke" { Color = Theme.Colors.Border, Thickness = 1 },
            
            scope:New "TextLabel" {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = props.Text or "",
                TextColor3 = Theme.Colors.TextMain,
                TextSize = 12,
                Font = Theme.Fonts.Body,
                TextWrapped = true
            }
        }
    }
end
