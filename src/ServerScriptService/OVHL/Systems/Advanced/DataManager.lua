--[[
OVHL FRAMEWORK V.1.0.1
@Component: @Component: DataManager (Core System) (Standard)
@Path: ReplicatedStorage.OVHL.Systems.Advanced.DataManager
@Purpose: Data Management with Safe Timeout Handling
--]]

local DataStoreService = game:GetService("DataStoreService")

local DataManager = {}
DataManager.__index = DataManager
local DEFAULT_DS = "OVHL_PlayerDatav3"

function DataManager.new()
    local self = setmetatable({}, DataManager)
    self._logger = nil
    self._ds = nil
    self._cache = {}
    self._init = false
    return self
end

function DataManager:Initialize(logger)
    self._logger = logger
end

function DataManager:Start()
    local success, ds = pcall(function() return DataStoreService:GetDataStore(DEFAULT_DS) end)
    if success then
        self._ds = ds
        self._init = true
        if self._logger then self._logger:Info("DATAMANAGER", "Ready") end
    else
        if self._logger then self._logger:Critical("DATAMANAGER", "DataStore Connect Fail") end
    end
end

function DataManager:_waitForInit()
    if self._init then return true end
    local start = os.clock()
    while not self._init do
        if os.clock() - start > 10 then return false end
        task.wait(0.1)
    end
    return true
end

function DataManager:LoadData(player)
    if not self:_waitForInit() then
        -- [HOTFIX] Check logger existence before using
        if self._logger then 
            self._logger:Critical("DATAMANAGER", "Timeout waiting for init", {player=player.Name})
        else
            warn("[DATAMANAGER] CRITICAL TIMEOUT (Logger nil): " .. player.Name)
        end
        return nil
    end
    
    local key = "Player_" .. player.UserId
    local success, data = pcall(function() return self._ds:GetAsync(key) end)
    
    if not success then
        if self._logger then self._logger:Error("DATAMANAGER", "Load Failed", {err=tostring(data)}) end
        return nil
    end
    
    data = data or self:_createDefault(player)
    self._cache[player.UserId] = data
    if self._logger then self._logger:Info("DATAMANAGER", "Loaded", {player=player.Name}) end
    return data
end

function DataManager:SaveData(player)
    if not self:_waitForInit() or not self._cache[player.UserId] then return false end
    local key = "Player_" .. player.UserId
    local data = self._cache[player.UserId]
    data.meta.lastSave = os.time()
    
    local success, err = pcall(function() self._ds:SetAsync(key, data) end)
    if not success and self._logger then
         self._logger:Error("DATAMANAGER", "Save Failed", {err=tostring(err)})
    end
    return success
end

function DataManager:ClearCache(player) self._cache[player.UserId] = nil end
function DataManager:GetCachedData(player) return self._cache[player.UserId] end

function DataManager:_createDefault(player)
    return {
        meta = { userId = player.UserId, joinDate = os.time() },
        currency = { coins = 100, gems = 0 },
        inventory = {},
        stats = { level = 1, xp = 0 }
    }
end

return DataManager
