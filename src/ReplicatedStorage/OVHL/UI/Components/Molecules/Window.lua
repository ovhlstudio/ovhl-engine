local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.OVHL.UI.Core.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)
local Button = require(RS.OVHL.UI.Components.Atoms.Button)

return function(scope, props)
    local visible = props.Visible
    local scale = scope:Spring(scope:Computed(function(use) return use(visible) and 1 or 0 end), 40, 0.8)

    return scope:New "ScreenGui" {
        Name = "Window_"..(props.Title or "UI"),
        Enabled = scope:Computed(function(use) return use(scale) > 0.05 end),
        DisplayOrder = Theme.ZIndex.Window,
        ResetOnSpawn = false, IgnoreGuiInset = true,
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
        
        [Fusion.Children] = {
            -- Container
            scope:New "Frame" {
                Size = props.Size or UDim2.fromOffset(800, 600),
                Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Theme.Colors.Background,
                ZIndex = 10,
                [Fusion.Children] = {
                    scope:New "UIScale" { Scale = scale },
                    scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius },
                    scope:New "UIStroke" { Color = Theme.Colors.Border, Thickness = 1 },
                    
                    -- Shadow
                    scope:New "ImageLabel" {
                        ZIndex=0, Position=UDim2.fromScale(0.5,0.5), AnchorPoint=Vector2.new(0.5,0.5),
                        Size=UDim2.new(1,60,1,60), BackgroundTransparency=1,
                        Image="rbxassetid://6014261993", ImageColor3=Color3.new(0,0,0), ImageTransparency=0.4,
                        ScaleType="Slice", SliceCenter=Rect.new(49,49,450,450)
                    },

                    -- HEADER
                    scope:New "Frame" {
                        Size = UDim2.new(1, 0, 0, 50),
                        BackgroundColor3 = Theme.Colors.Header, -- [FIX] BACA DARI THEME BARU
                        [Fusion.Children] = {
                            scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius },
                            scope:New "Frame" { Size=UDim2.new(1,0,0,10), Position=UDim2.fromScale(0,1), AnchorPoint=Vector2.new(0,1), BackgroundColor3=Theme.Colors.Header, BorderSizePixel=0 },
                            scope:New "UIPadding" { PaddingLeft=UDim.new(0,20), PaddingRight=UDim.new(0,15) },
                            
                            -- TITLE
                            scope:New "TextLabel" {
                                Text = string.upper(props.Title),
                                Font = Theme.Fonts.Title, TextSize = 18,
                                TextColor3 = Theme.Colors.TextMain, -- PUTIH
                                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, TextXAlignment = "Left"
                            },
                            
                            -- CLOSE BUTTON
                            scope:New "TextButton" {
                                Text = "X", Font = Enum.Font.GothamBold, TextSize = 18,
                                TextColor3 = Theme.Colors.Danger, BackgroundTransparency = 1,
                                Size = UDim2.fromOffset(40, 40), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 5, 0.5, 0),
                                [Fusion.OnEvent "Activated"] = props.OnClose
                            }
                        }
                    },
                    
                    -- BODY
                    scope:New "Frame" {
                        Size = UDim2.new(1, 0, 1, -50), Position = UDim2.fromOffset(0, 50),
                        BackgroundTransparency = 1, ClipsDescendants = true,
                        [Fusion.Children] = props[Fusion.Children]
                    }
                }
            }
        }
    }
end
