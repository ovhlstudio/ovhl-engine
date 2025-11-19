--[[ @Component: HDAdminAdapter (Phase 29 - Cascade) ]]
local Players = game:GetService("Players")
local SS = game:GetService("ServerScriptService")
local RS = game:GetService("ReplicatedStorage")
local LoggerClass = require(game:GetService("ReplicatedStorage").OVHL.Core.SmartLogger)

local Adapter = {}
Adapter.__index = Adapter

function Adapter.New() 
    local self = setmetatable({}, Adapter)
    self._cache = {} 
    self.Logger = LoggerClass.New("PERM")
    
    if game.CreatorType == Enum.CreatorType.User then
        self._ownerId = game.CreatorId
    else
        self._ownerId = -1
    end
    
    return self
end

function Adapter:Init()
    -- 1. START SYSTEMS
    task.spawn(function()
        -- Setup Trigger
        local setup = RS:WaitForChild("HDAdminSetup", 5)
        if setup then pcall(require(setup).GetMain) end

        -- Hook Remotes
        local folder = SS:WaitForChild("HD Admin", 10)
        if folder then self:_hookRecursive(folder) end

        -- Link API
        while not _G.HDAdminMain do task.wait(1) end
        self.API = _G.HDAdminMain
        
        -- Re-sync everyone once API is definitely linked
        for _, p in ipairs(Players:GetPlayers()) do self:Sync(p, "API_LINKED") end
    end)

    -- 2. V1 LOGIC: ACTIVE WAIT
    Players.PlayerAdded:Connect(function(p) 
        task.spawn(function()
            -- Tunggu sebentar, lalu tembak cek.
            task.wait(2.5) 
            self:Sync(p, "V1_TIMER")
        end)
    end)
end

function Adapter:_hookRecursive(instance)
    for _, desc in ipairs(instance:GetDescendants()) do
        if desc:IsA("RemoteEvent") then self:_attachSpy(desc) end
    end
    instance.DescendantAdded:Connect(function(desc)
        if desc:IsA("RemoteEvent") then self:_attachSpy(desc) end
    end)
end

function Adapter:_attachSpy(remote)
    local n = remote.Name
    if n:match("Rank") or n:match("Perm") or n:match("Admin") or n:match("Main") then
        remote.OnServerEvent:Connect(function(p, ...) self:_sniff(p, ...) end)
    end
end

function Adapter:_sniff(player, ...)
    local args = {...}
    for _, val in ipairs(args) do
        if type(val) == "number" and val >= 0 and val <= 255 then
            local r = math.floor(val)
            -- Clamp for V2 Standard
            if r > 5 then r = 5 end 
            
            local old = self._cache[player.UserId]
            if old ~= r then
                self._cache[player.UserId] = r
                -- Update Realtime (PENTING)
                self:Sync(player, "V1_SNIFFER")
            end
            return
        end
    end
end

function Adapter:GetRank(player)
    -- 1. CHECK CACHE (SNIFFER) - V1 Code: line 213
    -- Logic V1: Check Cache, if exists return. 
    -- Tapi di V1 asli, dia cek API dulu baru Cache. 
    -- Mari kita pakai logika CASCADE MURNI: Cari yg > 0.

    -- ATTEMPT 1: API
    if self.API then
        local s, cf = pcall(function() return self.API:GetModule("cf") end)
        if s and cf and cf.GetRankId then
            local s2, r = pcall(function() return cf.GetRankId(player) end)
            -- THE V1 FIX: Ignore 0!
            if s2 and type(r) == "number" and r > 0 then 
                return r, "V1_API" 
            end
        end
    end

    -- ATTEMPT 2: SNIFFER CACHE
    local cached = self._cache[player.UserId]
    if cached and cached > 0 then
        return cached, "V1_CACHE"
    end

    -- ATTEMPT 3: OWNER FALLBACK (V1 Code: line 297)
    if player.UserId == self._ownerId then
        return 5, "V1_CREATOR"
    end

    return 0, "GUEST"
end

function Adapter:Sync(player, trigger)
    local rank, src = self:GetRank(player)
    
    player:SetAttribute("OVHL_Rank", rank)
    player:SetAttribute("OVHL_Src", src)

    if rank > 0 then
        self.Logger:Info("Identity Established", {User=player.Name, Rank=rank, Via=src})
    end
end

return Adapter
