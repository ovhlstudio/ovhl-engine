--[[ @Component: DataManager (Server) ]]
local DSS = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local DataManager = {}
DataManager.__index = DataManager

function DataManager.New() 
    local self = setmetatable({}, DataManager)
    self._store = DSS:GetDataStore("OVHL_V2_DATA")
    self._cache = {}
    return self
end

function DataManager:Init(ctx)
    self.Logger = ctx.Logger
    
    -- Auto Load/Save Lifecycle
    Players.PlayerAdded:Connect(function(p) self:Load(p) end)
    Players.PlayerRemoving:Connect(function(p) self:Save(p, true) end)
    
    game:BindToClose(function()
        for _, p in ipairs(Players:GetPlayers()) do self:Save(p, true) end
    end)
end

function DataManager:Start() end

function DataManager:Load(player)
    local key = tostring(player.UserId)
    local s, data = pcall(function() return self._store:GetAsync(key) end)
    
    if s then
        self._cache[player] = data or {Coins=0, Inventory={}} -- Default Data
        self.Logger:Info("DATA", "Loaded", {Player=player.Name})
    else
        self.Logger:Error("DATA", "Load Failed", {Player=player.Name, Err=data})
        -- Kick prevention logic could go here
    end
end

function DataManager:Save(player, cleanup)
    local data = self._cache[player]
    if not data then return end
    
    local key = tostring(player.UserId)
    local s, err = pcall(function() self._store:SetAsync(key, data) end)
    
    if not s then self.Logger:Error("DATA", "Save Failed", {Player=player.Name, Err=err}) end
    if cleanup then self._cache[player] = nil end
end

function DataManager:Get(player) return self._cache[player] end
function DataManager:Update(player, cb) 
    if self._cache[player] then self._cache[player] = cb(self._cache[player]) end 
end

return DataManager
