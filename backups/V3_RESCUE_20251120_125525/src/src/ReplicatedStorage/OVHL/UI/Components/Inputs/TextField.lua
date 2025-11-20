--[[ @Component: TextField (HOTFIX - Safe Instance Check) ]]
local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

return function(scope, props)
    -- [HOTFIX] Handle both string and state object for Text property
    -- Fusion TextBox Text property expects STRING, not state object
    local textValue = props.Text
    if type(textValue) == "table" then
        -- If it's a state object (has __call metamethod), call it to get value
        local mt = getmetatable(textValue)
        if mt and mt.__call then
            textValue = textValue()
        end
    end
    
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
                Text = textValue or "",  -- [HOTFIX] Use evaluated value
                PlaceholderText = props.Placeholder or "Type here...",
                PlaceholderColor3 = Theme.Colors.TextDim,
                TextColor3 = Theme.Colors.TextMain,
                TextSize = 14,
                Font = Theme.Fonts.Body,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                
                -- [HOTFIX] SAFE INSTANCE CHECK - NO MORE BOOLEAN ERROR
                [OnEvent "FocusLost"] = function(rbx, isGameProcessed)
                    -- rbx is the TextBox instance - SAFE CHECK
                    if typeof(rbx) == "Instance" and rbx:IsA("TextBox") then
                        if props.OnChange then
                            props.OnChange(rbx.Text)
                        end
                    end
                end,
                
                -- Also listen to TextChanged for realtime update (optional)
                [OnEvent "Changed"] = function(rbx, property)
                    if property == "Text" and typeof(rbx) == "Instance" and rbx:IsA("TextBox") then
                        if props.OnChange then
                            props.OnChange(rbx.Text)
                        end
                    end
                end
            }
        }
    }
end
