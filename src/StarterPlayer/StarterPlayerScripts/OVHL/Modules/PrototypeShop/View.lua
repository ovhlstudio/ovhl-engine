local RS = game:GetService("ReplicatedStorage")
local UI = require(RS.OVHL.UI.API)
local Fusion = UI.Fusion
local Theme = UI.Theme

local View = {}
View.__index = View

function View.New(cfg, cb)
    local self = setmetatable({}, View)
    self.Scope = Fusion.scoped(Fusion)
    self.IsVisible = self.Scope:Value(false)

    -- Modal State
    local showModal = self.Scope:Value(false)
    local modalData = self.Scope:Value({Title="", Desc=""})

    -- RENDER MODAL (Reusable Component)
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
        Title = "MARKETPLACE", 
        Visible = self.IsVisible, 
        Size = UDim2.fromOffset(450, 550),
        OnClose = cb.OnClose,
        [Fusion.Children] = {
            self.Scope:New "UIListLayout" { HorizontalAlignment="Center", Padding=UDim.new(0,20) },
            self.Scope:New "UIPadding" { PaddingTop=UDim.new(0,30) },
            
            -- Hero Image
            UI.Card(self.Scope, { 
                Size=UDim2.fromOffset(180,180), 
                Color=Theme.Colors.Background,
                [Fusion.Children] = {
                     self.Scope:New "ImageLabel" {
                        Size=UDim2.fromScale(0.8,0.8), Position=UDim2.fromScale(0.5,0.5), AnchorPoint=Vector2.new(0.5,0.5),
                        BackgroundTransparency=1, Image="rbxassetid://0", ImageColor3=Theme.Colors.TextSub
                     }
                }
            }),
            
            -- Text Info
            self.Scope:New "Frame" {
                Size = UDim2.new(1,0,0,60), BackgroundTransparency=1,
                [Fusion.Children] = {
                    self.Scope:New "UIListLayout" { HorizontalAlignment="Center", Padding=UDim.new(0,5) },
                    self.Scope:New "TextLabel" { Text="MYTHIC SWORD", TextColor3=Theme.Colors.Warning, Font=Theme.Fonts.Title, TextSize=24, AutomaticSize="XY", BackgroundTransparency=1 },
                    self.Scope:New "TextLabel" { Text="Damage: 999 | Durability: ∞", TextColor3=Theme.Colors.TextSub, Font=Theme.Fonts.Body, TextSize=14, AutomaticSize="XY", BackgroundTransparency=1 }
                }
            },
            
            -- Spacer
            self.Scope:New "Frame" { Size=UDim2.new(1,0,1,-350), BackgroundTransparency=1 },
            
            -- Purchase Button (Triggers Modal)
            UI.Button(self.Scope, { 
                Text="BUY NOW (500 G)", 
                Variant="Success", 
                Size=UDim2.new(0.9,0,0,50), 
                OnClick=function() 
                    modalData:set({
                        Title = "CONFIRM PURCHASE",
                        Desc = "Are you sure you want to buy Mythic Sword for 500 Gold?",
                        Action = function() cb.OnBuy("Sword") end
                    })
                    showModal:set(true)
                end 
            })
        }
    })
    return self
end
function View:Toggle(v) self.IsVisible:set(v) end
function View:Destroy() self.Scope:doCleanup() end
return View
