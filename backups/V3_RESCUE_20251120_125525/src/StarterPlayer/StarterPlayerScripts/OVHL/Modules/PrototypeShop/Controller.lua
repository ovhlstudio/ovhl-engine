--[[ @Component: ShopController (Hybrid V2) ]]
local Ctrl = {}

function Ctrl:Init(ctx)
    self.Ctx = ctx
    self.Api = ctx.Network:Get("PrototypeShop")
    self.View = nil
end

function Ctrl:Start()
    local cfg = self._config.UI
    local finder = self.Ctx.Finder
    
    -- 1. TRY FINDING NATIVE UI (Robust Method)
    -- Component map ambil dari Config V2 section UI.Components
    local map, err = finder.ResolveMap(cfg.NativeTarget, cfg.Components)
    
    if map then
        self.Ctx.Logger:Info("Native Shop UI Found. Binding...")
        
        -- Setup Native Logic
        map.HeaderLabel.Text = cfg.Defaults.HeaderLabel
        map.InfoLabel.Text   = cfg.Defaults.InfoLabel
        map.BuyBtn.Text      = cfg.Defaults.BuyBtn
        map.CancelBtn.Text   = cfg.Defaults.CancelBtn
        
        -- Bind Events
        map.BuyBtn.MouseButton1Click:Connect(function() self:ReqBuy("Sword") end)
        map.CancelBtn.MouseButton1Click:Connect(function() self:Toggle(false) end)
        
        self.View = { 
            Toggle = function(v) map._Root.Enabled = v end 
        }
    else
        self.Ctx.Logger:Warn("Native UI Missing. Fallback to Fusion.", err)
        
        local View = require(script.Parent.View)
        self.View = View.New(cfg, {
            OnBuy = function(i) self:ReqBuy(i) end,
            OnClose = function() self:Toggle(false) end
        })
    end
    
    -- REGISTER TO SERVICE
    self.Ctx.UI:Register("PrototypeShop", self.View)
end

function Ctrl:Toggle(v)
    self.Ctx.UI[v and "Open" or "Close"](self.Ctx.UI, "PrototypeShop")
    self.Ctx.Topbar:SetState(self.Name, v)
end

function Ctrl:ReqBuy(item)
    self.Api:BuyItem(item):andThen(function(r) 
        if r.Success then
            print("✅ BUY OK")
        end
    end)
end
return Ctrl
