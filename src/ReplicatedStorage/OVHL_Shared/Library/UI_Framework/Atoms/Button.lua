local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Theme = require(script.Parent.Parent.Theme)

local New, OnEvent, Value, Computed = Fusion.New, Fusion.OnEvent, Fusion.Value, Fusion.Computed
local Children = Fusion.Children

return function(props)
    local isHovered = Value(false)
    
    return New "TextButton" {
        Name = props.Name or "AtomButton",
        Text = "",
        Size = props.Size or UDim2.fromOffset(140, 40),
        Position = props.Position or UDim2.new(0,0,0,0),
        AnchorPoint = props.AnchorPoint or Vector2.new(0,0),
        BackgroundColor3 = Computed(function()
            return isHovered:get() and Theme.Colors.Secondary or (props.Color or Theme.Colors.Primary)
        end),
        AutoButtonColor = false,
        
        [OnEvent "MouseEnter"] = function() isHovered:set(true) end,
        [OnEvent "MouseLeave"] = function() isHovered:set(false) end,
        [OnEvent "Activated"] = props.OnClick,
        
        [Children] = {
            New "UICorner" { CornerRadius = Theme.Radius.Small },
            New "TextLabel" {
                Text = props.Text or "BUTTON",
                Font = Theme.Fonts.Body,
                TextColor3 = Theme.Colors.Text,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1)
            }
        }
    }
end
