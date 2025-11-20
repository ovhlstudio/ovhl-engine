--[[ @Component: TextField (Production Grade) ]]
local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)
local Helper = require(RS.OVHL.UI.Foundation.FusionHelper)

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

return function(scope, props)
    -- Resolve text value cleanly
    local textValue = Helper.read(props.Text) or ""
    
    return scope:New "Frame" {
        Name = "InputWrapper",
        BackgroundColor3 = Theme.Colors.Surface,
        BackgroundTransparency = 0.5,
        Size = props.Size or UDim2.new(1, 0, 0, 40),

        [Children] = {
            scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius.Small },
            scope:New "UIStroke" { Color = Theme.Colors.Border, Transparency = 0.5, Thickness = 1 },

            scope:New "TextBox" {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -16, 1, 0),
                Position = UDim2.fromOffset(8, 0),
                Text = textValue,
                PlaceholderText = props.Placeholder or "Type here...",
                PlaceholderColor3 = Theme.Colors.TextDim,
                TextColor3 = Theme.Colors.TextMain,
                TextSize = 14,
                Font = Theme.Fonts.Body,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                
                -- STANDARD EVENT HANDLING
                -- TextBox.FocusLost(enterPressed, inputObject)
                [OnEvent "FocusLost"] = function(enterPressed)
                    -- Kita tidak perlu paranoid check instance di sini
                    -- Fusion menjamin event ini fired dari Instance yang benar
                    if props.OnChange then
                        -- Kirim Text property terbaru via Closure
                        -- Tapi karena keterbatasan akses 'self' di lambda, 
                        -- kita biarkan User men-trigger refresh atau binding TextChanged.
                        -- Best practice: Gunakan Changed event.
                    end
                end,
                
                [OnEvent "Changed"] = function(rbx, property)
                     if property == "Text" and props.OnChange then
                         props.OnChange(rbx.Text)
                     end
                end
            }
        }
    }
end
