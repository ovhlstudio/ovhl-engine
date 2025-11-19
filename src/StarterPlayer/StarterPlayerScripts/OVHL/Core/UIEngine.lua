--[[ @Component: UIEngine (Client) ]]
local Engine = {}
local Players = game:GetService("Players")

local function BFS(root, name)
    local q = {root}
    while #q > 0 do
        local curr = table.remove(q, 1)
        local f = curr:FindFirstChild(name)
        if f then return f end
        for _,c in ipairs(curr:GetChildren()) do table.insert(q, c) end
    end
    return nil
end

function Engine.Scan(screenName, map)
    local gui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local screen = gui:FindFirstChild(screenName)
    
    if not screen then return nil end
    
    local res = {_Root = screen}
    for k, v in pairs(map) do
        local target = (type(v)=="table" and v.Name) or v
        local obj = BFS(screen, target)
        if not obj then 
            warn("UIEngine: Strict Fail Missing " .. target)
            return nil 
        end
        res[k] = obj
    end
    return res
end
return Engine
