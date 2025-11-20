local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)
local Children = Fusion.Children

return function(scope, props)
    return scope:New "ScrollingFrame" {
        Name = "Grid", BackgroundTransparency = 1, Size = props.Size or UDim2.fromScale(1,1),
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4, BorderSizePixel = 0,
        [Children] = {
            scope:New "UIGridLayout" {
                CellSize = props.CellSize or UDim2.fromOffset(100,100),
                CellPadding = UDim2.fromOffset(10,10),
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            },
            scope:New "UIPadding" { PaddingTop=UDim.new(0,10), PaddingLeft=UDim.new(0,10) },
            props.Content
        }
    }
end
