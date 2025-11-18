--[[
OVHL ENGINE V3.3.0 (FINAL)
@Component: PlayerManager (Core System)
@Path: ReplicatedStorage.OVHL.Systems.Advanced.PlayerManager
@Purpose: (V3.3.0) Menggunakan Two-Phase Init. :Start() untuk koneksi Event. Menghapus task.wait().
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

-- FASE 1: Hanya konstruksi dan referensi
function PlayerManager:Initialize(logger)
    self._logger = logger
    
    local OVHL = require(script.Parent.Parent.Parent.Core.OVHL)
    self._dataManager = OVHL:GetSystem("DataManager")
end

-- FASE 2: Aktivasi (Koneksi Event & Studio Loop)
function PlayerManager:Start()
    if not self._dataManager then
        self._logger:Critical("PLAYERMANAGER", "GAGAL mendapatkan DataManager! Sistem data tidak akan berjalan.")
        return
    end
    
    self:_connectEvents()
    self._logger:Info("PLAYERMANAGER", "Player Manager Ready. Mendengarkan event Player.")

    -- [FIX V3.3.0] Handle players yang sudah join (Studio testing)
    -- Ini sekarang 100% aman karena :Start() berjalan di Fase 2
    for _, player in ipairs(Players:GetPlayers()) do
        task.spawn(function()
            self:_onPlayerAdded(player)
        end)
    end
end

function PlayerManager:_connectEvents()
    self._connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
        self:_onPlayerAdded(player)
    end)
    
    self._connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
        self:_onPlayerRemoving(player)
    end)
    
    game:BindToClose(function()
        self:_onGameClose()
    end)
end

function PlayerManager:_onPlayerAdded(player)
    self._logger:Info("PLAYERMANAGER", "Player Joining...", {player = player.Name, userId = player.UserId})
    
    -- Validasi ini (dari Claude) tetap bagus
    if not self._dataManager then
        self._logger:Critical("PLAYERMANAGER", "DataManager is nil during PlayerAdded!", { player = player.Name })
        return
    end
    
    local data = self._dataManager:LoadData(player)
    
    if data then
        self._logger:Info("PLAYERMANAGER", "Data siap untuk player.", {player = player.Name})
    else
        self._logger:Error("PLAYERMANAGER", "Data GAGAL di-load untuk player.", {player = player.Name})
    end
end

function PlayerManager:_onPlayerRemoving(player)
    self._logger:Info("PLAYERMANAGER", "Player Leaving...", {player = player.Name, userId = player.UserId})
    
    if not self._dataManager then
        self._logger:Error("PLAYERMANAGER", "DataManager is nil! Cannot save data.", { player = player.Name })
        return
    end
    
    local success = self._dataManager:SaveData(player)
    
    if success then
        self._logger:Info("PLAYERMANAGER", "Data player berhasil di-save.", {player = player.Name})
    else
        self._logger:Error("PLAYERMANAGER", "Data player GAGAL di-save!", {player = player.Name})
    end
    
    self._dataManager:ClearCache(player)
end

function PlayerManager:_onGameClose()
    self._logger:Info("PLAYERMANAGER", "Game Closing. Menyimpan data semua pemain...")
    for _, player in ipairs(Players:GetPlayers()) do
        pcall(function()
            self:_onPlayerRemoving(player)
        end)
    end
end

return PlayerManager

--[[
@End: PlayerManager.lua
@Version: 3.3.0 (Two-Phase Init)
@See: docs/ADR_V3-3-0.md
--]]
