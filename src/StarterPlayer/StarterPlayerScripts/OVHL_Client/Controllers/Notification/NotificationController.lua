-- [[ NOTIFICATION CONTROLLER V2 (EVENT FIX) ]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedPath = ReplicatedStorage.OVHL_Shared
local OVHL = require(SharedPath)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local NotificationController = OVHL.CreateController({ Name = "NotificationController" })

-- Fusion Value State
local notifState = Fusion.Value({}) 

function NotificationController:OnStart()
    -- [[ FIX: AKSES REMOTE LANGSUNG ]]
    -- Kita tidak pakai OVHL.GetService karena itu untuk mengirim request.
    -- Untuk mendengar (Listen), kita ambil RemoteEvent-nya langsung.
    
    local success, remote = pcall(function()
        return OVHL.Network:GetRemote("NotificationService", "Show")
    end)
    
    if success and remote then
        remote.OnClientEvent:Connect(function(msg, type)
            self:Add(msg, type)
        end)
        OVHL.Logger:Info("NOTIF", "Listening to Server Events")
    else
        OVHL.Logger:Warn("NOTIF", "Gagal connect ke NotificationService (Remote Missing)")
    end
    
    -- Mount UI
    local View = require(script.Parent.NotificationView)
    local gui = View(notifState)
    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

function NotificationController:Add(message, type)
    local current = notifState:get()
    local id = os.clock()
    
    -- Insert New Notification
    local newItem = {ID = id, Message = message, Type = type}
    local newList = {unpack(current)}
    table.insert(newList, newItem)
    notifState:set(newList)
    
    -- Auto Remove (4 Detik)
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
