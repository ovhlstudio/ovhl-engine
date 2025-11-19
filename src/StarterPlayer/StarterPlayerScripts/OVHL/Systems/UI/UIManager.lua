--[[
	OVHL FRAMEWORK V.1.3.0 - UI MANAGER (EVENT DRIVEN)
	@Component: UIManager (UI)
	@Architecture: Centralized Event Dispatcher (No more closure passing)
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local UIManager = {}
UIManager.__index = UIManager

-- Simple Signal Implementation (Biar gak perlu dependency luar)
local function CreateSignal()
	local sig = {}
	local callbacks = {}
	function sig:Connect(fn)
		table.insert(callbacks, fn)
		return { Disconnect = function() 
			for i,f in ipairs(callbacks) do if f == fn then table.remove(callbacks, i) end end 
		end }
	end
	function sig:Fire(...)
		for _, fn in ipairs(callbacks) do task.spawn(fn, ...) end
	end
	return sig
end

function UIManager.new()
	local self = setmetatable({}, UIManager)
	self._logger = nil
	self._screens = {}
	self._adapter = nil
	self._setupComplete = false
	
	-- [NEW ARCHITECTURE] CENTRAL EVENT BUS
	self.OnTopbarClick = CreateSignal() 
	
	return self
end

function UIManager:Initialize(logger)
	self._logger = logger
	local success, cfg = pcall(function() return require(ReplicatedStorage.OVHL.Config.EngineConfig) end)
	self._adapterName = (success and cfg.Adapters and cfg.Adapters.Navbar) or "InternalAdapter"
	self._logger:Info("UIMANAGER", "Init V1.3 (Event Driven)", {navbar = self._adapterName})
end

function UIManager:Start()
	if self._setupComplete then return end
	self._setupComplete = true

	local folder = ReplicatedStorage.OVHL.Systems.Adapters.Navbar
	local mod = folder:FindFirstChild(self._adapterName)
	if mod then
		local cls = require(mod)
		self._adapter = cls.new()
		if self._adapter.Initialize then self._adapter:Initialize(self._logger) end
		
		-- [CRITICAL] Sambungkan Adapter ke Event Bus kita
		if self._adapter.SetClickHandler then
			self._adapter:SetClickHandler(function(buttonId)
				self._logger:Debug("UIMANAGER", "📣 Dispatching Click Event", {id=buttonId})
				self.OnTopbarClick:Fire(buttonId)
			end)
		end
	end
end

-- Setup Topbar sekarang CUMA REGISTER VISUAL. Gak nerima fungsi klik.
function UIManager:SetupTopbar(moduleName, providedConfig)
	local OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
	local fullConfig = providedConfig or OVHL.GetClientConfig(moduleName)

	if not fullConfig then return false end
	local topbarConfig = fullConfig.Topbar or (fullConfig.UI and fullConfig.UI.Topbar)
    if not topbarConfig and providedConfig and providedConfig.Icon then topbarConfig = providedConfig end

	if not topbarConfig or not topbarConfig.Enabled then return nil end

	if self._adapter then
		-- Kita kirim ID sebagai 'moduleName'. Adapter akan balikin ID ini saat diklik.
		local success = self._adapter:AddButton(moduleName, topbarConfig)
		if success then
			self._logger:Info("UIMANAGER", "✅ Topbar Registered", {id=moduleName})
		end
		return success
	end
	return false
end

-- Standard Screen Logic
function UIManager:RegisterScreen(n, i) self._screens[n] = {Instance=i, Enabled=false} end
function UIManager:ToggleScreen(n)
	local s = self._screens[n]
	if s then s.Instance.Enabled = not s.Instance.Enabled end
end
function UIManager:FindComponent(n, c)
	local s = self._screens[n]
	return s and s.Instance:FindFirstChild(c, true) or nil
end
function UIManager:BindEvent(c, e, f) if c then c[e]:Connect(f) return true end return false end

return UIManager
