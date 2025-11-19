local ContentProvider = game:GetService("ContentProvider")
local OVHL = require(game:GetService("ReplicatedStorage").OVHL_Shared) -- Absolute

local AssetLoader = { Name = "AssetLoader" }
OVHL.RegisterSystem("AssetLoader", AssetLoader)

function AssetLoader:OnInit() OVHL.Logger:Info("UI", "AssetLoader Registered") end
function AssetLoader:Preload(a)
    task.spawn(function()
        local t = {}
        for _,id in pairs(a) do if type(id)=="string" then table.insert(t,id) end end
        if #t>0 then pcall(function() ContentProvider:PreloadAsync(t) end) end
    end)
end
return AssetLoader
