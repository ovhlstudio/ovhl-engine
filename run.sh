#!/bin/bash
set -e

echo "🛠️ [OVHL ARCHITECT] Finalizing V1.1.0 Wiring (Absolute Paths)..."

# 1. FIX NOTIFICATION SERVICE (SERVER)
# Masalah: Relative path ke Core putus karena pindah ke SSS.
echo "🔧 Rewiring NotificationService.lua (V1.1.0)..."
cat << 'EOF' > src/ServerScriptService/OVHL/Systems/Advanced/NotificationService.lua
--[[
OVHL FRAMEWORK V.1.1.0
@Component: NotificationService (Core System)
@Path: ServerScriptService.OVHL.Systems.Advanced.NotificationService
@Purpose: Menyediakan API terpusat untuk mengirim notifikasi (Toast, UI) ke client.
--]]

local NotificationService = {}
NotificationService.__index = NotificationService

function NotificationService.new()
    local self = setmetatable({}, NotificationService)
    self._logger = nil
    self._router = nil
    return self
end

function NotificationService:Initialize(logger)
    self._logger = logger
    
    -- [V1.1.0 ARCHITECTURE FIX] ABSOLUTE PATH
    local OVHL = require(game:GetService("ReplicatedStorage").OVHL.Core.OVHL)
    self._router = OVHL.GetSystem("NetworkingRouter") 
    
    if not self._router then
        self._logger:Error("NOTIFICATION", "Gagal mendapatkan NetworkingRouter!")
        return
    end
    
    self._logger:Info("NOTIFICATION", "Notification Service Ready (Server API).")
end

function NotificationService:SendToPlayer(player, message, icon, duration)
    if not self._router then return end
    
    self._router:SendToClient(player, "OVHL.Notification.Show", {
        Message = message,
        Icon = icon or "Info",
        Duration = duration or 5
    })
end

function NotificationService:SendToAll(message, icon, duration)
    if not self._router then return end
    self._logger:Warn("NOTIFICATION", "SendToAll belum diimplementasi di router.")
end

return NotificationService
EOF

# 2. FIX PLAYER MANAGER (SERVER)
# Masalah: Relative path ke Core putus (Prevention).
echo "🔧 Rewiring PlayerManager.lua (V1.1.0)..."
cat << 'EOF' > src/ServerScriptService/OVHL/Systems/Advanced/PlayerManager.lua
--[[
OVHL FRAMEWORK V.1.1.0
@Component: PlayerManager (Core System)
@Path: ServerScriptService.OVHL.Systems.Advanced.PlayerManager
@Purpose: Player Lifecycle with Safe Data Handling
--]]

local Players = game:GetService("Players")
local PlayerManager = {}
PlayerManager.__index = PlayerManager

function PlayerManager.new()
	local self = setmetatable({}, PlayerManager)
	self._logger = nil
	self._dataManager = nil
	self._connections = {}
	return self
end

function PlayerManager:Initialize(logger)
	self._logger = logger
end

function PlayerManager:Start()
    -- [V1.1.0 ARCHITECTURE FIX] ABSOLUTE PATH
	local OVHL = require(game:GetService("ReplicatedStorage").OVHL.Core.OVHL)
	self._dataManager = OVHL.GetSystem("DataManager")

	if not self._dataManager then
		self._logger:Critical("PLAYERMANAGER", "GAGAL mendapatkan DataManager!")
		return
	end

	self:_connectEvents()
	self._logger:Info("PLAYERMANAGER", "Player Manager Ready.")

	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(function() self:_onPlayerAdded(player) end)
	end
end

function PlayerManager:Destroy()
	self._logger:Info("PLAYERMANAGER", "Shutdown: Saving data...")
	self:_onGameClose()
	for _, connection in pairs(self._connections) do
		pcall(function() connection:Disconnect() end)
	end
	self._connections = {}
end

function PlayerManager:_connectEvents()
	self._connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
		self:_onPlayerAdded(player)
	end)
	self._connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
		self:_onPlayerRemoving(player)
	end)
end

function PlayerManager:_onPlayerAdded(player)
	self._logger:Info("PLAYERMANAGER", "Player Joining...", { player = player.Name })

	if not self._dataManager then return end

	local data = self._dataManager:LoadData(player)

	if data then
		self._logger:Info("PLAYERMANAGER", "Data siap.", { player = player.Name })
	else
		self._logger:Critical("PLAYERMANAGER", "DATA LOAD GAGAL TOTAL! Kicking player untuk keamanan.", { player = player.Name })
        player:Kick("⚠️ OVHL Security: Gagal memuat data profil Anda. Silakan rejoin.")
	end
end

function PlayerManager:_onPlayerRemoving(player)
	self._logger:Info("PLAYERMANAGER", "Player Leaving...", { player = player.Name })
	if not self._dataManager then return end

	local success = self._dataManager:SaveData(player)
	self._dataManager:ClearCache(player)
end

function PlayerManager:_onGameClose()
	for _, player in ipairs(Players:GetPlayers()) do
		self:_onPlayerRemoving(player)
	end
end

return PlayerManager
EOF

