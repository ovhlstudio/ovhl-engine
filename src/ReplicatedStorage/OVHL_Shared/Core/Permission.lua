-- [[ PERMISSION CORE V2 (VERBOSE) ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("OVHL_Shared")
local Logger = require(Shared.Core.Logger)
local Config = require(Shared.Library.SharedConfig)
local Adapters = Shared.Library.Adapters.Permission

local Permission = {}
local _adapter = nil

function Permission:Init()
    local adapterName = Config.Adapters.Permission or "InternalAdapter"
    local context = RunService:IsServer() and "Server" or "Client"
    
    -- [LEGACY LOG]
    Logger:Info("PERMISSION", "Init PermissionCore ("..context..")", {adapter=adapterName})
    
    local module = Adapters:FindFirstChild(adapterName)
    
    if module then
        local success, cls = pcall(require, module)
        if success then
            local instance = cls.new()
            if instance.Init then instance:Init() end
            _adapter = instance
            
            -- [LEGACY LOG]
            Logger:Info("PERMISSION", "✅ Adapter READY: " .. adapterName)
        else
            Logger:Critical("PERMISSION", "Adapter Error", {err=cls})
        end
    else
        Logger:Warn("PERMISSION", "Adapter Missing: " .. adapterName)
    end

    if RunService:IsServer() then
        local function update(p) 
            if _adapter then p:SetAttribute("OVHL_Rank", _adapter:GetRank(p)) end
        end
        Players.PlayerAdded:Connect(update)
        for _, p in ipairs(Players:GetPlayers()) do update(p) end
    end
end

function Permission:GetRank(player)
    return _adapter and _adapter:GetRank(player) or 0
end

function Permission:Check(player, minRank)
    return self:GetRank(player) >= (minRank or 0)
end

Permission:Init()
return Permission
