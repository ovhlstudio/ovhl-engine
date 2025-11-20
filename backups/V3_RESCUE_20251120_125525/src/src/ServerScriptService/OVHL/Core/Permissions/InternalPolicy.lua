--[[
    🗄️ POLICY: INTERNAL DATABASE
    @Responsibility: CRUD Operations ke DataStore "OVHL_Global_Permissions"
    @Schema: { Rank=int, UpdatedBy=int, UpdatedAt=int }
]]
local DataStoreService = game:GetService("DataStoreService")
local InternalPolicy = {}

local STORE_KEY = "OVHL_Global_Permissions"
local DS = DataStoreService:GetDataStore(STORE_KEY)

-- [READ] Ambil data permission user
function InternalPolicy.Get(userId)
    local key = tostring(userId)
    local success, result = pcall(function()
        return DS:GetAsync(key)
    end)
    
    if success and result then
        return result -- Return table {Rank=..., ...}
    elseif not success then
        warn("[OVHL DB] Read Error:", result)
    end
    return nil
end

-- [WRITE] Simpan/Update data permission user
function InternalPolicy.Set(targetUserId, rank, actorUserId)
    local key = tostring(targetUserId)
    
    -- Jika Rank 0, kita hapus datanya untuk hemat storage
    if rank == 0 then
        pcall(function() DS:RemoveAsync(key) end)
        return true
    end

    local payload = {
        Rank = rank,
        UpdatedBy = actorUserId or 0,
        UpdatedAt = os.time()
    }
    
    local success, err = pcall(function()
        DS:SetAsync(key, payload)
    end)
    
    if not success then
        warn("[OVHL DB] Write Error:", err)
        return false
    end
    return true
end

return InternalPolicy
