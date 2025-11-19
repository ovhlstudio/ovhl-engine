--[[ @Component: ShopController (With Sync) ]]
local Ctrl = {}

function Ctrl:Init(ctx)
    self.Ctx = ctx
    self.Api = ctx.Network:Get("PrototypeShop")
    self.View = nil
    -- self.Name sudah diinject Kernel
end

function Ctrl:Start()
    local cfg = self._config.UI
    -- STRICT SCANNER
    local refs = self.Ctx.UI.Scan(cfg.NativeTarget, cfg.Components)
    
    if refs then
        self.Ctx.Logger:Info("Native UI Linked. Injecting Config Data...")
        local txt = cfg.Defaults
        if refs.HeaderLabel then refs.HeaderLabel.Text = txt.HeaderLabel end
        if refs.InfoLabel then   refs.InfoLabel.Text = txt.InfoLabel end
        if refs.BuyBtn then      refs.BuyBtn.Text = txt.BuyBtn end
        if refs.CancelBtn then   refs.CancelBtn.Text = txt.CancelBtn end
        
        self.View = { Toggle = function(v) refs._Root.Enabled = v end }
        
        refs.BuyBtn.MouseButton1Click:Connect(function() self:ReqBuy("Sword") end)
        refs.CloseBtn.MouseButton1Click:Connect(function() self:Toggle(false) end) -- <-- TRIGGER CLOSE
    else
        self.Ctx.Logger:Warn("Using Fallback (Fusion O-UI)")
        local View = require(script.Parent.View)
        self.View = View.New(cfg, {
            OnBuy = function(i) self:ReqBuy(i) end,
            OnClose = function() self:Toggle(false) end -- <-- TRIGGER CLOSE
        })
    end
end

-- [NEW] SYNCHRONIZED TOGGLE
function Ctrl:Toggle(desiredState) 
    -- 1. Visual Window Update
    if self.View then 
        self.View.Toggle(desiredState) 
    end
    
    -- 2. Topbar Icon Update
    -- Ini yang sebelumnya hilang. Controller menyuruh Topbar menyesuaikan diri.
    if self.Ctx.Topbar then
        self.Ctx.Topbar:SetState(self.Name, desiredState)
    end
end

function Ctrl:ReqBuy(item)
    self.Api:BuyItem(item):andThen(function(r) 
        if r.Success then
            print("✅ SUCCESS:", r.Msg)
        else
            warn("⛔ FAIL:", r.Error or r.Msg)
        end
    end):catch(function(err) warn("BRIDGE ERROR", err) end)
end
return Ctrl
