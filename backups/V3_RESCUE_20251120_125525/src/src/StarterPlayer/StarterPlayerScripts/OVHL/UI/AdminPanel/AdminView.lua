--[[
    🎨 VIEW: Admin Panel (Pure UI - No Business Logic)
    @Responsibility: Render UI based on state from Controller
]]
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)

local UI = RS.OVHL.UI
local Theme = require(UI.Foundation.Theme)
local Window = require(UI.Components.Surfaces.Window)
local Flex = require(UI.Components.Containers.Flex)
local Button = require(UI.Components.Inputs.Button)
local TextField = require(UI.Components.Inputs.TextField)
local Badge = require(UI.Components.Feedback.Badge)
local Typography = require(UI.Foundation.Typography)
local LoadingSpinner = require(UI.Components.Feedback.LoadingSpinner)

local Enums = require(RS.OVHL.Core.EngineEnums)

local scoped = Fusion.scoped
local Children = Fusion.Children

local View = {}

function View.New(callbacks)
    local scope = scoped(Fusion)
    
    -- UI STATE (Presentation only)
    local uiState = scope:Value({
        SearchQuery = "",
        SearchResults = {},
        SelectedPlayer = nil,
        SelectedRank = 0,
        IsLoading = false
    })
    
    local panelContent = scope:Value({})

    -- PURE RENDER FUNCTION
    local function renderPanel(state)
        local elements = {}
        
        -- ========== HEADER & SEARCH ==========
        table.insert(elements, Typography(scope, {
            Text = "🔐 ADMIN PANEL",
            Variant = "Title",
            Color = Theme.Colors.Primary
        }))
        
        table.insert(elements, TextField(scope, {
            Placeholder = "Search players... (min 2 chars)",
            Text = state.SearchQuery or "",
            OnChange = callbacks.OnSearch
        }))
        
        -- ========== LOADING STATE ==========
        if state.IsLoading then
            table.insert(elements, Flex(scope, {
                Direction = "Horizontal",
                Gap = 8,
                Content = {
                    LoadingSpinner(scope),
                    Typography(scope, {
                        Text = "Searching...",
                        Color = Theme.Colors.TextDim
                    })
                }
            }))
        end
        
        -- ========== SEARCH RESULTS ==========
        if not state.IsLoading and state.SearchQuery and string.len(state.SearchQuery) >= 2 then
            if #state.SearchResults > 0 then
                table.insert(elements, Typography(scope, {
                    Text = "🎯 FOUND " .. #state.SearchResults .. " PLAYERS:",
                    Color = Theme.Colors.Success
                }))
                
                for _, player in ipairs(state.SearchResults) do
                    table.insert(elements, Button(scope, {
                        Text = player.DisplayName .. " (@" .. player.Name .. ")",
                        Size = UDim2.new(1, 0, 0, 35),
                        Color = Theme.Colors.Surface,
                        OnClick = function()
                            callbacks.OnPlayerSelect(player)
                        end
                    }))
                end
            else
                table.insert(elements, Typography(scope, {
                    Text = "❌ No players found for: '" .. state.SearchQuery .. "'",
                    Color = Theme.Colors.Danger
                }))
            end
        end
        
        -- ========== SELECTED PLAYER SECTION ==========
        if state.SelectedPlayer then
            table.insert(elements, Typography(scope, {
                Text = "🎯 TARGET SELECTED:",
                Color = Theme.Colors.Primary
            }))
            
            table.insert(elements, Badge(scope, {
                Text = state.SelectedPlayer.DisplayName .. " (@" .. state.SelectedPlayer.Name .. ")",
                Size = UDim2.new(1, 0, 0, 30),
                Color = Theme.Colors.Surface
            }))
            
            -- Spacer
            table.insert(elements, scope:New "Frame" {
                Size = UDim2.new(1, 0, 0, 12),
                BackgroundTransparency = 1
            })
            
            -- ========== RANK SELECTION ==========
            table.insert(elements, Typography(scope, {
                Text = "SELECT RANK:",
                Variant = "Body",
                Color = Theme.Colors.TextDim
            }))
            
            local rankButtons = {}
            local sortedRanks = {}
            for name, val in pairs(Enums.Permission) do
                table.insert(sortedRanks, { Name = name, Val = val })
            end
            table.sort(sortedRanks, function(a, b) return a.Val < b.Val end)
            
            for _, item in ipairs(sortedRanks) do
                local isSelected = (state.SelectedRank == item.Val)
                table.insert(rankButtons, Button(scope, {
                    Text = item.Name .. " [" .. item.Val .. "]",
                    Size = UDim2.new(0.3, 0, 0, 40),
                    Color = isSelected and Theme.Colors.Success or Theme.Colors.Surface,
                    OnClick = function()
                        callbacks.OnRankSelect(item.Val)
                    end
                }))
            end
            
            table.insert(elements, scope:New "Frame" {
                Size = UDim2.fromScale(1, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                [Children] = {
                    scope:New "UIGridLayout" {
                        CellSize = UDim2.new(0, 90, 0, 40),
                        CellPadding = UDim2.fromOffset(5, 5),
                        HorizontalAlignment = "Center"
                    },
                    rankButtons
                }
            })
            
            -- ========== ACTION BUTTONS ==========
            table.insert(elements, scope:New "Frame" {
                Size = UDim2.new(1, 0, 0, 12),
                BackgroundTransparency = 1
            })
            
            if state.SelectedRank > 0 then
                table.insert(elements, Button(scope, {
                    Text = "✅ CONFIRM PROMOTE TO RANK " .. state.SelectedRank,
                    Color = Theme.Colors.Warning,
                    OnClick = callbacks.OnConfirm
                }))
            else
                table.insert(elements, Typography(scope, {
                    Text = "⚠️ Please select a rank first",
                    Color = Theme.Colors.Warning
                }))
            end
            
            table.insert(elements, Button(scope, {
                Text = "🗑️ CLEAR SELECTION",
                Color = Theme.Colors.Danger,
                OnClick = callbacks.OnClear
            }))
        end
        
        panelContent:set(elements)
    end

    -- UI CONSTRUCTION
    local windowFrame = Window(scope, {
        Title = "ACCESS MANAGER",
        Size = UDim2.fromOffset(400, 600),
        OnClose = callbacks.OnClose,
        Content = Flex(scope, {
            Direction = "Vertical",
            Gap = 12,
            Padding = 0,
            Content = panelContent
        })
    })

    local gui = scope:New "ScreenGui" {
        Name = "AdminPanel_CleanArchitecture",
        Parent = game.Players.LocalPlayer.PlayerGui,
        Enabled = false,
        DisplayOrder = 100,
        ResetOnSpawn = false,
        [Children] = { windowFrame }
    }

    return {
        Instance = gui,
        Toggle = function(v) gui.Enabled = v end,
        Update = function(state) 
            uiState:set(state)
            renderPanel(state)
        end,
        Destroy = function() scope:doCleanup() end
    }
end

return View
