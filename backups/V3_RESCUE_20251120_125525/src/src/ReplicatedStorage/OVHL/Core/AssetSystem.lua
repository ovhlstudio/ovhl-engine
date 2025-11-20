--[[ @Component: AssetSystem (String Fix & Caching) ]]
local ContentProvider = game:GetService("ContentProvider")
local AssetSystem = {}

-- Regex Pattern
local ID_PATTERN = "^(%d+)$"
local RBX_PATTERN = "^rbxassetid://(%d+)$"

function AssetSystem.Clean(id)
    if not id then return "" end
    local str = tostring(id)
    
    -- Convert "12345" -> "rbxassetid://12345"
    if str:match(ID_PATTERN) then
        return "rbxassetid://" .. str
    end
    
    -- Pass if already formatted
    if str:match(RBX_PATTERN) then
        return str
    end
    
    return "rbxassetid://0" -- Fallback Texture
end

-- Wrapper for ImageLabel
function AssetSystem.Apply(guiObject, rawId)
    if guiObject and guiObject:IsA("ImageLabel") or guiObject:IsA("ImageButton") then
        guiObject.Image = AssetSystem.Clean(rawId)
    end
end

return AssetSystem
