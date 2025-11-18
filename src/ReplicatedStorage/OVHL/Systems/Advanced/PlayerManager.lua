--[[
OVHL ENGINE V1.0.0
@Component: PlayerManager (Advanced)
@Path: ReplicatedStorage.OVHL.Systems.Advanced.PlayerManager
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.4.0 (ADR-004)
@Component: PlayerManager (Core System)
@Path: ReplicatedStorage.OVHL.Systems/Advanced/PlayerManager
@Purpose: (V3.4.0) Mematuhi Full Lifecycle.
         1. (ADR-003) Resolusi dependensi dipindah ke :Start() untuk perbaiki race condition.
         2. (ADR-004) Menambahkan :Destroy() untuk cleanup event dan save data.
--]]

local Players = game:GetService("Players")

local PlayerManager = {}
PlayerManager.__index = PlayerManager

function PlayerManager.new()
	local self = setmetatable({}, PlayerManager)
	self._logger = nil
	self._dataManager = nil -- [FIX] Dilarang diisi di Fase 1
	self._connections = {}
	return self
end

-- FASE 1: Hanya konstruksi dan referensi logger
function PlayerManager:Initialize(logger)
	self._logger = logger

	-- [FIX] DILARANG memanggil OVHL:GetSystem() di sini (Ini Bug V3.3.0).
end

-- FASE 3: Aktivasi (Koneksi Event & Resolusi Dependensi)
function PlayerManager:Start()
	-- [FIX V3.4.0] Ambil dependensi di SINI (Fase 3)
	local OVHL = require(script.Parent.Parent.Parent.Core.OVHL)
	self._dataManager = OVHL:GetSystem("DataManager")

	if not self._dataManager then
		self._logger:Critical("PLAYERMANAGER", "GAGAL mendapatkan DataManager! Sistem data tidak akan berjalan.")
		return
	end

	self:_connectEvents()
	self._logger:Info("PLAYERMANAGER", "Player Manager Ready. Mendengarkan event Player.")

	-- [FIX V3.3.0] Handle players yang sudah join (Studio testing)
	-- Ini sekarang 100% aman karena :Start() berjalan di Fase 3
	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(function()
			self:_onPlayerAdded(player)
		end)
	end
end

-- [BARU V3.4.0] FASE 4: Cleanup
function PlayerManager:Destroy()
	self._logger:Info("PLAYERMANAGER", "Fase 4 (Destroy) dipanggil. Menyimpan data & cleanup...")

	-- 1. Paksa save semua data (fungsi ini sudah aman)
	self:_onGameClose()

	-- 2. Disconnect semua event (mencegah memory leak)
	for name, connection in pairs(self._connections) do
		pcall(function()
			connection:Disconnect()
		end)
		self._connections[name] = nil
	end

	self._logger:Info("PLAYERMANAGER", "Koneksi event di-cleanup.")
end

function PlayerManager:_connectEvents()
	self._connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
		self:_onPlayerAdded(player)
	end)

	self._connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
		self:_onPlayerRemoving(player)
	end)

	-- [FIX V3.4.0] Dihapus. Shutdown sekarang diurus oleh SystemRegistry:Shutdown()
	-- game:BindToClose(function()
	--     self:_onGameClose()
	-- end)
end

function PlayerManager:_onPlayerAdded(player)
	self._logger:Info("PLAYERMANAGER", "Player Joining...", { player = player.Name, userId = player.UserId })

	if not self._dataManager then
		self._logger:Critical("PLAYERMANAGER", "DataManager is nil during PlayerAdded!", { player = player.Name })
		return
	end

	local data = self._dataManager:LoadData(player)

	if data then
		self._logger:Info("PLAYERMANAGER", "Data siap untuk player.", { player = player.Name })
	else
		self._logger:Error("PLAYERMANAGER", "Data GAGAL di-load untuk player.", { player = player.Name })
	end
end

function PlayerManager:_onPlayerRemoving(player)
	self._logger:Info("PLAYERMANAGER", "Player Leaving...", { player = player.Name, userId = player.UserId })

	if not self._dataManager then
		self._logger:Error("PLAYERMANAGER", "DataManager is nil! Cannot save data.", { player = player.Name })
		return
	end

	local success = self._dataManager:SaveData(player)

	if success then
		self._logger:Info("PLAYERMANAGER", "Data player berhasil di-save.", { player = player.Name })
	else
		self._logger:Error("PLAYERMANAGER", "Data player GAGAL di-save!", { player = player.Name })
	end

	self._dataManager:ClearCache(player)
end

function PlayerManager:_onGameClose()
	self._logger:Info("PLAYERMANAGER", "Game Closing (dipanggil oleh Destroy). Menyimpan data semua pemain...")
	for _, player in ipairs(Players:GetPlayers()) do
		pcall(function()
			self:_onPlayerRemoving(player)
		end)
	end
end

return PlayerManager

--[[
@End: PlayerManager.lua
@Version: 3.4.0 (ADR-004)
@See: docs/ADR_V3-3-0.md, docs/ADR_V3-4-0.md (Diusulkan)
--]]

--[[
@End: PlayerManager.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

