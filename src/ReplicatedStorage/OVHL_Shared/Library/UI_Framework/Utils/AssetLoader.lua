-- [[ ASSET LOADER V2 ]]
-- Helper untuk preload dan manajemen aset gambar
local ContentProvider = game:GetService("ContentProvider")
local Logger = require(script.Parent.Parent.Parent.Parent.Core.Logger)

local AssetLoader = {}

function AssetLoader.Preload(assets)
    if type(assets) ~= "table" then return end
    
    task.spawn(function()
        local toLoad = {}
        for _, id in pairs(assets) do
            if type(id) == "string" then
                table.insert(toLoad, id)
            elseif typeof(id) == "Instance" then
                table.insert(toLoad, id)
            end
        end
        
        if #toLoad > 0 then
            local start = os.clock()
            pcall(function() ContentProvider:PreloadAsync(toLoad) end)
            Logger:Debug("ASSETS", "Preloaded " .. #toLoad .. " items in " .. math.round((os.clock()-start)*1000) .. "ms")
        end
    end)
end

function AssetLoader.GetIcon(id)
    if string.match(id, "^rbxassetid://") then return id end
    return "rbxassetid://" .. id
end

return AssetLoader
