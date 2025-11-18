--[[
OVHL ENGINE V3.3.0 (FINAL)
@Component: RateLimiter (Core System)
@Path: ReplicatedStorage.OVHL.Systems.Security.RateLimiter
@Purpose: (V3.3.0) Menggunakan Two-Phase Init. :Start() untuk task cleanup.
--]]

local RateLimiter = {}
RateLimiter.__index = RateLimiter

function RateLimiter.new()
    local self = setmetatable({}, RateLimiter)
    self._logger = nil
    self._limits = self:_getDefaultLimits()
    self._tracking = {} 
    self._cleanupInterval = 300 
    self._lastCleanup = os.time()
    return self
end

-- FASE 1: Hanya konstruksi
function RateLimiter:Initialize(logger)
    self._logger = logger
end

-- FASE 2: Aktivasi (Start background task)
function RateLimiter:Start()
    self:_startCleanupTask()
    self._logger:Info("RATELIMITER", "Rate Limiter Ready (V3.3.0).")
end

function RateLimiter:_getDefaultLimits()
    return {
        DoAction = { max = 10, window = 60 },
        Purchase = { max = 5, window = 300 },
        Equip = { max = 20, window = 60 },
        ButtonClick = { max = 30, window = 60 },
        ScreenOpen = { max = 15, window = 60 },
        DataSave = { max = 5, window = 60 },
        DataLoad = { max = 10, window = 60 },
    }
end

function RateLimiter:Check(player, action)
    if not player or not action then
        return true 
    end
    
    local limitConfig = self._limits[action]
    if not limitConfig then
        self._logger:Debug("RATELIMITER", "No rate limit configured", { action = action })
        return true 
    end
    
    local playerId = tostring(player.UserId)
    local trackingKey = playerId .. "_" .. action
    local now = os.time()
    
    if not self._tracking[trackingKey] then
        self._tracking[trackingKey] = {
            count = 1,
            windowStart = now
        }
        return true
    end
    
    local tracking = self._tracking[trackingKey]
    
    if now - tracking.windowStart >= limitConfig.window then
        tracking.count = 1
        tracking.windowStart = now
        return true
    end
    
    if tracking.count >= limitConfig.max then
        self._logger:Warn("RATELIMITER", "Rate limit exceeded", {
            player = player.Name,
            action = action,
            count = tracking.count
        })
        return false
    end
    
    tracking.count = tracking.count + 1
    return true
end

function RateLimiter:SetLimit(action, maxRequests, timeWindow)
    self._limits[action] = {
        max = maxRequests,
        window = timeWindow
    }
    self._logger:Info("RATELIMITER", "Rate limit configured", {
        action = action,
        max = maxRequests
    })
    return true
end

function RateLimiter:GetLimit(action)
    return self._limits[action]
end

function RateLimiter:GetPlayerStats(player)
    local playerId = tostring(player.UserId)
    local stats = {}
    local now = os.time()
    
    for action, limitConfig in pairs(self._limits) do
        local trackingKey = playerId .. "_" .. action
        local tracking = self._tracking[trackingKey]
        
        if tracking then
            local timeRemaining = limitConfig.window - (now - tracking.windowStart)
            stats[action] = {
                current = tracking.count,
                limit = limitConfig.max,
                resetIn = timeRemaining < 0 and 0 or timeRemaining
            }
        else
            stats[action] = {
                current = 0,
                limit = limitConfig.max,
                resetIn = 0
            }
        end
    end
    return stats
end

function RateLimiter:_startCleanupTask()
    task.spawn(function()
        while true do
            task.wait(self._cleanupInterval)
            self:_cleanupOldData()
        end
    end)
end

function RateLimiter:_cleanupOldData()
    local now = os.time()
    local removedCount = 0
    
    for trackingKey, tracking in pairs(self._tracking) do
        local playerId, action = string.match(trackingKey, "^(%d+)_(.+)$")
        if playerId and action then
            local limitConfig = self._limits[action]
            if limitConfig then
                if now - tracking.windowStart > limitConfig.window + 300 then 
                    self._tracking[trackingKey] = nil
                    removedCount = removedCount + 1
                end
            end
        end
    end
    
    if removedCount > 0 then
        self._logger:Debug("RATELIMITER", "Cleaned up old data", { count = removedCount })
    end
    self._lastCleanup = now
end

return RateLimiter

--[[
@End: RateLimiter.lua
@Version: 3.3.0 (Two-Phase Init)
@See: docs/ADR_V3-3-0.md
--]]
