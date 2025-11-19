local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local OVHL = require(game:GetService("ReplicatedStorage").OVHL_Shared) -- Absolute
local DataManager = require(ServerStorage.OVHL_Internal.DataInternal.DataManager)

local PlayerManager = { Name = "PlayerManager" }
OVHL.RegisterSystem("PlayerManager", PlayerManager)

function PlayerManager:OnStart()
    OVHL.Logger:Info("CORE", "Player Lifecycle Active")
    Players.PlayerAdded:Connect(function(p) self:Join(p) end)
    Players.PlayerRemoving:Connect(function(p) self:Leave(p) end)
    game:BindToClose(function() for _,p in ipairs(Players:GetPlayers()) do DataManager:Save(p) end end)
    for _,p in ipairs(Players:GetPlayers()) do self:Join(p) end
end
function PlayerManager:Join(p) OVHL.Logger:Info("CORE", "Join: "..p.Name); DataManager:Load(p) end
function PlayerManager:Leave(p) DataManager:Unload(p); OVHL.Logger:Info("CORE", "Leave: "..p.Name) end
return PlayerManager
