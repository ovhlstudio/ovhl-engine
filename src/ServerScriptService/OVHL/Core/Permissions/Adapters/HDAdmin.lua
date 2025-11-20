local RS = game:GetService("ReplicatedStorage")
local HD = {}
local _api = nil

function HD.Connect(logger)
    if _api then return true end
    local setup = RS:FindFirstChild("HDAdminSetup")
    if not setup then return false end
    
    local s, r = pcall(function() return require(setup):GetMain() end)
    if s and r then 
        _api = r; logger:Info("Link", "HD Admin Connected")
        return true 
    end
    return false
end

function HD.GetRank(plr)
    if not _api then return 0 end
    local s, r = pcall(function() return _api:GetModule("cf"):GetRankId(plr) end)
    return (s and type(r)=="number") and r or 0
end
return HD
