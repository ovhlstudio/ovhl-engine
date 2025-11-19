local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local SharedPath = ReplicatedStorage.OVHL_Shared
local Theme = require(SharedPath.Library.UI_Framework.Theme)

local New, Children, ForPairs = Fusion.New, Fusion.Children, Fusion.ForPairs

return function(stateList)
    return New "ScreenGui" {
        Name = "OVHL_Toasts",
        DisplayOrder = 1000,
        IgnoreGuiInset = true,
        [Children] = {
            New "Frame" {
                Name = "Container", Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
                [Children] = {
                    New "UIListLayout" { 
                        VerticalAlignment = Enum.VerticalAlignment.Bottom, 
                        HorizontalAlignment = Enum.HorizontalAlignment.Center, 
                        Padding = UDim.new(0,10) 
                    },
                    New "UIPadding" { PaddingBottom = UDim.new(0, 100) },
                    ForPairs(stateList, function(i, data)
                        local c = Theme.Colors.Primary
                        if data.Type == "Success" then c = Theme.Colors.Success end
                        if data.Type == "Error" then c = Theme.Colors.Danger end
                        return i, New "Frame" {
                            Size = UDim2.fromOffset(300, 50), BackgroundColor3 = c,
                            [Children] = {
                                New "UICorner" { CornerRadius = Theme.Radius.Medium },
                                New "TextLabel" {
                                    Text = data.Message, Font = Theme.Fonts.Body,
                                    TextColor3 = Theme.Colors.Text, Size = UDim2.fromScale(1,1),
                                    BackgroundTransparency = 1
                                }
                            }
                        }
                    end, Fusion.cleanup)
                }
            }
        }
    }
end
