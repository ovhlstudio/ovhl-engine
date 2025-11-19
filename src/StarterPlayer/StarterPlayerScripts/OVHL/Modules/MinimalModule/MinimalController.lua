local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local MinimalController = Knit.CreateController { Name = "MinimalController" }

function MinimalController:KnitInit()
	self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
	self.UIManager = self.OVHL.GetSystem("UIManager")
	self.UIEngine = self.OVHL.GetSystem("UIEngine")
	self.Config = self.OVHL.GetClientConfig("MinimalModule")
	self._setup = false
end

function MinimalController:KnitStart()
	if self._setup then return end
	self._setup = true

	-- 1. Setup Screen
	pcall(function() 
		local s = self.UIEngine:CreateScreen("MinimalMain", self.Config) 
		self.UIManager:RegisterScreen("MinimalMain", s)
	end)

	-- 2. Register Visual Button (Gak pake callback disini)
	self.UIManager:SetupTopbar("MinimalModule", self.Config)

	-- 3. LISTEN TO EVENT (Ini kuncinya!)
	self.UIManager.OnTopbarClick:Connect(function(clickedId)
		-- Filter: Cuma bereaksi kalau ID-nya "MinimalModule"
		if clickedId == "MinimalModule" then
			print("👋 HELLO MODULE: My button was clicked! Toggling UI.")
			self.UIManager:ToggleScreen("MinimalMain")
		end
	end)
end
return MinimalController
