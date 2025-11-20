--[[ @Component: AdminController (Safety Patched) ]]
local RS = game:GetService("ReplicatedStorage")
local Ctrl = {}

function Ctrl:Init(ctx)
    self.Ctx = ctx
    self.Api = ctx.Network:Get("PermissionSystem")
    self.Logger = ctx.LoggerFactory.Admin()
    self.State = { SearchQuery="", SearchResults={}, SelectedPlayer=nil, SelectedRank=0 }
end

function Ctrl:Start()
    local success, View = pcall(require, script.Parent.Parent.Parent.UI.AdminPanel.AdminView)
    if not success then
        self.Logger:Error("View Load Failed", View)
        return
    end
    
    self.View = View.New({
        OnSearch = function(q) self:DoSearch(q) end,
        OnSelect = function(p) self.State.SelectedPlayer = p; self:RefreshUI() end,
        OnRank   = function(r) self.State.SelectedRank = r; self:RefreshUI() end,
        OnConfirm = function() self:Submit() end,
        OnClose  = function() self:Toggle(false) end
    })
    self.Ctx.UI:Register("AdminPanel", self.View)
end

function Ctrl:Toggle(val)
    self.Ctx.UI[val and "Open" or "Close"](self.Ctx.UI, "AdminPanel")
    self.Ctx.Topbar:SetState("Admin", val)
    
    if val then
        self.State.SearchQuery = ""
        self.State.SelectedPlayer = nil
        self:DoSearch("") -- Auto Fetch
    end
end

function Ctrl:DoSearch(q)
    self.State.SearchQuery = q
    self.Api:SearchPlayers(q):andThen(function(res)
        if res.Success then
            self.State.SearchResults = res.Data
            self:RefreshUI()
        end
    end):catch(function(e)
        self.Logger:Warn("Search Error", e)
    end)
end

function Ctrl:RefreshUI()
    if self.View then self.View.Update(self.State) end
end

function Ctrl:Submit()
    if not self.State.SelectedPlayer then return end
    self.Logger:Info("Updating Rank...")
    
    self.Api:SetRank(self.State.SelectedPlayer.UserId, self.State.SelectedRank or 0)
        :andThen(function(r)
            if r.Success then 
                self:DoSearch(self.State.SearchQuery) 
                self.State.SelectedPlayer = nil 
                self:RefreshUI()
            end
        end)
end
return Ctrl
