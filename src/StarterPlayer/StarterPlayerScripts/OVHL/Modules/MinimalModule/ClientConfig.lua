--[[
OVHL ENGINE V3.0.0
@Component: MinimalController (DEBUG VERSION)
@Path: StarterPlayer.StarterPlayerScripts.OVHL.Modules.MinimalModule.MinimalController
@Purpose: Debug version with full tracing
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local MinimalController = Knit.CreateController({ Name = "MinimalController" })

-- Debug counters
local setupTopbarCallCount = 0
local setupUICallCount = 0
local setupInputCallCount = 0

function MinimalController:KnitInit()
	print("[TRACE-INIT] MinimalController:KnitInit() called")

	self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
	self.Logger = self.OVHL.GetSystem("SmartLogger")
	self.Config = self.OVHL.GetClientConfig("MinimalModule")
	self.UIEngine = self.OVHL.GetSystem("UIEngine")
	self.UIManager = self.OVHL.GetSystem("UIManager")
	self.AssetLoader = self.OVHL.GetSystem("AssetLoader")
	self.Service = Knit.GetService("MinimalService")

	self.Logger:Info("SERVICE", "[INIT] MinimalController KnitInit complete")
end

function MinimalController:KnitStart()
	print("[TRACE-START] MinimalController:KnitStart() called")
	print(debug.traceback("[STACK]"))

	self.Logger:Info("SERVICE", "[START] MinimalController KnitStart beginning")

	self:SetupUI()
	self:SetupInput()
	self:SetupTopbar()

	self.Logger:Info("SERVICE", "[START] MinimalController KnitStart complete")
end

function MinimalController:SetupUI()
	setupUICallCount = setupUICallCount + 1
	print("[TRACE-UI] SetupUI call #" .. setupUICallCount .. " at " .. os.time())

	-- Explicit Name: MinimalMain
	local success, mainScreen = pcall(function()
		return self.UIEngine:CreateScreen("MinimalMain", self.Config)
	end)

	if success and mainScreen then
		self.Logger:Debug("UI", "[SETUP-UI] Screen created: MinimalMain")
		self.UIManager:RegisterScreen("MinimalMain", mainScreen)
		self:_setupUIComponents(mainScreen)
	else
		self.Logger:Error("UI", "[FAIL] Failed to create MinimalMain screen", { error = tostring(mainScreen) })
	end
end

function MinimalController:_setupUIComponents(screen)
	self.Logger:Debug("UI", "[COMPONENTS] Setting up UI components for MinimalMain")

	local actionBtn = self.UIManager:FindComponent("MinimalMain", "ActionButton")
	if actionBtn then
		self.UIManager:BindEvent(actionBtn, "Activated", function()
			self.Logger:Debug("UI", "[CLICK] ActionButton clicked")
			self:DoClientAction({ action = "test", data = { type = "click" } })
		end)
	else
		self.Logger:Warn("UI", "[MISSING] ActionButton not found in MinimalMain")
	end
end

function MinimalController:SetupInput()
	setupInputCallCount = setupInputCallCount + 1
	print("[TRACE-INPUT] SetupInput call #" .. setupInputCallCount .. " at " .. os.time())

	if self.Config.Input and self.Config.Input.Keybinds and self.Config.Input.Keybinds.ToggleUI then
		self.Logger:Debug("INPUT", "[KEYBIND] Registering toggle keybind")
		self.AssetLoader:RegisterKeybind(self.Config.Input.Keybinds.ToggleUI, function()
			self:ToggleMainUI()
		end, { triggerOnPress = true })
	else
		self.Logger:Warn("INPUT", "[MISSING] Keybind config not found")
	end
end

function MinimalController:SetupTopbar()
	setupTopbarCallCount = setupTopbarCallCount + 1

	print("\n" .. string.rep("=", 60))
	print("[TRACE-TOPBAR] SetupTopbar call #" .. setupTopbarCallCount .. " at " .. os.time())
	print("[TRACE-TOPBAR] FULL STACK TRACE:")
	print(debug.traceback())
	print(string.rep("=", 60) .. "\n")

	self.Logger:Info("SERVICE", "[TOPBAR-CALL] SetupTopbar invoked", {
		callNumber = setupTopbarCallCount,
		timestamp = os.time(),
	})

	-- PASS EXPLICIT ONCLICK FUNCTION TO AVOID AMBIGUITY
	local success, result = pcall(function()
		return self.UIManager:SetupTopbar("MinimalModule", self.Config, function()
			self:ToggleMainUI()
		end)
	end)

	if success then
		self.Logger:Info("SERVICE", "[TOPBAR-SUCCESS] SetupTopbar completed", {
			callNumber = setupTopbarCallCount,
			result = tostring(result),
		})
	else
		self.Logger:Error("SERVICE", "[TOPBAR-ERROR] SetupTopbar failed", {
			callNumber = setupTopbarCallCount,
			error = tostring(result),
		})
	end
end

function MinimalController:ToggleMainUI()
	print("[TRACE-TOGGLE] ToggleMainUI called at " .. os.time())
	self.Logger:Debug("UI", "[TOGGLE] Toggling MinimalMain visibility")
	self.UIManager:ToggleScreen("MinimalMain")
end

function MinimalController:DoClientAction(data)
	print("[TRACE-ACTION] DoClientAction called with: " .. tostring(data.action))
	self.Logger:Debug("BUSINESS", "[ACTION] Client action requested", { action = data.action })

	if self.Service then
		self.Service:DoAction(data)
	else
		self.Logger:Error("BUSINESS", "[FAIL] Service not available")
	end
end

-- Debug function to check call counts
function MinimalController:GetDebugStats()
	return {
		setupUICallCount = setupUICallCount,
		setupInputCallCount = setupInputCallCount,
		setupTopbarCallCount = setupTopbarCallCount,
	}
end

return MinimalController
