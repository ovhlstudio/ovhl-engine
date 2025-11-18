--[[
OVHL ENGINE V1.0.0
@Component: NotificationService (Advanced)
@Path: ReplicatedStorage.OVHL.Systems.Advanced.NotificationService
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.2.2
@Component: NotificationService (Core System)
@Path: ReplicatedStorage.OVHL.Systems.Advanced.NotificationService
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
    
    local OVHL = require(script.Parent.Parent.Parent.Core.OVHL)
    self._router = OVHL:GetSystem("NetworkingRouter") 
    
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
    
    -- TODO: NetworkingRouter butuh :SendToAllClients (Sesuai SSoT V3.0.0)
    self._logger:Warn("NOTIFICATION", "SendToAll belum diimplementasi di router.")
end

return NotificationService

--[[
@End: NotificationService.lua
@Version: 3.2.2
@See: docs/ADR_V3-2-2.md
--]]

--[[
@End: NotificationService.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

