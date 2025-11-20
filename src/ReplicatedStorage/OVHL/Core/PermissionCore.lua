--[[ @Component: PermissionCore (Shared Logic) ]]
local PermCore = {}
local RS = game:GetService("ReplicatedStorage")
-- ABSOLUTE REQUIRE
local Enums = require(RS.OVHL.Core.EngineEnums)

function PermCore.Resolve(val)
    if type(val) == "number" then return val end
    return Enums.Permission[val] or 0
end

function PermCore.Check(userRank, reqRank)
    return PermCore.Resolve(userRank) >= PermCore.Resolve(reqRank)
end

return PermCore
