--[[
OVHL FRAMEWORK V.1.0.1
@Component: @Component: RateLimiter (Core System) (Standard)
@Path: ReplicatedStorage.OVHL.Systems.Security.RateLimiter
@Purpose: Rate Limiting (SERVER ONLY)
--]]

local RunService = game:GetService("RunService")
local RateLimiter = {}
RateLimiter.__index = RateLimiter

function RateLimiter.new()
	local self = setmetatable({}, RateLimiter)
	self._logger = nil
	self._limits = self:_getDefaultLimits()
	self._tracking = {}
	self._cleanupInterval = 300
	self._lastCleanup = os.time()
	self._isRunning = false
	self._cleanupThread = nil
    
    -- [PHASE 1 FIX] Security Guard
    if not RunService:IsServer() then
        error("CRITICAL SECURITY: RateLimiter loaded on Client! This module is Server-Only.")
    end
	return self
end

function RateLimiter:Initialize(logger) self._logger = logger end

function RateLimiter:Start()
	self._isRunning = true
	self:_startCleanupTask()
	self._logger:Info("RATELIMITER", "Rate Limiter Ready (Server Secured).")
end

function RateLimiter:Destroy()
	self._logger:Info("RATELIMITER", "Shutdown initiated.")
	self._isRunning = false
	if self._cleanupThread then self._cleanupThread = nil end
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
	if not player or not action then return true end
	local limitConfig = self._limits[action]
	if not limitConfig then return true end

	local playerId = tostring(player.UserId)
	local trackingKey = playerId .. "_" .. action
	local now = os.time()

	if not self._tracking[trackingKey] then
		self._tracking[trackingKey] = { count = 1, windowStart = now }
		return true
	end

	local tracking = self._tracking[trackingKey]
	if now - tracking.windowStart >= limitConfig.window then
		tracking.count = 1
		tracking.windowStart = now
		return true
	end

	if tracking.count >= limitConfig.max then
		self._logger:Warn("RATELIMITER", "Rate limit exceeded", {player = player.Name, action = action})
		return false
	end
	tracking.count = tracking.count + 1
	return true
end

function RateLimiter:SetLimit(action, max, win) self._limits[action] = {max=max, window=win} return true end
function RateLimiter:GetLimit(action) return self._limits[action] end

function RateLimiter:GetPlayerStats(player)
	local playerId = tostring(player.UserId)
	local stats = {}
	local now = os.time()
	for action, limitConfig in pairs(self._limits) do
		local trackingKey = playerId .. "_" .. action
		local tracking = self._tracking[trackingKey]
		if tracking then
			local rem = limitConfig.window - (now - tracking.windowStart)
			stats[action] = { current = tracking.count, limit = limitConfig.max, resetIn = rem < 0 and 0 or rem }
		else
			stats[action] = { current = 0, limit = limitConfig.max, resetIn = 0 }
		end
	end
	return stats
end

function RateLimiter:_startCleanupTask()
	self._cleanupThread = task.spawn(function()
		while self._isRunning do
			task.wait(self._cleanupInterval)
			if not self._isRunning then break end
			self:_cleanupOldData()
		end
	end)
end

function RateLimiter:_cleanupOldData()
	local now = os.time()
	local removedCount = 0
	for trackingKey, tracking in pairs(self._tracking) do
		local pid, act = string.match(trackingKey, "^(%d+)_(.+)$")
		if pid then
			local conf = self._limits[act]
			if conf and (now - tracking.windowStart > conf.window + 300) then
				self._tracking[trackingKey] = nil
				removedCount = removedCount + 1
			end
		end
	end
	if removedCount > 0 then self._logger:Debug("RATELIMITER", "Cleaned up", {count=removedCount}) end
end

return RateLimiter
