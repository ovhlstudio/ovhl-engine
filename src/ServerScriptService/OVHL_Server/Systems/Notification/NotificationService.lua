-- [[ NOTIFICATION SERVICE V2 ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedPath = ReplicatedStorage.OVHL_Shared
local OVHL = require(SharedPath)

local NotificationService = OVHL.CreateService({
    Name = "NotificationService",
    Client = { Show = OVHL.Network.CreateEvent() }
})

function NotificationService:Send(player, message, type)
    -- Type: "Info", "Success", "Error", "Warning"
    self.Client.Show:FireClient(player, message, type or "Info")
end

function NotificationService:Broadcast(message, type)
    self.Client.Show:FireAllClients(message, type or "Info")
end

return NotificationService
