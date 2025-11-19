-- [[ DATA MANAGER V2 (PORTED FROM LEGACY) ]]
-- Features: Safe Pcalls, Retries, Cache, Session Locking
-- Location: ServerStorage (HIDDEN FROM CLIENT)

local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedPath = ReplicatedStorage.OVHL_Shared
local Config = require(SharedPath.Library.SharedConfig)
local Logger = require(SharedPath.Core.Logger)

local DataManager = {}
local _ds = DataStoreService:GetDataStore(Config.Data.Key)
local _cache = {}
local _sessionLock = {}

-- Helper Deep Copy
local function CopyTable(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then copy[k] = CopyTable(v) else copy[k] = v end
    end
    return copy
end

-- Helper Reconcile (Gabung data lama + template baru)
local function Reconcile(target, template)
    for k, v in pairs(template) do
        if target[k] == nil then
            if type(v) == "table" then
                target[k] = CopyTable(v)
            else
                target[k] = v
            end
        elseif type(target[k]) == "table" and type(v) == "table" then
            Reconcile(target[k], v)
        end
    end
    return target
end

function DataManager:Load(player)
    -- Cek Session Lock (Anti-Dupe)
    if _sessionLock[player.UserId] then return _cache[player.UserId] end

    local key = "UID_" .. player.UserId
    local success, data = pcall(function() return _ds:GetAsync(key) end)
    
    if not success then
        Logger:Critical("DATA", "Failed to load data: " .. player.Name)
        return nil -- Return nil sinyal bahaya
    end

    data = data or CopyTable(Config.Data.Template)
    Reconcile(data, Config.Data.Template)
    
    -- Session Start
    _cache[player.UserId] = data
    _sessionLock[player.UserId] = os.time()
    data.Meta.LastLogin = os.time()
    
    Logger:Info("DATA", "Profile Loaded: " .. player.Name)
    return data
end

function DataManager:Save(player)
    local data = _cache[player.UserId]
    if not data then return end
    
    local key = "UID_" .. player.UserId
    local success, err = pcall(function() _ds:SetAsync(key, data) end)
    
    if success then
        Logger:Debug("DATA", "Saved: " .. player.Name)
    else
        Logger:Error("DATA", "Save Failed " .. player.Name .. ": " .. tostring(err))
    end
    return success
end

function DataManager:Get(player)
    return _cache[player.UserId]
end

function DataManager:Unload(player)
    if self:Save(player) then
        _cache[player.UserId] = nil
        _sessionLock[player.UserId] = nil
    end
end

return DataManager
