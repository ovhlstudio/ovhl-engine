--[[
OVHL ENGINE V3.0.0 - RATE LIMITER SYSTEM
Version: 3.0.0
Path: ReplicatedStorage.OVHL.Systems.Security.RateLimiter

FEATURES:
- Request rate limiting per player per action
- Configurable limits & time windows
- Automatic cleanup of old data
- Distributed tracking (server-side only)
--]]

local RateLimiter = {}
RateLimiter.__index = RateLimiter

function RateLimiter.new()
    local self = setmetatable({}, RateLimiter)
    self._logger = nil
    self._limits = self:_getDefaultLimits()
    self._tracking = {} -- { [playerUserId_action] = {count, windowStart} }
    self._cleanupInterval = 300 -- Cleanup every 5 minutes
    self._lastCleanup = os.time()
    return self
end

function RateLimiter:Initialize(logger)
    self._logger = logger
    self:_startCleanupTask()
    self._logger:Info("RATELIMITER", "Rate Limiter initialized")
end

function RateLimiter:_getDefaultLimits()
    return {
        -- Module actions
        DoAction = { max = 10, window = 60 }, -- 10 requests per minute
        Purchase = { max = 5, window = 300 }, -- 5 requests per 5 minutes
        Equip = { max = 20, window = 60 }, -- 20 requests per minute
        
        -- UI interactions  
        ButtonClick = { max = 30, window = 60 }, -- 30 clicks per minute
        ScreenOpen = { max = 15, window = 60 }, -- 15 screen opens per minute
        
        -- Data operations
        DataSave = { max = 5, window = 60 }, -- 5 saves per minute
        DataLoad = { max = 10, window = 60 }, -- 10 loads per minute
    }
end

function RateLimiter:Check(player, action)
    if not player or not action then
        return true -- Allow if invalid input (shouldn't happen, but be safe)
    end
    
    local limitConfig = self._limits[action]
    if not limitConfig then
        self._logger:Debug("RATELIMITER", "No rate limit configured for action", { action = action })
        return true -- No limit configured
    end
    
    local playerId = tostring(player.UserId)
    local trackingKey = playerId .. "_" .. action
    local now = os.time()
    
    -- Initialize or get tracking data
    if not self._tracking[trackingKey] then
        self._tracking[trackingKey] = {
            count = 1,
            windowStart = now
        }
        return true
    end
    
    local tracking = self._tracking[trackingKey]
    
    -- Check if window has expired
    if now - tracking.windowStart >= limitConfig.window then
        -- Reset counter
        tracking.count = 1
        tracking.windowStart = now
        return true
    end
    
    -- Check if limit exceeded
    if tracking.count >= limitConfig.max then
        self._logger:Warn("RATELIMITER", "Rate limit exceeded", {
            player = player.Name,
            action = action,
            count = tracking.count,
            limit = limitConfig.max,
            window = limitConfig.window
        })
        return false
    end
    
    -- Increment counter
    tracking.count = tracking.count + 1
    
    self._logger:Debug("RATELIMITER", "Request allowed", {
        player = player.Name,
        action = action,
        count = tracking.count,
        limit = limitConfig.max
    })
    
    return true
end

function RateLimiter:SetLimit(action, maxRequests, timeWindow)
    if not action or not maxRequests or not timeWindow then
        return false, "Invalid parameters"
    end
    
    self._limits[action] = {
        max = maxRequests,
        window = timeWindow
    }
    
    self._logger:Info("RATELIMITER", "Rate limit configured", {
        action = action,
        max = maxRequests,
        window = timeWindow
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
            if timeRemaining < 0 then
                timeRemaining = 0
            end
            
            stats[action] = {
                current = tracking.count,
                limit = limitConfig.max,
                resetIn = timeRemaining,
                window = limitConfig.window
            }
        else
            stats[action] = {
                current = 0,
                limit = limitConfig.max,
                resetIn = 0,
                window = limitConfig.window
            }
        end
    end
    
    return stats
end

function RateLimiter:_startCleanupTask()
    -- Cleanup old tracking data periodically
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
        -- Find the action from tracking key
        local playerId, action = string.match(trackingKey, "^(%d+)_(.+)$")
        if playerId and action then
            local limitConfig = self._limits[action]
            if limitConfig then
                -- Remove if window has expired (plus some grace period)
                if now - tracking.windowStart > limitConfig.window + 300 then -- 5 minutes grace
                    self._tracking[trackingKey] = nil
                    removedCount = removedCount + 1
                end
            end
        end
    end
    
    if removedCount > 0 then
        self._logger:Debug("RATELIMITER", "Cleaned up old tracking data", { count = removedCount })
    end
    
    self._lastCleanup = now
end

function RateLimiter:GetTrackingDataSize()
    return table.size(self._tracking)
end

return RateLimiter
