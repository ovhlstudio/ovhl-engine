--[[ @Component: FinderService (Anti-Break Logic) ]]
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Finder = {}

-- Strategy: Direct > Attribute > Tag > Name > Recursive Pattern
function Finder.Get(query, root)
    root = root or PlayerGui
    
    -- 1. Direct Reference by Attribute (O(1))
    if type(query) == "string" then
        -- Cek apakah Root punya atribut reference ke instance
        local attrRef = root:GetAttribute(query)
        if attrRef and typeof(attrRef) == "Instance" then
            return attrRef
        end
    end
    
    -- 2. CollectionService Tag (O(1) Lookup, O(n) filtering)
    -- Query bisa berupa string TagName
    local tagged = CollectionService:GetTagged(query)
    for _, obj in ipairs(tagged) do
        if obj:IsDescendantOf(root) then return obj end
    end

    -- 3. Standard Name Search (Fast Child)
    local child = root:FindFirstChild(query, true) -- Recursive built-in
    if child then return child end
    
    return nil
end

-- Digunakan untuk resolve list component dari Config.UI.Components
function Finder.ResolveMap(screenName, componentMap)
    local root = PlayerGui:FindFirstChild(screenName)
    if not root then return nil, "ScreenGui " .. screenName .. " not found" end
    
    local results = { _Root = root }
    local missing = {}
    
    for key, spec in pairs(componentMap) do
        -- Support simple string name OR spec table { Name="xyz", Tag="abc" }
        local searchKey = (type(spec) == "table") and (spec.Tag or spec.Name) or spec
        local found = Finder.Get(searchKey, root)
        
        if found then
            results[key] = found
        else
            table.insert(missing, key .. " (" .. tostring(searchKey) .. ")")
        end
    end
    
    if #missing > 0 then
        return nil, "Missing Components: " .. table.concat(missing, ", ")
    end
    
    return results
end

return Finder
