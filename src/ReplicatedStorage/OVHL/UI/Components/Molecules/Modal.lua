local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.OVHL.UI.Core.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)
local Button = require(RS.OVHL.UI.Components.Atoms.Button)
local Spinner = require(RS.OVHL.UI.Components.Atoms.Spinner)

return function(scope, props)
    local visible = props.Visible
    local status = scope:Value("idle")
    local anim = scope:Spring(scope:Computed(function(use) return use(visible) and 1 or 0 end), 45, 0.8)
    
    local progressTarget = scope:Value(1)
    local progress = scope:Spring(progressTarget, 1, 1) 
    
    local currentSessionId = 0
    
    scope:Observer(visible):onChange(function()
        if Fusion.peek(visible) then
            status:set("idle")
            progressTarget:set(1, true)
            task.delay(0.1, function() progressTarget:set(0) end)
            
            currentSessionId = currentSessionId + 1
            local myId = currentSessionId
            
            task.delay(5, function()
                if Fusion.peek(visible) and Fusion.peek(status) == "idle" and currentSessionId == myId then
                    props.OnCancel()
                end
            end)
        else
            currentSessionId = currentSessionId + 1
        end
    end)

    return scope:New "ScreenGui" {
        Name = "ModalOverlay",
        Enabled = scope:Computed(function(use) return use(anim) > 0.01 end),
        DisplayOrder = Theme.ZIndex.Modal, ResetOnSpawn = false, IgnoreGuiInset = true,
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
        
        [Fusion.Children] = {
            scope:New "TextButton" {
                Text="", Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=0.5, 
                AutoButtonColor=false, [Fusion.OnEvent "Activated"] = props.OnCancel
            },
            
            scope:New "Frame" {
                Size = UDim2.fromOffset(550, 320), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Theme.Colors.Background,
                ClipsDescendants = true,
                
                [Fusion.Children] = {
                    scope:New "UIScale" { Scale = anim },
                    scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius },
                    scope:New "UIStroke" { Color = Theme.Colors.Primary, Thickness = 2 },
                    
                    scope:New "UIListLayout" { SortOrder="LayoutOrder", HorizontalAlignment="Center", Padding=UDim.new(0,0) },
                    
                    -- 1. HEADER
                    scope:New "Frame" {
                        LayoutOrder = 1,
                        Size = UDim2.new(1, 0, 0, 70), BackgroundTransparency = 1,
                        [Fusion.Children] = {
                            scope:New "TextLabel" {
                                Text = scope:Computed(function(use) return string.upper(use(props.Title) or "CONFIRM") end),
                                Font = Theme.Fonts.Title, 
                                
                                -- [FIX] PAKE CONFIG BARU
                                TextSize = Theme.Metrics.ModalTitleSize, 
                                TextColor3 = Theme.Colors.ModalTitle,
                                
                                Size = UDim2.fromScale(1,1), BackgroundTransparency = 1
                            },
                            scope:New "Frame" {
                                Size = UDim2.new(1,0,0,2), Position=UDim2.fromScale(0,1), AnchorPoint=Vector2.new(0,1),
                                BackgroundColor3=Theme.Colors.Border, BorderSizePixel=0
                            }
                        }
                    },
                    
                    -- 2. CONTENT
                    scope:New "Frame" {
                        LayoutOrder = 2,
                        Size = UDim2.new(1, 0, 1, -145),
                        BackgroundTransparency = 1,
                        [Fusion.Children] = {
                            scope:New "UIPadding" { PaddingLeft=UDim.new(0,40), PaddingRight=UDim.new(0,40) },
                            scope:Computed(function(use)
                                local s = use(status)
                                local txt = use(props.Description) or "Proceed?"
                                local col = Theme.Colors.TextSub
                                if s == "loading" then txt = "PROCESSING REQUEST..."; col = Theme.Colors.Primary end
                                if s == "success" then txt = "OPERATION SUCCESSFUL"; col = Theme.Colors.Success end
                                
                                return scope:New "TextLabel" {
                                    Text = txt, Font = Theme.Fonts.Body, TextSize = 18,
                                    TextColor3 = col, Size = UDim2.fromScale(1,1),
                                    BackgroundTransparency = 1, TextWrapped = true
                                }
                            end)
                        }
                    },
                    
                    -- 3. FOOTER
                    scope:New "Frame" {
                        LayoutOrder = 3,
                        Size = UDim2.new(1, 0, 0, 70), BackgroundTransparency = 1,
                        [Fusion.Children] = {
                            scope:Computed(function(use)
                                local s = use(status)
                                if s == "loading" then
                                    return scope:New "Frame" {
                                        Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
                                        [Fusion.Children] = { 
                                            scope:New "UIListLayout" { HorizontalAlignment="Center", VerticalAlignment="Center" }, 
                                            Spinner(scope, { Size=UDim2.fromOffset(40,40), Color=Theme.Colors.Primary }) 
                                        }
                                    }
                                elseif s == "success" then
                                    return nil
                                else
                                    return scope:New "Frame" {
                                        Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
                                        [Fusion.Children] = {
                                            scope:New "UIListLayout" { FillDirection="Horizontal", Padding=UDim.new(0,20), HorizontalAlignment="Center", VerticalAlignment="Center" },
                                            Button(scope, { Text="CANCEL", Variant="Danger", Size=UDim2.fromOffset(160,50), OnClick=props.OnCancel }),
                                            Button(scope, { 
                                                Text="CONFIRM", Variant="Success", Size=UDim2.fromOffset(160,50), 
                                                OnClick = function()
                                                    status:set("loading")
                                                    progressTarget:set(Fusion.peek(progress), true)
                                                    task.delay(2, function() props.OnConfirm(); status:set("success") end)
                                                end 
                                            })
                                        }
                                    }
                                end
                            end)
                        }
                    },
                    
                    -- 4. SLIDER
                    scope:New "Frame" {
                        Size = UDim2.new(1, 0, 0, 4), Position=UDim2.fromScale(0,1), AnchorPoint=Vector2.new(0,1),
                        BackgroundColor3 = Color3.new(0,0,0), BorderSizePixel = 0, ZIndex = 10,
                        [Fusion.Children] = {
                            scope:New "Frame" {
                                Size = scope:Computed(function(use) return UDim2.fromScale(use(progress), 1) end),
                                BackgroundColor3 = Theme.Colors.TextMain,
                                BorderSizePixel = 0
                            }
                        }
                    }
                }
            }
        }
    }
end
