--[[ @Component: InventoryView (Hotfix: Use set() syntax) ]]
local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)

local UI = RS.OVHL.UI
local Theme = require(UI.Foundation.Theme)
local Window = require(UI.Components.Surfaces.Window)
local Grid = require(UI.Components.Containers.Grid)
local Card = require(UI.Components.Surfaces.Card)
local Badge = require(UI.Components.Feedback.Badge)
local Button = require(UI.Components.Inputs.Button)
local Text = require(UI.Foundation.Typography)

local scoped = Fusion.scoped
local peek = Fusion.peek
local Children = Fusion.Children

local View = {}

function View.New(cfgUI, state, cb)
    local scope = scoped(Fusion)
    -- DEFINISI VALUE
    local gridVisuals = scope:Value({})
    
    local rarityColors = {
        Common=Theme.Colors.Secondary, Uncommon=Theme.Colors.Success,
        Rare=Theme.Colors.Primary, Legendary=Theme.Colors.Warning,
        Consumable=Theme.Colors.Danger, Epic=Color3.fromHex("A020F0")
    }

    local function renderItems()
        local items = peek(state.Items) or {}
        
        if #items == 0 then
            -- [HOTFIX] Use :set({}) instead of ({})
            gridVisuals:set({
                Text(scope, {
                    Variant="Title", Text="EMPTY BAG", Align="Center", 
                    Color=Theme.Colors.TextDim, Size=UDim2.new(1,0,0,100)
                })
            })
            return
        end
        
        local visuals = {}
        for _, item in ipairs(items) do
            local itemColor = rarityColors[item.Rarity] or Theme.Colors.Secondary
            
            table.insert(visuals, Card(scope, {
                Size = UDim2.fromOffset(140, 160),
                Content = scope:New "Frame" {
                    BackgroundTransparency = 1, Size = UDim2.fromScale(1,1),
                    [Children] = {
                        scope:New "UIPadding" { PaddingTop=UDim.new(0,8), PaddingLeft=UDim.new(0,8) },
                        Text(scope, {Text=item.Name, Size=UDim2.new(1,0,0,30)}),
                        
                        scope:New "Frame" { 
                            Position=UDim2.fromScale(0, 0.25), Size=UDim2.new(1,0,0,24), BackgroundTransparency=1,
                            [Children] = { 
                                Badge(scope, {Text=item.Rarity, Size=UDim2.fromOffset(80, 18), Color=itemColor}) 
                            }
                        },
                        
                        scope:New "Frame" {
                            AnchorPoint=Vector2.new(0,1), Position=UDim2.fromScale(0,1), Size=UDim2.new(1,0,0,30), BackgroundTransparency=1,
                            [Children] = { 
                                Button(scope, {
                                    Text="EQUIP", Color=Theme.Colors.Surface, 
                                    OnClick=function() cb.OnEquip(item.Id) end
                                }) 
                            }
                        }
                    }
                }
            }))
        end
        
        -- [HOTFIX] Use :set()
        gridVisuals:set(visuals)
    end

    local obs = scope:Observer(state.Items)
    obs:onChange(renderItems)
    renderItems() 

    local winInstance = Window(scope, {
        Title = cfgUI.Defaults.Title,
        Size = UDim2.fromOffset(520, 420), 
        OnClose = cb.OnClose,
        Content = Grid(scope, { CellSize=UDim2.fromOffset(140,160), Content=gridVisuals })
    })

    local screen = scope:New "ScreenGui" {
        Name = "Inventory_View",
        Parent = game.Players.LocalPlayer.PlayerGui,
        Enabled = false,
        ResetOnSpawn = false,
        DisplayOrder = 50,
        [Children] = { winInstance }
    }

    return {
        Instance = screen,
        Toggle = function(v) screen.Enabled = v end,
        Destroy = function() scope:doCleanup() end
    }
end
return View
