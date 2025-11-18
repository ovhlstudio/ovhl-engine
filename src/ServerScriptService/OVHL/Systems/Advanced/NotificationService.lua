--[[
OVHL FRAMEWORK V.1.1.0
@Component: NotificationService (Core System)
@Path: ServerScriptService.OVHL.Systems.Advanced.NotificationService
@Purpose: Menyediakan API terpusat untuk mengirim notifikasi (Toast, UI) ke client.
--]]

local NotificationService = {}
NotificationService.__index = NotificationService

function NotificationService.new()
    local self = setmetatable({}, NotificationService)
    self._logger = nil
    self._router = nil
    return self
end

function NotificationService:Initialize(logger)
    self._logger = logger
    
    -- [V1.1.0 ARCHITECTURE FIX] ABSOLUTE PATH
    local OVHL = require(game:GetService("ReplicatedStorage").OVHL.Core.OVHL)
    self._router = OVHL.GetSystem("NetworkingRouter") 
    
    if not self._router then
        self._logger:Error("NOTIFICATION", "Gagal mendapatkan NetworkingRouter!")
        return
    end
    
    self._logger:Info("NOTIFICATION", "Notification Service Ready (Server API).")
end

function NotificationService:SendToPlayer(player, message, icon, duration)
    if not self._router then return end
    
    self._router:SendToClient(player, "OVHL.Notification.Show", {
        Message = message,
        Icon = icon or "Info",
        Duration = duration or 5
    })
end

function NotificationService:SendToAll(message, icon, duration)
    if not self._router then return end
    self._logger:Warn("NOTIFICATION", "SendToAll belum diimplementasi di router.")
end

return NotificationService
