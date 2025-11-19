local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)
local Read = require(RS.OVHL.UI.Foundation.FusionHelper).read

return function(scope, props)
    local variant = props.Variant or "Body"
    local size = (variant == "Title") and 24 or 14
    local font = (variant == "Title") and Theme.Fonts.Title or Theme.Fonts.Body
    local color = props.Color or Theme.Colors.TextMain
    
    -- Logic untuk align
    local alignMap = {Left = Enum.TextXAlignment.Left, Center = Enum.TextXAlignment.Center, Right = Enum.TextXAlignment.Right}

    return scope:New "TextLabel" {
        Name = "Txt", BackgroundTransparency = 1,
        Size = props.Size or UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.Y,
        Text = props.Text or "", 
        Font = font, TextSize = size, TextColor3 = color,
        TextXAlignment = alignMap[props.Align or "Left"] or Enum.TextXAlignment.Left,
        TextTransparency = props.TextTransparency or 0
    }
end
