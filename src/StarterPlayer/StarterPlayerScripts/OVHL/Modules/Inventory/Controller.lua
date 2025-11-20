
local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.OVHL.UI.Core.Fusion)

local Ctrl = {}

function Ctrl:Init(ctx)
    self.Ctx = ctx
    self.Api = ctx.Network:Get("Inventory")
    self.Logger = ctx.Logger
    self.Scope = Fusion.scoped(Fusion)
    
    -- State Definition (Reactive)
    self.State = {
        Items = self.Scope:Value({}), 
        SelectedId = self.Scope:Value(nil)
    }
end

function Ctrl:Start()
    local View = require(script.Parent.View)
    local uiConfig = self._config.UI
    
    self.View = View.New(uiConfig, self.State, {
        OnClose = function() self:Toggle(false) end,
        OnEquip = function(id) self:ReqEquip(id) end
    })
    
    self.Ctx.UI:Register("Inventory", self.View)
    self:FetchItems()
end

function Ctrl:Toggle(val)
    self.Ctx.UI[val and "Open" or "Close"](self.Ctx.UI, "Inventory")
    self.Ctx.Topbar:SetState(self.Name, val)
    if val then self:FetchItems() end
end

function Ctrl:FetchItems()
    self.Api:GetItems():andThen(function(res)
        if res and res.Success then
            self.State.Items:set(res.Data)
            self.Logger:Info("Inventory Updated", {Count = #res.Data})
        end
    end)
end

function Ctrl:ReqEquip(id)
    self.Api:Equip(id):andThen(function(r)
        if r.Success then
            self.State.SelectedId:set(id) -- Optimistic update
            self.Ctx.UI:ShowToast("Equipped Successfully", "Success")
        end
    end)
end

return Ctrl

