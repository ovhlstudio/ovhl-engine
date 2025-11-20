--[[
    🎮 CONTROLLER: Admin System (SUPER DEBUG MODE)
]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")
local OVHL = PlayerScripts:WaitForChild("OVHL")

local AdminController = {}

function AdminController:Init(ctx)
    self.Ctx = ctx
    self.Logger = ctx.Logger
    self.Api = ctx.Network:Get("Admin")
    self.View = nil
    
    -- DEBUG: Log initialization
    self.Logger:Debug("ADMIN", "🔄 Controller.Init() called")
    self.Logger:Debug("ADMIN", "Context keys: " .. table.concat(self:GetTableKeys(ctx), ", "))
    
    -- STATE MANAGEMENT
    self.State = {
        SearchQuery = "",
        SearchResults = {},
        SelectedPlayer = nil,
        SelectedRank = 0,
        IsLoading = false
    }
    
    self.TopbarConfig = {
        Enabled = true,
        Text = "ADMIN",
        Icon = "rbxassetid://3926305904",
        Permission = 3
    }
    
    self.Logger:Debug("ADMIN", "✅ Controller initialized successfully")
end

-- DEBUG: Helper to get table keys
function AdminController:GetTableKeys(tbl)
    local keys = {}
    for k, _ in pairs(tbl) do
        table.insert(keys, tostring(k))
    end
    return keys
end

function AdminController:Start()
    self.Logger:Debug("ADMIN", "🔄 Controller.Start() called")
    
    -- DEBUG: Check if View module exists
    local viewPath = OVHL.UI.AdminPanel.AdminView
    self.Logger:Debug("ADMIN", "View path exists: " .. tostring(viewPath ~= nil))
    
    if not viewPath then
        self.Logger:Error("ADMIN", "❌ View module not found at: OVHL.UI.AdminPanel.AdminView")
        return
    end
    
    local success, AdminView = pcall(require, viewPath)
    if not success then
        self.Logger:Error("ADMIN", "❌ Failed to require AdminView: " .. tostring(AdminView))
        return
    end
    
    self.Logger:Debug("ADMIN", "✅ AdminView required successfully")
    
    -- Initialize View with callbacks
    self.View = AdminView.New({
        OnSearch = function(query) 
            self.Logger:Debug("ADMIN", "🔍 View.OnSearch called with: '" .. tostring(query) .. "'")
            self:HandleSearch(query) 
        end,
        OnPlayerSelect = function(player) 
            self.Logger:Debug("ADMIN", "👤 View.OnPlayerSelect called", player)
            self:HandlePlayerSelect(player) 
        end,
        OnRankSelect = function(rank) 
            self.Logger:Debug("ADMIN", "⭐ View.OnRankSelect called: " .. tostring(rank))
            self:HandleRankSelect(rank) 
        end,
        OnConfirm = function() 
            self.Logger:Debug("ADMIN", "✅ View.OnConfirm called")
            self:HandleConfirm() 
        end,
        OnClear = function() 
            self.Logger:Debug("ADMIN", "🗑️ View.OnClear called")
            self:HandleClear() 
        end,
        OnClose = function() 
            self.Logger:Debug("ADMIN", "❌ View.OnClose called")
            self:Toggle(false) 
        end
    })
    
    self.Logger:Debug("ADMIN", "✅ View created successfully")
    
    -- Register with UI Service
    if self.Ctx.UI and self.Ctx.UI.Register then
        self.Ctx.UI:Register("AdminPanel", self.View)
        self.Logger:Debug("ADMIN", "✅ Registered with UI Service")
    else
        self.Logger:Error("ADMIN", "❌ UI Service not available in context")
    end
    
    -- Register Topbar
    task.delay(2, function() 
        self.Logger:Debug("ADMIN", "⏰ Delayed topbar registration starting...")
        
        if self.Ctx.Topbar and self.Ctx.Topbar.Add then
            self.Ctx.Topbar:Add("AdminPanel", self.TopbarConfig, function(state)
                self.Logger:Debug("ADMIN", "🔘 Topbar clicked! State: " .. tostring(state))
                self:Toggle(state)
            end)
            self.Logger:Debug("ADMIN", "✅ Topbar registered successfully")
        else
            self.Logger:Error("ADMIN", "❌ Topbar service not available")
            self.Logger:Debug("ADMIN", "Topbar in context: " .. tostring(self.Ctx.Topbar ~= nil))
        end
    end)
    
    self.Logger:Debug("ADMIN", "✅ Controller.Start() completed")
end

-- ==================== BUSINESS LOGIC METHODS ====================

function AdminController:HandleSearch(query)
    self.Logger:Debug("ADMIN", "🔍 HandleSearch() called", {
        Query = query,
        QueryLength = string.len(query),
        PreviousQuery = self.State.SearchQuery
    })
    
    self.State.SearchQuery = query
    self.State.IsLoading = true
    
    -- Update UI immediately
    self:UpdateView()
    
    -- Debounced server call
    if string.len(query) >= 2 then
        self.Logger:Debug("ADMIN", "📡 Making server search request...")
        
        -- DEBUG: Check if API is available
        if not self.Api then
            self.Logger:Error("ADMIN", "❌ API not available!")
            return
        end
        
        if not self.Api.SearchPlayers then
            self.Logger:Error("ADMIN", "❌ API.SearchPlayers method not found!")
            self.Logger:Debug("ADMIN", "API methods: " .. table.concat(self:GetTableKeys(self.Api), ", "))
            return
        end
        
        self.Api:SearchPlayers(query):andThen(function(response)
            self.Logger:Debug("ADMIN", "📡 Server response received", {
                Success = response.Success,
                Count = response.Count,
                DataCount = response.Data and #response.Data or 0
            })
            
            self.State.IsLoading = false
            if response.Success then
                self.State.SearchResults = response.Data
                self.Logger:Info("ADMIN", "✅ Search found " .. response.Count .. " players")
            else
                self.State.SearchResults = {}
                self.Logger:Warn("ADMIN", "❌ Search failed: " .. tostring(response.Error))
            end
            self:UpdateView()
        end):catch(function(err)
            self.Logger:Error("ADMIN", "💥 Search request failed", {
                Error = tostring(err),
                Type = type(err)
            })
            self.State.IsLoading = false
            self.State.SearchResults = {}
            self:UpdateView()
        end)
    else
        self.Logger:Debug("ADMIN", "⏸️ Query too short, skipping server call")
        self.State.SearchResults = {}
        self.State.IsLoading = false
        self:UpdateView()
    end
end

function AdminController:HandlePlayerSelect(player)
    self.Logger:Debug("ADMIN", "👤 HandlePlayerSelect() called", player)
    self.State.SelectedPlayer = player
    self.State.SelectedRank = 0
    self.State.SearchQuery = ""
    self.State.SearchResults = {}
    self:UpdateView()
end

function AdminController:HandleRankSelect(rank)
    self.Logger:Debug("ADMIN", "⭐ HandleRankSelect() called: " .. tostring(rank))
    self.State.SelectedRank = rank
    self:UpdateView()
end

function AdminController:HandleConfirm()
    self.Logger:Debug("ADMIN", "✅ HandleConfirm() called", {
        HasPlayer = self.State.SelectedPlayer ~= nil,
        SelectedRank = self.State.SelectedRank
    })
    
    if not self.State.SelectedPlayer or self.State.SelectedRank == 0 then
        self.Logger:Warn("ADMIN", "⚠️ Validation failed - missing player or rank")
        return
    end
    
    self.Logger:Info("ADMIN", "🚀 Setting rank...", {
        Target = self.State.SelectedPlayer.Name,
        Rank = self.State.SelectedRank
    })
    
    self.Api:SetPlayerRank(self.State.SelectedPlayer.UserId, self.State.SelectedRank)
        :andThen(function(response)
            self.Logger:Debug("ADMIN", "📡 SetRank response", response)
            if response.Success then
                self.Logger:Info("ADMIN", "🎉 " .. response.Msg)
                self:HandleClear()
            else
                self.Logger:Warn("ADMIN", "❌ " .. response.Msg)
            end
        end):catch(function(err)
            self.Logger:Error("ADMIN", "💥 SetRank failed: " .. tostring(err))
        end)
end

function AdminController:HandleClear()
    self.Logger:Debug("ADMIN", "🗑️ HandleClear() called")
    self.State.SearchQuery = ""
    self.State.SearchResults = {}
    self.State.SelectedPlayer = nil
    self.State.SelectedRank = 0
    self.State.IsLoading = false
    self:UpdateView()
end

function AdminController:UpdateView()
    self.Logger:Debug("ADMIN", "🔄 UpdateView() called", {
        HasView = self.View ~= nil,
        HasUpdateMethod = self.View and self.View.Update ~= nil
    })
    
    if self.View and self.View.Update then
        self.View.Update(self.State)
        self.Logger:Debug("ADMIN", "✅ View updated successfully")
    else
        self.Logger:Error("ADMIN", "❌ Cannot update view - View or Update method missing")
    end
end

function AdminController:Toggle(val)
    self.Logger:Debug("ADMIN", "🔘 Toggle() called: " .. tostring(val), {
        HasView = self.View ~= nil,
        HasTopbar = self.Ctx.Topbar ~= nil
    })
    
    if self.View then
        self.View.Toggle(val)
        self.Logger:Debug("ADMIN", "✅ View toggled: " .. tostring(val))
        
        if self.Ctx.Topbar then
            self.Ctx.Topbar:SetState("AdminPanel", val)
            self.Logger:Debug("ADMIN", "✅ Topbar state updated: " .. tostring(val))
        end
        
        if val then
            self.Logger:Debug("ADMIN", "🔄 Resetting state for fresh start")
            self:HandleClear()
        end
    else
        self.Logger:Error("ADMIN", "❌ Cannot toggle - View is nil")
    end
end

return AdminController
