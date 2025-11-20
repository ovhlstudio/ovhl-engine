--[[ @Component: NotificationService (Server) ]]
local Service = {}

function Service:Init(ctx) 
    self.Net = ctx.Network -- Bridge
    -- Register Channel Khusus Notif
    self.Bridge = self.Net:Register("NotificationSystem", {
        -- Server to Client events don't need Config definition here normally,
        -- but Bridge setup requires registration.
    }) 
    self.Remote = self.Net._root:FindFirstChild("NotificationSystem/Push") 
                  or Instance.new("RemoteEvent", self.Net._root)
    self.Remote.Name = "NotificationSystem/Push"
end

function Service:Start() end

function Service:Notify(player, message, type)
    -- Type: "Info", "Error", "Success"
    self.Remote:FireClient(player, message, type or "Info")
end

function Service:NotifyAll(message, type)
    self.Remote:FireAllClients(message, type or "Info")
end

return Service
