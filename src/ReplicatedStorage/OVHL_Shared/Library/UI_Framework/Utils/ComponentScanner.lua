-- [[ COMPONENT SCANNER (PORTED FROM LEGACY) ]]
-- Purpose: Deep recursive search for Native UI mapping

local ComponentScanner = {}

function ComponentScanner.Scan(rootInstance, componentMap)
    if not rootInstance then return nil, "Root nil" end
    
    local results = {}
    local missing = {}
    
    local function deepFind(parent, name)
        return parent:FindFirstChild(name, true) 
    end
    
    for key, targetName in pairs(componentMap) do
        local instance = deepFind(rootInstance, targetName)
        if instance then
            results[key] = instance
        else
            table.insert(missing, targetName)
        end
    end
    
    return results, missing
end

return ComponentScanner
