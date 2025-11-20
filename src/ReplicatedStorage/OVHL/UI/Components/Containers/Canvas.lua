--[[ @Component: Canvas (Restored) ]]
local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)

local Children = Fusion.Children

return function(scope, props)
    return scope:New "ScrollingFrame" {
        Name = "Canvas",
        BackgroundTransparency = 1,
        Size = props.Size or UDim2.fromScale(1, 1),
        CanvasSize = UDim2.new(), -- Auto handled by UIListLayout/Grid usually
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        
        ScrollBarImageColor3 = Theme.Colors.Secondary,
        ScrollBarThickness = 6,
        ScrollBarImageTransparency = 0.5,
        BorderSizePixel = 0,
        
        [Children] = props.Content
    }
end
