local RS = game:GetService("ReplicatedStorage")
local UI = require(RS.OVHL.UI.API)
local Fusion = UI.Fusion
local Theme = UI.Theme

local View = {}
View.__index = View

function View.New(cfg, state, cb)
    local self = setmetatable({}, View)
    self.Scope = Fusion.scoped(Fusion)
    self.IsVisible = self.Scope:Value(false)
    
    -- Modal State
    local showModal = self.Scope:Value(false)
    local modalData = self.Scope:Value({Title="", Desc=""})

    -- RENDER MODAL
    UI.Modal(self.Scope, {
        Visible = showModal,
        Title = self.Scope:Computed(function(use) return use(modalData).Title end),
        Description = self.Scope:Computed(function(use) return use(modalData).Desc end),
        OnCancel = function() showModal:set(false) end,
        OnConfirm = function() 
            local d = Fusion.peek(modalData)
            if d.Action then d.Action() end
            showModal:set(false) 
        end
    })

    UI.Window(self.Scope, {
        Title = "MY INVENTORY", 
        Visible = self.IsVisible, 
        Size = UDim2.fromOffset(800, 600),
        OnClose = cb.OnClose,
        [Fusion.Children] = {
            self.Scope:New "ScrollingFrame" {
                Size=UDim2.fromScale(1,1), BackgroundTransparency=1, CanvasSize=UDim2.new(), AutomaticCanvasSize="Y",
                ScrollBarThickness=6, ScrollBarImageColor3=Theme.Colors.Input,
                [Fusion.Children] = {
                    self.Scope:New "UIPadding" { PaddingTop=UDim.new(0,20), PaddingLeft=UDim.new(0,20), PaddingRight=UDim.new(0,20), PaddingBottom=UDim.new(0,20) },
                    
                    self.Scope:New "UIGridLayout" { 
                        CellSize=UDim2.fromOffset(160, 200), 
                        CellPadding=UDim2.fromOffset(15,15), 
                        HorizontalAlignment="Center" 
                    },
                    
                    self.Scope:ForValues(state.Items, function(use, scope, item)
                        return UI.Card(scope, {
                            Color = Theme.Colors.Panel,
                            HasStroke = true,
                            [Fusion.Children] = {
                                self.Scope:New "UIPadding" { PaddingTop=UDim.new(0,15), PaddingBottom=UDim.new(0,15), PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10) },
                                self.Scope:New "UIListLayout" { HorizontalAlignment="Center", Padding=UDim.new(0,10) },
                                
                                -- Icon
                                scope:New "Frame" {
                                    Size=UDim2.fromOffset(80,80), BackgroundColor3=Theme.Colors.Background,
                                    [Fusion.Children] = {
                                        scope:New "UICorner" { CornerRadius=UDim.new(1,0) }, -- Circle Icon
                                        scope:New "UIStroke" { Color=Theme.Colors.Border, Thickness=1 }
                                    }
                                },
                                
                                -- Text
                                scope:New "Frame" { Size=UDim2.new(1,0,1,-125), BackgroundTransparency=1,
                                    [Fusion.Children] = {
                                        scope:New "TextLabel" { 
                                            Text=string.upper(item.Name), TextColor3=Theme.Colors.TextMain, Font=Theme.Fonts.Body, TextSize=14, 
                                            Size=UDim2.fromScale(1,1), BackgroundTransparency=1, TextWrapped=true, TextYAlignment="Center" 
                                        }
                                    }
                                },
                                
                                -- Equip Button (Triggers Modal)
                                UI.Button(scope, { 
                                    Text="EQUIP", Variant="Primary", Size=UDim2.new(1,0,0,35), 
                                    OnClick=function() 
                                        modalData:set({
                                            Title = "EQUIP ITEM",
                                            Desc = "Do you want to equip "..item.Name.."?",
                                            Action = function() cb.OnEquip(item.Id) end
                                        })
                                        showModal:set(true)
                                    end 
                                })
                            }
                        })
                    end)
                }
            }
        }
    })
    return self
end
function View:Toggle(v) self.IsVisible:set(v) end
function View:Destroy() self.Scope:doCleanup() end
return View
