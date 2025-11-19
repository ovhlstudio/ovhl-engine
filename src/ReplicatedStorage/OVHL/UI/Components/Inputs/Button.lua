local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)
local Logger = require(RS.OVHL.Core.SmartLogger).New("UX")
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

return function(scope, props)
    local text = props.Text or "Button"
    local color = props.Color or Theme.Colors.Primary
    
    return scope:New "TextButton" {
        Text = text, Size = props.Size or UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = color, TextColor3 = Theme.Colors.TextMain,
        Font = Theme.Fonts.Body, TextSize = 16, AutoButtonColor = true,
        [Children] = {
            scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius.Small },
            scope:New "UIStroke" { Color = Color3.new(1,1,1), Transparency = 0.9, Thickness = 1 }
        },
        [OnEvent "Activated"] = function()
            Logger:Info("Button Click", {Label = text})
            if props.OnClick then props.OnClick() end
        end
    }
end
