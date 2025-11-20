local RS = game:GetService("ReplicatedStorage")
local Fusion = require(RS.OVHL.UI.Core.Fusion)
local Theme = require(RS.OVHL.UI.Foundation.Theme)

return function(scope, props)
    local rotation = scope:Value(0)
    
    -- Loop Animation
    local conn
    local function startSpin()
        conn = game:GetService("RunService").RenderStepped:Connect(function(dt)
            rotation:set(Fusion.peek(rotation) + (dt * 360)) -- 1 putaran per detik
        end)
    end
    
    -- Cleanup hook
    table.insert(scope, function() if conn then conn:Disconnect() end end)
    startSpin()

    return scope:New "ImageLabel" {
        Name = "Spinner",
        Size = props.Size or UDim2.fromOffset(24, 24),
        BackgroundTransparency = 1,
        Image = "rbxassetid://18451427072", -- Circle Loading Asset (Standard Roblox)
        -- Fallback kalau asset gak load: Kotak muter
        ImageColor3 = props.Color or Theme.Colors.TextMain,
        Rotation = rotation
    }
end
