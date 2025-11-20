--[[
    OVHL Fusion Helper (0.3 Compatible)
]]
local Package = script.Parent.Parent.Parent.Parent.Packages
local Fusion = require(Package:FindFirstChild("Fusion") or Package:FindFirstChild("_Index"))

local FusionHelper = {}
local peek = Fusion.peek

-- Deterministik: Cek apakah ini object Fusion
function FusionHelper.isState(target)
    return type(target) == "table" and target.type ~= nil and target.kind ~= nil
end

-- Fusion 0.3 Safe Read
function FusionHelper.read(target)
    if FusionHelper.isState(target) then
        -- Gunakan peek() untuk baca value tanpa track dependency
        return peek(target)
    elseif type(target) == "function" then
        return target()
    else
        return target
    end
end

function FusionHelper.readOr(target, defaultVal)
    local val = FusionHelper.read(target)
    if val == nil then return defaultVal end
    return val
end

return FusionHelper
