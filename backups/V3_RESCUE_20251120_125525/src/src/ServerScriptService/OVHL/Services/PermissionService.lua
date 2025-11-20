--[[
    🧠 SERVICE: PERMISSION SERVICE (FINAL)
    @Features: Adapter + DB + Network API (Secured)
]]
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")
local RS = game:GetService("ReplicatedStorage")

local SmartLogger = require(RS.OVHL.Core.SmartLogger)
local InternalCfg = require(SSS.OVHL.Config.PermissionConfig)
local HDAdapter   = require(SSS.OVHL.Core.Permissions.HDAdminAdapter)
local IntPolicy   = require(SSS.OVHL.Core.Permissions.InternalPolicy)

local Srv = {}

function Srv:Init(ctx)
    self.Logger = SmartLogger.New("PERM")
    self._cache = {}
    
    -- [NETWORK WIRING]
    ctx.Network:Register("PermissionSystem", {
        Requests = {
            SetRank = { Args = {"number", "number"}, RateLimit = {Max=10, Interval=60} }
        }
    })
    ctx.Network:Bind("PermissionSystem", self)
    
    Players.PlayerAdded:Connect(function(p) self:HandleJoin(p) end)
    for _, p in ipairs(Players:GetPlayers()) do self:HandleJoin(p) end
end

function Srv:Start()
    self.Logger:Info("Init", "Delegating scan to HDAdapter...")
    HDAdapter.StartScan(self.Logger)
end

function Srv:HandleJoin(p)
    task.delay(1, function()
        if p and p.Parent then self:Resolve(p) end
    end)
end

function Srv:Resolve(player)
    local result = { Rank = 0, Source = "ERR" }
    local resolved = false
    
    -- LEVEL 1: EXTERNAL
    local hdRank = HDAdapter.GetRank(player)
    if hdRank > 0 then
        result.Rank = hdRank; result.Source = "EXTERNAL_HD"; resolved = true
    elseif player.UserId == game.CreatorId then
        result.Rank = 5; result.Source = "EXTERNAL_OWNER_FORCE"; resolved = true
    end
    
    -- LEVEL 2: INTERNAL DB
    if not resolved then
        local dbData = IntPolicy.Get(player.UserId)
        if dbData and dbData.Rank then
            result.Rank = dbData.Rank; result.Source = "INTERNAL_DB"; resolved = true
        end
    end
    
    -- LEVEL 3: STATIC
    if not resolved then
        if InternalCfg.Users[player.UserId] then
            result.Rank = InternalCfg.Users[player.UserId]; result.Source = "INTERNAL_STATIC"
        else
            result.Rank = 0; result.Source = "GUEST"
        end
    end

    self._cache[player.UserId] = result
    if result.Rank > 0 then
        self.Logger:Info("Identity", {User=player.Name, Rank=result.Rank, Src=result.Source})
    end
end

function Srv:Check(player, req)
    local data = self._cache[player.UserId]
    if not data then return false end
    local t = (type(req)=="number" and req) or (req=="HeadAdmin" and 4) or (req=="Admin" and 3) or 5
    return data.Rank >= t
end

function Srv:SetRank(player, targetUserId, rankId)
    if not self:Check(player, "HeadAdmin") then
        self.Logger:Warn("Security", "Unauthorized Rank Attempt", {User=player.Name})
        return {Success=false, Msg="Access Denied: HeadAdmin Only"}
    end
    
    local ok = IntPolicy.Set(targetUserId, rankId, player.UserId)
    if ok then
        self.Logger:Warn("Update", "Permission Updated", {Target=targetUserId, Rank=rankId})
        local targetPlayer = Players:GetPlayerByUserId(targetUserId)
        if targetPlayer then self:Resolve(targetPlayer) end
        return {Success=true, Msg="Authority Updated Successfully"}
    else
        return {Success=false, Msg="Database Error"}
    end
end

return Srv
