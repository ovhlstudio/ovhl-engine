local RS = game:GetService("ReplicatedStorage")
local UI = require(RS.OVHL.UI.API)
local Fusion = UI.Fusion
local Theme = UI.Theme

local View = {}
View.__index = View

function View.New(state, callbacks)
    local self = setmetatable({}, View)
    self.Scope = Fusion.scoped(Fusion)
    self.IsVisible = self.Scope:Value(false)
    
    local pendingRank = self.Scope:Value(nil)
    local showConfirm = self.Scope:Value(false)
    local confirmData = self.Scope:Value({Title="", Desc=""})

    -- Rank Helper
    local function getRankInfo(r) 
        local names = {"NonAdmin","VIP","Mod","Admin","HeadAdmin","Owner"}
        local colors = Theme.Colors.Rank
        return names[(r or 0)+1] or "Guest", colors[r or 0] or Color3.new(1,1,1)
    end

    self.Scope:Observer(state.SelectedPlayer):onChange(function() pendingRank:set(nil) end)

    -- MODAL
    UI.Modal(self.Scope, {
        Visible = showConfirm,
        Title = self.Scope:Computed(function(use) return use(confirmData).Title end),
        Description = self.Scope:Computed(function(use) return use(confirmData).Desc end),
        OnCancel = function() showConfirm:set(false) end,
        OnConfirm = function() local d=Fusion.peek(confirmData); if d.Action then d.Action() end; showConfirm:set(false) end
    })

    -- MAIN WINDOW
    UI.Window(self.Scope, {
        Title = "ACCESS CONTROL",
        Visible = self.IsVisible,
        Size = UDim2.fromOffset(950, 650),
        OnClose = callbacks.OnClose,
        [Fusion.Children] = {
            self.Scope:New "UIListLayout" { FillDirection="Horizontal" },
            
            -- KIRI: INSPECTOR (35%)
            self.Scope:New "Frame" {
                Size = UDim2.new(0.35, 0, 1, 0), BackgroundColor3 = Theme.Colors.Panel, BorderSizePixel=0,
                [Fusion.Children] = {
                    self.Scope:New "UIPadding" { PaddingTop=UDim.new(0,25), PaddingLeft=UDim.new(0,20), PaddingRight=UDim.new(0,20) },
                    
                    self.Scope:Computed(function(use, scope)
                        local p = use(state.SelectedPlayer)
                        if not p then 
                            return scope:New "TextLabel" { 
                                Text="Select Player >", Size=UDim2.fromScale(1,1), 
                                BackgroundTransparency=1, TextColor3=Theme.Colors.TextGray, Font=Theme.Fonts.Body, TextSize=18 
                            } 
                        end
                        
                        local cur = p.CurrentRank or 0
                        local sel = use(pendingRank) or cur
                        local rName, rColor = getRankInfo(cur)
                        
                        return scope:New "ScrollingFrame" {
                            Size=UDim2.fromScale(1,1), BackgroundTransparency=1, CanvasSize=UDim2.new(), AutomaticCanvasSize="Y",
                            ScrollBarThickness=0,
                            [Fusion.Children] = {
                                scope:New "UIListLayout" { Padding=UDim.new(0,20), HorizontalAlignment="Center" },
                                
                                UI.Avatar(scope, { UserId=p.UserId, Size=UDim2.fromOffset(130,130), StrokeColor=rColor }),
                                
                                scope:New "TextLabel" { 
                                    Text=string.upper(p.Name), Font=Theme.Fonts.Title, TextSize=26, 
                                    TextColor3=Color3.new(1,1,1), AutomaticSize="XY", BackgroundTransparency=1 
                                },
                                
                                scope:New "TextButton" {
                                    Text = string.upper(rName), TextSize=14, Font=Theme.Fonts.Body,
                                    TextColor3 = Color3.new(0,0,0), BackgroundColor3=rColor,
                                    Size=UDim2.fromOffset(120, 30), AutoButtonColor=false,
                                    [Fusion.Children] = { scope:New "UICorner" { CornerRadius=UDim.new(1,0) } }
                                },

                                scope:New "Frame" { Size=UDim2.new(1,0,0,2), BackgroundColor3=Theme.Colors.Border, BorderSizePixel=0 },

                                scope:New "Frame" {
                                    Size=UDim2.new(1,0,0,150), BackgroundTransparency=1,
                                    [Fusion.Children] = {
                                        scope:New "UIGridLayout" { CellSize=UDim2.fromScale(0.45,0.28), CellPadding=UDim2.fromOffset(10,10) },
                                        scope:ForValues({0,1,2,3,4,5}, function(use, scope, r)
                                            local n, c = getRankInfo(r)
                                            return UI.Button(scope, {
                                                Text=string.upper(n), Variant=sel==r and "Primary" or "Input",
                                                OnClick=function() pendingRank:set(r) end
                                            })
                                        end)
                                    }
                                },
                                
                                (use(pendingRank) and use(pendingRank) ~= cur) and UI.Button(scope, {
                                    Text="SAVE CHANGES", Variant="Success", Size=UDim2.new(1,0,0,50),
                                    OnClick=function()
                                        confirmData:set({ Title="CONFIRM RANK", Desc="Change "..p.Name.." to "..getRankInfo(use(pendingRank)).."?", Action=function() callbacks.OnRankSet(use(pendingRank)); pendingRank:set(nil) end })
                                        showConfirm:set(true)
                                    end
                                }) or nil,
                                
                                UI.Button(scope, { Text="KICK USER", Variant="Danger", Size=UDim2.new(1,0,0,45), OnClick=function() end })
                            }
                        }
                    end)
                }
            },
            
            -- KANAN: LIST (65%)
            self.Scope:New "Frame" {
                Size = UDim2.new(0.65, 0, 1, 0), BackgroundColor3 = Theme.Colors.Background, BorderSizePixel=0,
                [Fusion.Children] = {
                    self.Scope:New "UIPadding" { PaddingTop=UDim.new(0,25), PaddingLeft=UDim.new(0,25), PaddingRight=UDim.new(0,25), PaddingBottom=UDim.new(0,25) },
                    self.Scope:New "UIListLayout" { Padding=UDim.new(0,20) },
                    
                    UI.Input(self.Scope, { Placeholder="Search Username or ID...", OnChange=callbacks.OnSearch }),
                    
                    self.Scope:New "ScrollingFrame" {
                        Size = UDim2.new(1, 0, 1, -70), BackgroundTransparency = 1,
                        CanvasSize = UDim2.new(), AutomaticCanvasSize = "Y", ScrollBarThickness=6,
                        [Fusion.Children] = {
                            self.Scope:New "UIListLayout" { Padding=UDim.new(0,10) },
                            
                            self.Scope:ForValues(state.SearchResults, function(use, scope, p)
                                local isSel = use(state.SelectedPlayer) and use(state.SelectedPlayer).UserId == p.UserId
                                local rName, rColor = getRankInfo(p.CurrentRank)
                                
                                -- [FIX] GUNAKAN TEXTBUTTON LANGSUNG SEBAGAI CONTAINER
                                return scope:New "TextButton" {
                                    Name = "PlayerCard_"..p.Name,
                                    Size = UDim2.new(1, 0, 0, 85), -- TINGGI 85px
                                    BackgroundColor3 = isSel and Theme.Colors.Primary or Theme.Colors.Panel,
                                    AutoButtonColor = false,
                                    Text = "",
                                    
                                    -- KLIK LANGSUNG DI ROOT ELEMENT
                                    [Fusion.OnEvent "Activated"] = function() 
                                        print("Clicked:", p.Name) -- Debug print
                                        callbacks.OnSelect(p) 
                                    end,
                                    
                                    [Fusion.Children] = {
                                        scope:New "UICorner" { CornerRadius = Theme.Metrics.Radius },
                                        
                                        -- STROKE (Border)
                                        scope:New "UIStroke" {
                                            Color = isSel and Theme.Colors.Primary or Theme.Colors.Border,
                                            Thickness = 2,
                                            ApplyStrokeMode = "Border"
                                        },
                                        
                                        -- LAYOUT ISI (Padding)
                                        scope:New "UIPadding" { PaddingLeft=UDim.new(0,15), PaddingRight=UDim.new(0,15) },
                                        
                                        -- AVATAR (KIRI)
                                        scope:New "Frame" {
                                            Size = UDim2.new(0, 55, 1, 0), BackgroundTransparency = 1,
                                            [Fusion.Children] = {
                                                scope:New "UIListLayout" { VerticalAlignment="Center" },
                                                UI.Avatar(scope, { UserId=p.UserId, Size=UDim2.fromOffset(55,55), StrokeColor=rColor })
                                            }
                                        },
                                        
                                        -- INFO TEXT (TENGAH)
                                        scope:New "Frame" {
                                            Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(70, 0),
                                            BackgroundTransparency = 1,
                                            [Fusion.Children] = {
                                                scope:New "UIListLayout" { VerticalAlignment="Center", Padding=UDim.new(0,6) },
                                                
                                                -- NAMA (PUTIH BESAR 22px)
                                                scope:New "TextLabel" { 
                                                    Text = p.Name, 
                                                    TextColor3 = Color3.new(1,1,1), -- WHITE
                                                    Font = Theme.Fonts.Title, TextSize = 22, 
                                                    Size = UDim2.new(1, 0, 0, 24), 
                                                    BackgroundTransparency = 1, TextXAlignment = "Left" 
                                                },
                                                
                                                -- ID & RANK (ABU TERANG 16px)
                                                scope:New "TextLabel" { 
                                                    Text = "ID: "..p.UserId.."  •  "..string.upper(rName), 
                                                    TextColor3 = Color3.new(0.8,0.8,0.8), -- BRIGHT GRAY
                                                    Font = Theme.Fonts.Body, TextSize = 16, 
                                                    Size = UDim2.new(1, 0, 0, 18), 
                                                    BackgroundTransparency = 1, TextXAlignment = "Left"
                                                }
                                            }
                                        }
                                    }
                                }
                            end)
                        }
                    }
                }
            }
        }
    })
    return self
end

function View:Toggle(v) self.IsVisible:set(v) end
function View:Destroy() self.Scope:doCleanup() end
return View
