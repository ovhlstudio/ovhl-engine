local RS = game:GetService("ReplicatedStorage")
local UI = require(RS.OVHL.UI.API)
local Fusion = UI.Fusion
local scoped = Fusion.scoped
local Players = game:GetService("Players")

local Ctrl = {}

function Ctrl:Init(ctx)
    self.Ctx = ctx
    self.Api = ctx.Network:Get("PermissionSystem")
    self.Scope = scoped(Fusion)
    self.State = {
        SearchQuery = self.Scope:Value(""),
        SearchResults = self.Scope:Value({}),
        SelectedPlayer = self.Scope:Value(nil),
    }
    self.LocalCache = {}
end

function Ctrl:Start()
    local View = require(script.Parent.Parent.Parent.UI.AdminPanel.AdminView)
    self.View = View.New(self.State, {
        OnSearch = function(q) self:DoSearch(q) end,
        OnSelect = function(p) self.State.SelectedPlayer:set(p) end,
        OnRankSet = function(id) self:SubmitRank(id) end,
        OnClose = function() self:Toggle(false) end
    })
    self.Ctx.UI:Register("AdminPanel", self.View)
    
    -- [FIX] FORCE CLOSE DELAYED
    task.spawn(function()
        task.wait(0.1) -- Tunggu UI mounting selesai
        self:Toggle(false)
    end)
    
    self:RefreshList()
end

function Ctrl:Toggle(v)
    self.Ctx.UI[v and "Open" or "Close"](self.Ctx.UI, "AdminPanel")
    self.Ctx.Topbar:SetState("Admin", v)
    if v then self:RefreshList() end
end

function Ctrl:RefreshList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(list, { Name=p.Name, UserId=p.UserId, CurrentRank=0 })
    end
    self.LocalCache = list
    self:DoSearch(Fusion.peek(self.State.SearchQuery))
end

function Ctrl:DoSearch(q)
    self.State.SearchQuery:set(q)
    local query = string.lower(q or "")
    local filtered = {}
    for _, p in ipairs(self.LocalCache) do
        if query == "" or string.find(string.lower(p.Name), query) then
            table.insert(filtered, p)
        end
    end
    self.State.SearchResults:set(filtered)
end

function Ctrl:SubmitRank(rankId)
    local p = Fusion.peek(self.State.SelectedPlayer)
    if not p then return end
    
    self.Api:SetRank(p.UserId, rankId):andThen(function(r)
        if r.Success then 
            self.Ctx.UI:ShowToast("Rank Updated", "Success")
            p.CurrentRank = rankId
            -- Update Cache
            for i, v in ipairs(self.LocalCache) do
                if v.UserId == p.UserId then v.CurrentRank = rankId; break end
            end
            -- Refresh UI
            self.State.SelectedPlayer:set(p) 
            self.State.SearchResults:set(self.LocalCache)
        end
    end)
end

return Ctrl
