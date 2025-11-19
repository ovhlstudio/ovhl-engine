local Ctrl = {}

function Ctrl:Init(ctx)
    self.Ctx = ctx
    self.Api = ctx.Network:Get("PrototypeShop")
    self.View = nil
end

function Ctrl:Start()
    local cfg = self._config.UI
    -- STRICT SCANNER
    local refs = self.Ctx.UI.Scan(cfg.Native, cfg.Components)
    
    if refs then
        self.Ctx.Logger:Info("Native UI Linked")
        self.View = { Toggle = function(v) refs._Root.Enabled = v end }
        refs.BuyBtn.MouseButton1Click:Connect(function() self:ReqBuy("Sword") end)
        refs.CloseBtn.MouseButton1Click:Connect(function() self:Toggle(false) end)
    else
        self.Ctx.Logger:Warn("Fallback Mode (Fusion)")
        local View = require(script.Parent.View)
        self.View = View.New(self._config.UI, {
            OnBuy = function(i) self:ReqBuy(i) end
        })
    end
end

function Ctrl:Toggle(s) if self.View then self.View.Toggle(s) end end

function Ctrl:ReqBuy(item)
    self.Api:BuyItem(item):andThen(function(r) 
        if r.Success then
            print("✅ PURCHASE:", r.Msg)
            -- Trigger Notification Controller jika ada (Opsional integration)
        else
            -- Menangani Error Logic (Msg) atau Error System (Error)
            warn("⛔ TRANSACTION FAIL:", r.Msg or r.Error)
        end
    end):catch(function(err)
        warn("💥 BRIDGE ERROR:", err)
    end)
end
return Ctrl
