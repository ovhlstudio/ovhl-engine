local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.Packages.Fusion)

local Ctrl = {}

function Ctrl:Init(ctx)
    self.Ctx = ctx
    self.Api = ctx.Network:Get("Inventory")
    self.Scope = Fusion.scoped(Fusion)
    
    -- STATE MANAGEMENT
    self.State = {
        Items = self.Scope:Value({}) -- Empty list initially
    }
end

function Ctrl:Start()
    -- Init View with State
    local View = require(script.Parent.View)
    
    self.View = View.New(self._config.UI, self.State, {
        OnClose = function() self:Toggle(false) end,
        OnEquip = function(id) self:ReqEquip(id) end
    })
    
    -- Pre-fetch data (Silent load)
    self:FetchItems()
end

function Ctrl:Toggle(v)
    self.View.Toggle(v)
    if self.Ctx.Topbar then self.Ctx.Topbar:SetState(self.Name, v) end
    
    -- Refresh data when opening
    if v then self:FetchItems() end
end

function Ctrl:FetchItems()
    self.Api:GetItems():andThen(function(res)
        if res.Success then
            -- UPDATE STATE -> UI AUTOMATICALLY UPDATES
            self.State.Items:set(res.Data)
            self.Ctx.Logger:Info("Inventory Refreshed", {Count = #res.Data})
        end
    end)
end

function Ctrl:ReqEquip(id)
    self.Api:Equip(id):andThen(function(r)
        print("🎒 EQUIP:", r.Msg)
        -- Nanti di sini bisa panggil NotificationController:Show(...)
    end)
end

return Ctrl
