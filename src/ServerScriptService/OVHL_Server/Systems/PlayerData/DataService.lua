local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local OVHL = require(ReplicatedStorage.OVHL_Shared)
local DataManager = require(ServerStorage.OVHL_Internal.DataInternal.DataManager)

local DataService = { 
    Name = "DataService",
    Client = { GetData = OVHL.Network.CreateFunction() }
}

OVHL.RegisterSystem("DataService", DataService)

function DataService:OnInit()
    OVHL.Network:InitServiceRemotes("DataService", self.Client)
    OVHL.Logger:Info("DATA", "DataService Registered")
end

function DataService:Get(player) return DataManager:Get(player) end
function DataService.Client:GetData(player) return DataManager:Get(player) end

return DataService
