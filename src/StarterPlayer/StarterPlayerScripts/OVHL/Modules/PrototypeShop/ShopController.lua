local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ShopController = Knit.CreateController { Name = "ShopController" }

function ShopController:KnitInit()
    self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
    self.UIManager = self.OVHL.GetSystem("UIManager")
    self.Config = self.OVHL.GetClientConfig("PrototypeShop")
    self.Logger = self.OVHL.GetSystem("SmartLogger")
    self.Scope = Fusion.scoped(Fusion)
    self.IsVisible = self.Scope:Value(false)
    self.UseFallback = false
end

function ShopController:KnitStart()
    self.Service = Knit.GetService("PrototypeShopService")
    local nativeUI, screenInstance = self.UIManager:ScanNativeUI(self.Config.UI.TargetName, self.Config.UI.Components)

    if nativeUI then
        self.Logger:Info("SHOP", "✅ Native UI Found")
        self.NativeUI = nativeUI
        self.UIManager:RegisterScreen("ShopMain", screenInstance)
        self:_bindNativeEvents()
    else
        self.Logger:Warn("SHOP", "⚠️ Fallback Triggered")
        self.UseFallback = true
        local View = require(script.Parent.Views.ClientView)
        View.CreateFallback(self.Config, {
            IsVisible = self.IsVisible,
            OnBuy = function() self:_requestBuy() end
        })
    end

    self.UIManager:RegisterTopbar("PrototypeShop", self.Config.Topbar)

    -- [UPDATE] Gunakan state dari event
    self.UIManager.OnTopbarClick:Connect(function(id, state)
        if id == "PrototypeShop" then
            self:_setShopState(state)
        end
    end)
end

function ShopController:_setShopState(state)
    if self.UseFallback then
        self.IsVisible:set(state)
    else
        self.UIManager:ToggleScreen("ShopMain", state)
    end
end

function ShopController:_requestBuy()
    self.Service:BuyItem({ itemId = "Sword", amount = 1 })
end

function ShopController:_bindNativeEvents()
    if self.NativeUI.BuyButton then
        self.NativeUI.BuyButton.MouseButton1Click:Connect(function() self:_requestBuy() end)
    end
    if self.NativeUI.CloseButton then
        self.NativeUI.CloseButton.MouseButton1Click:Connect(function() 
            -- Close cuma matikan visual, icon state mungkin perlu diupdate manual 
            -- Tapi TopbarPlus usually handles toggle off if clicked again.
            -- Untuk simplifikasi, kita sembunyikan UI saja.
            self:_setShopState(false) 
        end)
    end
end
return ShopController
