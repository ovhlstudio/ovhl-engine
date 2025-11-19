--[[ @Component: InventoryView (Scope Fix) ]]
local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)

local UI = RS.OVHL.UI
local Theme = require(UI.Foundation.Theme)
local Window = require(UI.Components.Surfaces.Window)
local Grid = require(UI.Components.Containers.Grid)
local Canvas = require(UI.Components.Containers.Canvas)
local Card = require(UI.Components.Surfaces.Card)
local Badge = require(UI.Components.Feedback.Badge)
local Button = require(UI.Components.Inputs.Button)
local Text = require(UI.Foundation.Typography)

local scoped = Fusion.scoped
local peek = Fusion.peek

local View = {}

function View.New(cfg, state, cb)
    local scope = scoped(Fusion)
    local gridVisuals = scope:Value({})
    
    -- DYNAMIC SCOPE VARIABLE (Kita akan ganti-ganti isinya)
    local currentRenderScope = nil
    
    local rarityColors = {
        Common=Theme.Colors.Secondary, Uncommon=Theme.Colors.Success,
        Rare=Theme.Colors.Primary, Legendary=Theme.Colors.Warning,
        Consumable=Theme.Colors.Danger, Epic=Color3.fromHex("A020F0")
    }

    local function renderItems()
        -- 1. DISPOSE OLD SCOPE
        -- "Buang kantong plastik lama"
        if currentRenderScope then
            currentRenderScope:doCleanup()
            currentRenderScope = nil
        end
        
        -- 2. CREATE NEW SCOPE
        -- "Ambil kantong plastik baru dari gulungan utama"
        -- innerScope otomatis terdaftar di 'scope' (parent), jadi aman memory leak.
        currentRenderScope = scope:innerScope()
        local s = currentRenderScope -- Alias biar pendek
        
        -- 3. FETCH DATA
        local raw = state.Items
        local items = {}
        if type(raw) == "table" and raw._value then items = raw._value
        elseif peek then items = peek(raw) 
        else items = raw end
        if type(items) ~= "table" then items = {} end
        
        print("🎨 [RENDERER] Drawing items:", #items)

        -- 4. RENDER USING NEW SCOPE
        if #items == 0 then
            gridVisuals:set({
                Text(s, {
                    Variant="Title", Text="TAS KOSONG", Align="Center", 
                    Color=Theme.Colors.TextDim, Size=UDim2.new(1,0,0,100)
                })
            })
            return
        end
        
        local newVisuals = {}
        for _, item in ipairs(items) do
             -- PASS 's' (currentRenderScope) to components
             local card = Card(s, {
                 Size = UDim2.fromOffset(140, 160),
                 Content = s:New "Frame" {
                     BackgroundTransparency = 1, Size = UDim2.fromScale(1,1),
                     [Fusion.Children] = {
                         s:New "UIPadding" { PaddingTop=UDim.new(0,8), PaddingLeft=UDim.new(0,8) },
                         Text(s, {Text=item.Name, Size=UDim2.new(1,0,0,30)}),
                         
                         s:New "Frame" {
                             Position=UDim2.fromScale(0, 0.25), Size=UDim2.new(1,0,0,24), BackgroundTransparency=1,
                             [Fusion.Children] = { Badge(s, {Text=item.Rarity, Size=UDim2.fromOffset(80, 18), Color=rarityColors[item.Rarity] or Theme.Colors.Secondary}) }
                         },
                         
                         s:New "Frame" {
                             AnchorPoint=Vector2.new(0,1), Position=UDim2.fromScale(0,1), Size=UDim2.new(1,0,0,30), BackgroundTransparency=1,
                             [Fusion.Children] = { Button(s, {Text="EQUIP", Color=Theme.Colors.Surface, OnClick=function() cb.OnEquip(item.Id) end}) }
                         }
                     }
                 }
             })
             table.insert(newVisuals, card)
        end
        
        gridVisuals:set(newVisuals)
    end

    -- SETUP OBSERVER
    local obs = scope:Observer(state.Items)
    obs:onChange(renderItems)
    
    -- INITIAL DRAW
    renderItems()

    -- MAIN UI
    local win = Window(scope, {
        Title = cfg.Defaults.Title, Size = UDim2.fromOffset(520, 420), OnClose = cb.OnClose,
        Content = Grid(scope, { CellSize=UDim2.fromOffset(140,160), Content=gridVisuals })
    })

    local screen = scope:New "ScreenGui" {
        Name = "Inventory_Final", Parent = game.Players.LocalPlayer.PlayerGui, Enabled = false,
        DisplayOrder = require(UI.Foundation.Layers).Window,
        [Fusion.Children] = { win }
    }
    
    return { Instance=screen, Toggle=function(v) screen.Enabled=v end, Destroy=function() scope:doCleanup() end }
end
return View
