-- [[ INTERNAL PERMISSION ADAPTER V2 ]]
local InternalAdapter = {}
InternalAdapter.__index = InternalAdapter

local RANKS = { Owner = 5, Admin = 3, User = 0 }

function InternalAdapter.new()
    return setmetatable({}, InternalAdapter)
end

function InternalAdapter:Init()
    -- Nothing to init
end

function InternalAdapter:GetRank(player)
    if player.UserId == game.CreatorId then
        return RANKS.Owner
    end
    return RANKS.User
end

return InternalAdapter
