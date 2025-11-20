--[[ @Component: DataManager (Singleton - V11 Fixed) ]]
local DSS = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local Service = {}

-- Setup DataStore Constants
local STORE_KEY = "OVHL_V2_DATA"
local DATA_STORE = DSS:GetDataStore(STORE_KEY)

function Service:Init(ctx)
    self.Logger = ctx.Logger
    -- [FIX] Initialize Storage di Init, bukan di New
    self._cache = {} 
    
    -- Setup Default Data Schema
    self.DefaultData = {
        Coins = 0,
        Inventory = {},
        XP = 0,
        Level = 1
    }
    
    -- Lifecycle Hooks
    Players.PlayerAdded:Connect(function(p) self:Load(p) end)
    Players.PlayerRemoving:Connect(function(p) self:Save(p, true) end)
    
    game:BindToClose(function()
        for _, p in ipairs(Players:GetPlayers()) do self:Save(p, true) end
        task.wait(2) -- Kasih waktu buat saving
    end)
    
    self.Logger:Info("DATA", "DataManager Singleton Initialized")
end

function Service:Start()
    -- Any async startup tasks
end

function Service:Load(player)
    local key = tostring(player.UserId)
    
    -- Retry Logic Sederhana
    local attempts = 0
    local success, data
    
    repeat
        success, data = pcall(function() return DATA_STORE:GetAsync(key) end)
        attempts = attempts + 1
        if not success then task.wait(1) end
    until success or attempts > 3
    
    if success then
        -- Reconcile Data (Gabung data saved + data baru di struct kalau ada update)
        data = data or {}
        for k,v in pairs(self.DefaultData) do
            if data[k] == nil then data[k] = v end
        end
        
        self._cache[player] = data
        self.Logger:Info("DATA", "Loaded Profile", {Player=player.Name})
    else
        self.Logger:Error("DATA", "FAILED TO LOAD", {Player=player.Name, Err=data})
        -- Kick player to prevent data overwrites?
        player:Kick("Data Load Error. Please Rejoin.")
    end
end

function Service:Save(player, cleanup)
    if not self._cache then return end -- Safety check pasca-shutdown
    
    local data = self._cache[player]
    if not data then return end
    
    local key = tostring(player.UserId)
    
    local success, err = pcall(function()
        DATA_STORE:SetAsync(key, data)
    end)
    
    if not success then
        self.Logger:Error("DATA", "FAILED TO SAVE", {Player=player.Name, Err=err})
    else
        self.Logger:Debug("DATA", "Saved Profile", {Player=player.Name})
    end
    
    if cleanup then
        self._cache[player] = nil
    end
end

-- Public API
function Service:Get(player)
    return self._cache[player]
end

function Service:Update(player, callback)
    if self._cache[player] then
        local newData = callback(self._cache[player])
        if newData then self._cache[player] = newData end
    end
end

return Service