# 3. FIX UI MANAGER (CLIENT)
# Masalah: Relative path ke Adapters putus karena pindah ke PlayerScripts.
echo "🔧 Rewiring UIManager.lua (V1.1.0)..."
cat << 'EOF' > src/StarterPlayer/StarterPlayerScripts/OVHL/Systems/UI/UIManager.lua
--[[
OVHL FRAMEWORK V.1.1.0
@Component: UIManager (UI)
@Path: StarterPlayer.StarterPlayerScripts.OVHL.Systems.UI.UIManager
@Purpose: Screen lifecycle & Adapter-based Navbar management
--]]

local UIManager = {}
UIManager.__index = UIManager

function UIManager.new()
    local self = setmetatable({}, UIManager)
    self._logger = nil
    self._screens = {}
    self._eventBindings = {}
    self._adapter = nil
    self._fallbackAdapter = nil
    self._adapterName = nil
    return self
end

function UIManager:Initialize(logger)
    self._logger = logger
    -- [V1.1.0 ARCHITECTURE FIX] ABSOLUTE PATH
    local success, cfg = pcall(function() return require(game:GetService("ReplicatedStorage").OVHL.Config.EngineConfig) end)
    self._adapterName = (success and cfg.Adapters and cfg.Adapters.Navbar) or "InternalAdapter"
    self._logger:Info("UIMANAGER", "Init", {navbar = self._adapterName})
end

function UIManager:Start()
    -- [V1.1.0 ARCHITECTURE FIX] ABSOLUTE PATH TO SHARED ADAPTERS
    local folder = game:GetService("ReplicatedStorage").OVHL.Systems.Adapters.Navbar
    
    local mod = folder:FindFirstChild(self._adapterName)
    if mod then
        local cls = require(mod)
        self._adapter = cls.new()
        if self._adapter.Initialize then self._adapter:Initialize(self._logger) end
    end
    local fallbackMod = folder:FindFirstChild("InternalAdapter")
    if fallbackMod then
        local cls = require(fallbackMod)
        self._fallbackAdapter = cls.new()
        if self._fallbackAdapter.Initialize then self._fallbackAdapter:Initialize(self._logger) end
    end
end

function UIManager:RegisterScreen(screenName, screenInstance)
    self._screens[screenName] = { Instance = screenInstance, Enabled = false }
    self._logger:Debug("UIMANAGER", "Screen registered", {name=screenName})
end

function UIManager:ShowScreen(screenName)
    local s = self._screens[screenName]
    if s then 
        s.Instance.Enabled = true
        s.Enabled = true 
        self._logger:Debug("UIMANAGER", "Show Screen", {name=screenName})
        return true 
    end
    self._logger:Warn("UIMANAGER", "Show failed: Screen not found", {name=screenName})
    return false
end

function UIManager:HideScreen(screenName)
    local s = self._screens[screenName]
    if s then 
        s.Instance.Enabled = false
        s.Enabled = false 
        return true 
    end
    return false
end

function UIManager:ToggleScreen(screenName)
    local s = self._screens[screenName]
    if not s then 
        self._logger:Warn("UIMANAGER", "Toggle failed: Screen not found", {name=screenName})
        return false 
    end
    if s.Enabled then return self:HideScreen(screenName) else return self:ShowScreen(screenName) end
end

function UIManager:SetupTopbar(moduleName, _ignoredConfig, explicitOnClick)
    -- [V1.1.0 ARCHITECTURE FIX] ABSOLUTE PATH
    local OVHL = require(game:GetService("ReplicatedStorage").OVHL.Core.OVHL)
    local fullConfig = OVHL.GetClientConfig(moduleName)
    
    if not fullConfig then
        self._logger:Warn("UIMANAGER", "Gagal load config untuk Topbar", {module=moduleName})
        return false
    end
    
    local topbarConfig = fullConfig.Topbar or (fullConfig.UI and fullConfig.UI.Topbar)
    
    if not topbarConfig or not topbarConfig.Enabled then 
        return nil 
    end

    if explicitOnClick then
        topbarConfig.OnClick = explicitOnClick
    elseif not topbarConfig.OnClick then
         self._logger:Warn("UIMANAGER", "Topbar setup without OnClick handler", {module=moduleName})
         return false
    end
    
    local success = false
    if self._adapter then
        success = self._adapter:AddButton(moduleName, topbarConfig)
    end
    
    if not success then
        if self._fallbackAdapter then
            self._logger:Warn("UIMANAGER", "Main Adapter failed, using Fallback", {module=moduleName})
            success = self._fallbackAdapter:AddButton(moduleName, topbarConfig)
        else
            self._logger:Critical("UIMANAGER", "No Navbar Adapter available!")
        end
    end
    
    return success
end

function UIManager:FindComponent(screenName, componentName)
    local s = self._screens[screenName]
    if not s then return nil end
    return s.Instance:FindFirstChild(componentName, true)
end

function UIManager:BindEvent(component, eventName, callback)
    if not component then return false end
    component[eventName]:Connect(callback)
    return true
end

return UIManager
EOF

echo "✅ V1.1.0 ARCHITECTURE FIXED & LOCKED."