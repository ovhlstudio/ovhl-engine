local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Workspace = game:GetService("Workspace")

local Computed = Fusion.Computed

local Responsive = {}
local camera = Workspace.CurrentCamera
local viewportSize = Fusion.State(camera.ViewportSize)

-- Listener perubahan layar
camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    viewportSize:set(camera.ViewportSize)
end)

-- Design Reference: 1920x1080
function Responsive.Scale(scaleFactor)
    return Computed(function()
        local current = viewportSize:get()
        -- Hitung rasio berdasarkan lebar layar
        local ratio = current.X / 1920
        return ratio * (scaleFactor or 1)
    end)
end

return Responsive
