local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedPath = ReplicatedStorage.OVHL_Shared
local OVHL = require(SharedPath)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local View = require(script.Parent.NotificationView)

local NotificationController = OVHL.CreateController({ Name = "NotificationController" })

-- Register so others can find it
OVHL.RegisterSystem("NotificationController", NotificationController)

local notifState = Fusion.Value({}) 

function NotificationController:OnStart()
    local remote = OVHL.Network:GetRemote("NotificationService", "Show")
    if remote then
        remote.OnClientEvent:Connect(function(msg, type) self:Add(msg, type) end)
    end
    
    local gui = View(notifState)
    gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    OVHL.Logger:Info("NOTIF", "Notification System Ready")
end

function NotificationController:Add(message, type)
    local current = notifState:get()
    local id = os.clock()
    local newList = {unpack(current)}
    table.insert(newList, {ID=id, Message=message, Type=type})
    notifState:set(newList)
    
    task.delay(4, function()
        local clean = {}
        local nowList = notifState:get() 
        for _, item in ipairs(nowList) do
            if item.ID ~= id then table.insert(clean, item) end
        end
        notifState:set(clean)
    end)
end

return NotificationController
