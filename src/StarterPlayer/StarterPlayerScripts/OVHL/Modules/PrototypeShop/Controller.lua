
local Ctrl = {}

function Ctrl:Init(ctx)
    self.Ctx = ctx
    self.Api = ctx.Network:Get("PrototypeShop")
end

function Ctrl:Start()
    local View = require(script.Parent.View)
    self.View = View.New(self._config.UI, {
        OnBuy = function(i) self:ReqBuy(i) end,
        OnClose = function() self:Toggle(false) end
    })
    self.Ctx.UI:Register("PrototypeShop", self.View)
    -- JANGAN AUTO BUKA
end

function Ctrl:Toggle(v)
    self.Ctx.UI[v and "Open" or "Close"](self.Ctx.UI, "PrototypeShop")
    self.Ctx.Topbar:SetState(self.Name, v)
end

function Ctrl:ReqBuy(item)
    self.Api:BuyItem(item):andThen(function(r) 
        if r.Success then
            self.Ctx.UI:ShowToast("Purchase Successful!", "Success")
        end
    end)
end
return Ctrl

