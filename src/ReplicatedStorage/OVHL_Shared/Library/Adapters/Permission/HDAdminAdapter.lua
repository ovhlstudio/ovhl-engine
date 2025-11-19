-- [[ HD ADMIN ADAPTER V2 (FIXED & DETAILED) ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- [FIX] BYPASS INIT.LUA UNTUK HINDARI DEADLOCK
local Shared = ReplicatedStorage:WaitForChild("OVHL_Shared")
local Logger = require(Shared.Core.Logger) 

local HDAdminAdapter = {}
HDAdminAdapter.__index = HDAdminAdapter

function HDAdminAdapter.new()
    return setmetatable({ _api = nil, _cache = {}, _connections = {} }, HDAdminAdapter)
end

-- Helper Log User
local function fmtUser(p)
    return string.format("%s (%d)", p.Name, p.UserId)
end

function HDAdminAdapter:Init()
    -- [[ CLIENT SIDE ]]
    if RunService:IsClient() then
        local p = Players.LocalPlayer
        Logger:Info("PERMISSION", "HDAdminAdapter Listening (Client)")
        
        p:GetAttributeChangedSignal("OVHL_Rank"):Connect(function()
            Logger:Info("PERMISSION", "Rank Update Received", {
                User = fmtUser(p),
                Rank = p:GetAttribute("OVHL_Rank"),
                Source = "Replication (Server->Client)"
            })
        end)
        
        local r = p:GetAttribute("OVHL_Rank")
        if r then 
            Logger:Info("PERMISSION", "Initial Rank Loaded", {User=fmtUser(p), Rank=r})
        else 
            Logger:Debug("PERMISSION", "Waiting for Server Rank Assignment...") 
        end
        return
    end

    -- [[ SERVER SIDE ]]
    local hdFolder = ServerScriptService:FindFirstChild("HD Admin")
    if hdFolder then
        Logger:Info("PERMISSION", "HD Admin Folder Detected", {path=hdFolder:GetFullName()})
        task.spawn(function() self:_connectAPI() end)
        task.spawn(function() self:_setupEventListeners(hdFolder) end)
    else
        Logger:Warn("PERMISSION", "HD Admin Folder NOT FOUND (Using Internal Logic Only)")
    end
end

function HDAdminAdapter:_connectAPI()
    -- Tunggu API
    local start = os.clock()
    while (os.clock() - start) < 10 do
        if _G.HDAdminMain then
            self._api = _G.HDAdminMain
            Logger:Info("PERMISSION", "✅ HD Admin API Connected")
            self:_refreshAllRanks() -- Paksa update semua player yg udh join
            return
        end
        task.wait(0.5)
    end
    Logger:Warn("PERMISSION", "⛔ HD Admin API Timeout (Using Fallback Internal)")
end

function HDAdminAdapter:_setupEventListeners(folder)
    Logger:Info("PERMISSION", "Hooking Remote Events...")
    for _, item in ipairs(folder:GetDescendants()) do
        if item:IsA("RemoteEvent") and (item.Name:match("Rank") or item.Name:match("Perm")) then
            item.OnServerEvent:Connect(function(player, ...)
                for _, arg in ipairs({...}) do
                    if type(arg) == "number" and arg >= 0 and arg <= 5 then
                        self:_cacheRank(player, arg, "HDAdmin Event (Sniffing)")
                    end
                end
            end)
        end
    end
end

function HDAdminAdapter:_refreshAllRanks()
    if not self._api then return end
    for _, p in ipairs(Players:GetPlayers()) do
        -- Trigger GetRank agar cache terupdate via API
        local r = self:GetRank(p) 
        p:SetAttribute("OVHL_Rank", r)
    end
end

function HDAdminAdapter:_cacheRank(player, rank, source)
    -- Cek apakah nilai berubah biar gak spam log
    local old = self._cache[player.UserId] and self._cache[player.UserId].rank
    
    self._cache[player.UserId] = {rank = rank, time = os.time()}
    player:SetAttribute("OVHL_Rank", rank)
    
    if old ~= rank then
        Logger:Info("PERMISSION", "Rank Updated", {
            User = fmtUser(player),
            Rank = rank,
            Source = source
        })
    end
end

function HDAdminAdapter:_isOwner(player)
    return player.UserId == game.CreatorId
end

function HDAdminAdapter:GetRank(player)
    if RunService:IsClient() then return player:GetAttribute("OVHL_Rank") or 0 end
    
    -- 1. Cache Check
    local c = self._cache[player.UserId]
    if c and (os.time() - c.time) < 60 then 
        return c.rank 
    end

    -- 2. Fallback Owner (Internal Logic)
    -- Kita cek ini DULUAN jika API belum siap atau API return 0 padahal dia owner
    if self:_isOwner(player) then
        -- Cek apakah API sudah ada tapi ngasih 0?
        if self._api then
            local s, r = pcall(function() return self._api:GetModule("cf"):GetRank(player) end)
            if s and type(r)=="number" and r < 5 then
               -- API bilang < 5, tapi dia owner. Kita OVERRIDE.
               self:_cacheRank(player, 5, "Internal (Owner Override)")
               return 5
            end
        else
            -- API Mati, pake Internal
            self:_cacheRank(player, 5, "Internal (Fallback)")
            return 5
        end
    end

    -- 3. API Call (Normal User)
    if self._api then
        local s, r = pcall(function() return self._api:GetModule("cf"):GetRank(player) end)
        if s and type(r) == "number" then
            self:_cacheRank(player, r, "HDAdmin API")
            return r
        end
    end

    return 0
end

return HDAdminAdapter
