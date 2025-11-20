--[[ @Component: AssetLoader (Client - Wally Promise) ]]
local Content = game:GetService("ContentProvider")
local RS = game:GetService("ReplicatedStorage")
-- WALLY REQUIRE
local Promise = require(RS.Packages.Promise) 

local Loader = {}
function Loader.Load(assets)
    return Promise.new(function(resolve)
        local list = {}
        for _,v in pairs(assets) do 
            if type(v) == "string" and v:match("^rbxasset") then table.insert(list, v) end
        end
        pcall(function() Content:PreloadAsync(list) end)
        resolve()
    end)
end
return Loader
