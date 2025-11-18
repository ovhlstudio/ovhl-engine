--[[
OVHL ENGINE V3.3.0 (FINAL)
@Component: DataManager (Core System)
@Path: ReplicatedStorage.OVHL.Systems.Advanced.DataManager
@Purpose: (V3.3.0) Menggunakan Two-Phase Init. :Start() untuk koneksi DataStore.
--]]

local DataStoreService = game:GetService("DataStoreService")

local DataManager = {}
DataManager.__index = DataManager

local DEFAULT_DATASTORE_NAME = "OVHL_PlayerDatav3"

function DataManager.new()
    local self = setmetatable({}, DataManager)
    self._logger = nil
    self._config = nil
    self._playerDataStore = nil
    self._sessionCache = {}
    self._initialized = false
    return self
end

-- FASE 1: Hanya konstruksi dan referensi
function DataManager:Initialize(logger)
    self._logger = logger
    
    local OVHL = require(script.Parent.Parent.Parent.Core.OVHL)
    local ConfigLoader = OVHL:GetSystem("ConfigLoader")
    self._config = ConfigLoader:LoadEngineConfig()
end

-- FASE 2: Aktivasi (Koneksi ke hardware/servis eksternal)
function DataManager:Start()
    local success, ds = pcall(function()
        return DataStoreService:GetDataStore(DEFAULT_DATASTORE_NAME)
    end)
    
    if success then
        self._playerDataStore = ds
        self._initialized = true
        self._logger:Info("DATAMANAGER", "Data Manager Ready", { DataStore = DEFAULT_DATASTORE_NAME })
    else
        self._logger:Critical("DATAMANAGER", "GAGAL terhubung ke DataStore!", { Error = tostring(ds) })
    end
end

function DataManager:LoadData(player)
    if not self._initialized then
        self._logger:Error("DATAMANAGER", "LoadData dipanggil sebelum DataManager:Start()!", { player = player.Name })
        return nil
    end

    local playerKey = "Player_" .. player.UserId
    local startTime = os.clock()
    local dataStore = self._playerDataStore
    
    local success, data = pcall(function()
        return dataStore:GetAsync(playerKey)
    end)
    
    if not success then
        self._logger:Error("DATAMANAGER", "GetAsync Gagal!", { player = player.Name, error = tostring(data) })
        return nil
    end
    
    self._logger:Performance("TIMING", "Data Loaded", { duration = os.clock() - startTime })

    if data then
        self._sessionCache[player.UserId] = data
        self._logger:Info("DATAMANAGER", "Data berhasil di-load.", { player = player.Name })
        return data
    else
        self._logger:Info("DATAMANAGER", "Membuat data baru (First Join).", { player = player.Name })
        local newData = self:_createDefaultData(player)
        self._sessionCache[player.UserId] = newData
        return newData
    end
end

function DataManager:SaveData(player)
    if not self._initialized then
        self._logger:Error("DATAMANAGER", "SaveData dipanggil sebelum DataManager:Start()!", { player = player.Name })
        return false
    end

    local dataToSave = self._sessionCache[player.UserId]
    if not dataToSave then
        self._logger:Warn("DATAMANAGER", "SaveData Gagal (Data di cache nil)", { player = player.Name })
        return false
    end

    local playerKey = "Player_" .. player.UserId
    local startTime = os.clock()
    local dataStore = self._playerDataStore
    
    local success, err = pcall(function()
        dataToSave.meta.lastSave = os.time()
        dataStore:SetAsync(playerKey, dataToSave)
    end)
    
    if not success then
        self._logger:Error("DATAMANAGER", "SetAsync Gagal!", { player = player.Name, error = tostring(err) })
        return false
    end
    
    self._logger:Performance("TIMING", "Data Saved", { duration = os.clock() - startTime })
    self._logger:Info("DATAMANAGER", "Data berhasil di-save.", { player = player.Name })
    return true
end

function DataManager:ClearCache(player)
    self._sessionCache[player.UserId] = nil
    self._logger:Debug("DATAMANAGER", "Cache dibersihkan.", { player = player.Name })
end

function DataManager:GetCachedData(player)
    return self._sessionCache[player.UserId]
end

function DataManager:_createDefaultData(player)
    return {
        meta = {
            userId = player.UserId,
            joinDate = os.time(),
            lastSave = 0,
            schemaVersion = "1.0.0",
        },
        currency = { coins = 100, gems = 0 },
        inventory = {},
        stats = { level = 1, xp = 0 },
    }
end

return DataManager

--[[
@End: DataManager.lua
@Version: 3.3.0 (Two-Phase Init)
@See: docs/ADR_V3-3-0.md
--]]
