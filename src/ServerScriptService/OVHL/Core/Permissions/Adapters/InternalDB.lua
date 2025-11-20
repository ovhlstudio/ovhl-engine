local DataStoreService = game:GetService("DataStoreService")
local InternalDB = {}
local STORE = DataStoreService:GetDataStore("OVHL_Global_Permissions")

function InternalDB.Get(userId)
    local s, r = pcall(function() return STORE:GetAsync(tostring(userId)) end)
    return (s and r and r.Rank) or 0
end

function InternalDB.Set(userId, rank, actor)
    local key = tostring(userId)
    if rank == 0 then 
        pcall(function() STORE:RemoveAsync(key) end)
        return true
    end
    local payload = { Rank = rank, UpdatedBy = actor, UpdatedAt = os.time() }
    return pcall(function() STORE:SetAsync(key, payload) end)
end
return InternalDB
