--[[ @Component: Separator (Restored) ]]
local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)

return function(scope, props)
    return scope:New "Frame" {
        Name = "Line",
        BackgroundColor3 = Theme.Colors.Border,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 1)
    }
end
