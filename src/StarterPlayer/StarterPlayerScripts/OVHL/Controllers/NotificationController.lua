--[[ @Component: NotificationController (Toast Linked) ]]
local RS = game:GetService("ReplicatedStorage")
local Ctrl = {}

function Ctrl:Init(ctx)
    self.Log = ctx.Logger
    self.UI = ctx.UI
    
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
    -- Redirect ke UIService Toast Engine (Bukan StarterGui lagi)
    -- Kind: "Success", "Error", "Info"
    self.UI:ShowToast(msg, kind) 
end

return Ctrl
