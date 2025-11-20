local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.OVHL.UI.Core.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)
local Sound = require(RS.OVHL.UI.Core.Sound)

return function(scope, props)
    local isHover = scope:Value(false)
    local isPress = scope:Value(false)
    
    local bg = Theme.Colors.Input
    if props.Variant == "Primary" then bg = Theme.Colors.Primary end
    if props.Variant == "Danger" then bg = Theme.Colors.Danger end
    if props.Variant == "Success" then bg = Theme.Colors.Success end
    
    local finalBg = scope:Spring(scope:Computed(function(use)
        return use(isHover) and bg:Lerp(Color3.new(1,1,1), 0.1) or bg
    end), 40, 1)

    return scope:New "TextButton" {
        Text = "", AutoButtonColor = false,
        Size = props.Size or UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = finalBg,
        LayoutOrder = props.LayoutOrder,
        ZIndex = 2,
        
        [Fusion.OnEvent "MouseEnter"] = function() isHover:set(true) end,
        [Fusion.OnEvent "MouseLeave"] = function() isHover:set(false) end,
        [Fusion.OnEvent "MouseButton1Down"] = function() isPress:set(true) end,
        [Fusion.OnEvent "MouseButton1Up"] = function() isPress:set(false) end,
        [Fusion.OnEvent "Activated"] = function()
            if props.OnClick then Sound.Play("Click"); props.OnClick() end
        end,
        
        [Fusion.Children] = {
            scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius },
            scope:New "TextLabel" {
                Text = string.upper(props.Text or "Button"),
                TextColor3 = Theme.Colors.TextMain, -- PUTIH
                Font = Enum.Font.GothamBlack, -- [FIX] TEBAL BANGET
                TextSize = 16, -- [FIX] LEBIH GEDE
                Size = UDim2.fromScale(1,1), BackgroundTransparency = 1
            }
        }
    }
end
