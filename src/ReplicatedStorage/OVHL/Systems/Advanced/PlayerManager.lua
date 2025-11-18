--[[
OVHL FRAMEWORK V.1.0.1
@Component: @Component: PlayerManager (Core System) (Standard)
@Path: ReplicatedStorage.OVHL.Systems/Advanced/PlayerManager
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
	local OVHL = require(script.Parent.Parent.Parent.Core.OVHL)
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

    -- [PHASE 2 FIX] Load Data dengan handling error
	local data = self._dataManager:LoadData(player)

	if data then
		self._logger:Info("PLAYERMANAGER", "Data siap.", { player = player.Name })
	else
        -- [CRITICAL] Jika data gagal load total (setelah retry), Kick player untuk mencegah data loss/overwrite
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
