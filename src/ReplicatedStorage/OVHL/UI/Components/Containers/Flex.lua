--[[ @Component: Flex (Restored) ]]
local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)
local Children = Fusion.Children

return function(scope, props)
    local dir = props.Direction or "Vertical"
    local gap = props.Gap or 0
    local pad = props.Padding or 0
    local align = props.Align or Enum.HorizontalAlignment.Center
    
    local fillDir = (dir == "Horizontal") and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical

    return scope:New "Frame" {
        Name = props.Name or "FlexContainer",
        BackgroundTransparency = 1,
        Size = props.Size or UDim2.fromScale(1, 0),
        AutomaticSize = props.Auto or Enum.AutomaticSize.Y,
        LayoutOrder = props.LayoutOrder,
        Position = props.Position,
        
        [Children] = {
            scope:New "UIListLayout" {
                FillDirection = fillDir,
                Padding = UDim.new(0, gap),
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = align
            },
            scope:New "UIPadding" {
                PaddingTop = UDim.new(0, pad),
                PaddingBottom = UDim.new(0, pad),
                PaddingLeft = UDim.new(0, pad),
                PaddingRight = UDim.new(0, pad),
            },
            props.Content
        }
    }
end
