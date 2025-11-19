--[[ @Component: LoadingSpinner (Restored) ]]
local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)

return function(scope, props)
    return scope:New "Frame" {
        BackgroundTransparency = 1,
        Size = props.Size or UDim2.fromOffset(32, 32),
        [Fusion.Children] = {
            scope:New "ImageLabel" {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Image = "rbxassetid://6026568195", -- Default loading icon
                ImageColor3 = Theme.Colors.Primary,
                [Fusion.Children] = {
                    scope:New "UIAspectRatioConstraint" {}
                }
                -- Rotation logic handled by LocalScript normally or simple loop in controller
            }
        }
    }
end
