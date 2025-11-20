local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)

local OVHL = require(RS.OVHL.OVHL)
local UI = OVHL.UI 
local Theme = OVHL.Theme
local Window, Button, TextField, Flex = UI.Window, UI.Button, UI.TextField, UI.Flex

local scoped = Fusion.scoped
local peek = Fusion.peek
local Children = Fusion.Children

return {
    New = function(cb)
        local scope = scoped(Fusion)
        local st = scope:Value({SearchResults={}, SelectedPlayer=nil})
        
        local function render()
            local s = peek(st)
            local list = {}
            
            -- 1. RESULT LIST
            for _, p in ipairs(s.SearchResults or {}) do
                local isSel = (s.SelectedPlayer and s.SelectedPlayer.UserId == p.UserId)
                local srcColor = Theme.Colors.Surface
                
                -- Source Indicator
                local srcTag = "UNK"
                if p.Source == "HD_ADMIN" then srcTag="HD"; srcColor=Color3.fromRGB(60,40,40) end
                if p.Source == "INTERNAL_DB" then srcTag="DB"; srcColor=Color3.fromRGB(40,60,40) end
                if p.Source == "OWNER" then srcTag="OWN"; srcColor=Color3.fromRGB(60,60,20) end
                
                if isSel then srcColor = Theme.Colors.Primary end 
                
                table.insert(list, Button(scope, {
                    Text = string.format("[%s] %s (Rank: %d)", srcTag, p.Name, p.CurrentRank or 0),
                    Size = UDim2.new(1,0,0,35), Color = srcColor,
                    OnClick = function() cb.OnSelect(p) end
                }))
            end

            -- 2. RANK BUTTONS (HD ADMIN STANDARD 0-5)
            -- Kita bikin Layout Grid yang rapi
            local rankButtons = {
                -- Row 1: Low Ranks
                Button(scope, {Text="NonAdmin (0)", Color=Theme.Colors.Danger, OnClick=function() cb.OnRank(0) end}),
                Button(scope, {Text="VIP (1)", Color=Theme.Colors.Surface, OnClick=function() cb.OnRank(1) end}),
                
                -- Row 2: Mid Ranks
                Button(scope, {Text="Mod (2)", Color=Color3.fromRGB(52, 152, 219), OnClick=function() cb.OnRank(2) end}),
                Button(scope, {Text="Admin (3)", Color=Color3.fromRGB(241, 196, 15), OnClick=function() cb.OnRank(3) end}),
                
                -- Row 3: High Ranks
                Button(scope, {Text="HeadAdmin (4)", Color=Color3.fromRGB(155, 89, 182), OnClick=function() cb.OnRank(4) end}),
                -- Rank 5 (Owner) biasanya gak di-set manual, tapi kita kasih opsi buat override DB
                Button(scope, {Text="Owner (5)", Color=Color3.fromRGB(231, 76, 60), OnClick=function() cb.OnRank(5) end}),
            }

            local confirmColor = Theme.Colors.Secondary
            local confirmText = "SELECT PLAYER FIRST"
            
            if s.SelectedPlayer then
                confirmColor = Theme.Colors.Success
                confirmText = "APPLY RANK"
                if s.SelectedRank then
                     confirmText = "APPLY RANK: " .. s.SelectedRank
                end
            end

            return Window(scope, {
                Title="ACCESS MANAGER (HD STANDARD)", Size = UDim2.fromOffset(420,600), OnClose=cb.OnClose,
                Content=Flex(scope, { Gap=10, Content={
                        TextField(scope, {Placeholder="Search Player...", OnChange=cb.OnSearch}),
                        
                        -- PLAYER LIST AREA
                        scope:New "TextLabel" {Text="PLAYERS", TextColor3=Theme.Colors.TextDim, BackgroundTransparency=1},
                        scope:New "ScrollingFrame" {
                            Size=UDim2.new(1,0,0,200), BackgroundTransparency=0.5, BackgroundColor3=Color3.new(0,0,0),
                            [Children]={ scope:New "UIListLayout" {Padding=UDim.new(0,2)}, list }
                        },
                        
                        -- RANKS AREA
                        scope:New "TextLabel" {Text="ASSIGN RANK", TextColor3=Theme.Colors.TextDim, BackgroundTransparency=1},
                        scope:New "Frame" {
                            Size=UDim2.new(1,0,0,140), BackgroundTransparency=1,
                            [Children]={
                                scope:New "UIGridLayout" {
                                    CellSize=UDim2.new(0.48, 0, 0, 40), 
                                    CellPadding=UDim2.new(0.04, 0, 0, 5)
                                },
                                unpack(rankButtons)
                            }
                        },
                        
                        -- ACTION
                        Button(scope, {Text=confirmText, Color=confirmColor, OnClick=cb.OnConfirm})
                    }
                }) 
            })
        end

        local gui = scope:New "ScreenGui" { Parent=game.Players.LocalPlayer.PlayerGui, Enabled=false }
        local obs = scope:Observer(st) 
        obs:onChange(function() 
            gui:ClearAllChildren()
            local w = render(); w.Parent = gui 
        end)
        
        return {
            Toggle = function(v) gui.Enabled=v; if v then gui:ClearAllChildren(); local w=render(); w.Parent=gui end end,
            Update = function(s) st:set(s) end
        }
    end
}
