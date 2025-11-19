cat << 'EOF' > src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypeShop/PrototypeShopController.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local PrototypeShopController = Knit.CreateController { Name = "PrototypeShopController" }

function PrototypeShopController:KnitInit()
	self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
	self.Logger = self.OVHL.GetSystem("SmartLogger")
	self.UIManager = self.OVHL.GetSystem("UIManager")
	self.UIEngine = self.OVHL.GetSystem("UIEngine")
	self.Config = self.OVHL.GetClientConfig("PrototypeShop")
	self._setup = false
end

function PrototypeShopController:KnitStart()
	if self._setup then return end
	self._setup = true
	self.Service = Knit.GetService("PrototypeShopService")

	-- 1. Setup Screen (Hidden)
	self:SetupUI() 

	-- 2. Register Visual Button (Pake Config, gak pake fungsi)
	self.UIManager:SetupTopbar("PrototypeShop", self.Config)

	-- 3. LISTEN TO EVENT (Filter ID Unik)
	self.UIManager.OnTopbarClick:Connect(function(clickedId)
		-- Cek apakah yang diklik itu "PrototypeShop"?
		if clickedId == "PrototypeShop" then
			self.Logger:Info("SHOP", "🛒 SHOP MODULE: Button click received. Opening Shop.")
			self.UIManager:ToggleScreen("ShopMain")
		end
	end)
end

function PrototypeShopController:SetupUI()
	-- (Kode SetupUI visual sama kayak sebelumnya, dipersingkat disini)
	local s = self.UIEngine:CreateScreen("ShopMain", self.Config)
	if s then
		s.Enabled = false
		local f = Instance.new("Frame", s)
		f.Size = UDim2.new(0,300,0,200)
		f.Position = UDim2.new(0.5,-150,0.5,-100)
		f.BackgroundColor3 = Color3.fromRGB(30,30,30)
		local t = Instance.new("TextLabel", f)
		t.Text = "SHOP V1.3"; t.Size = UDim2.new(1,0,1,0); t.TextColor3 = Color3.new(1,1,1)
		self.UIManager:RegisterScreen("ShopMain", s)
	end
end

return PrototypeShopController
EOF