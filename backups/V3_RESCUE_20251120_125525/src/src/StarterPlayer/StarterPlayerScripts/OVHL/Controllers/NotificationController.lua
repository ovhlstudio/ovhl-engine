--[[ @Component: NotificationController (Client) ]]
local SG = game:GetService("StarterGui")
local RS = game:GetService("ReplicatedStorage")

local Ctrl = {}
function Ctrl:Init(ctx)
    self.Log = ctx.Logger
    local root = RS:WaitForChild("OVHL_Remotes")
    local remote = root:WaitForChild("NotificationSystem/Push", 5)
    
    if remote then
        remote.OnClientEvent:Connect(function(msg, kind)
            self:Show(msg, kind)
        end)
    end
end

function Ctrl:Start() end

function Ctrl:Show(msg, kind)
    -- Enterprise Default: Gunakan RBX Notification jika UI System belum bikin Custom Toast
    self.Log:Info("NOTIF", msg, {Type=kind})
    pcall(function()
        SG:SetCore("SendNotification", {
            Title = kind or "System",
            Text = msg,
            Duration = 5
        })
    end)
end
return Ctrl
