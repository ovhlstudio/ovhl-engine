--[[ @Component: RateLimiter (Hardened V15) ]]
local RateLimiter = {}
RateLimiter.__index = RateLimiter

function RateLimiter.New()
    return setmetatable({_rules={}, _track={}}, RateLimiter)
end

function RateLimiter:SetRule(action, max, window)
    -- Safety Fallback: Default to 1 second if nil
    self._rules[action] = {
        Max = max or 10,
        Window = window or 1 -- [FIX] Anti-Crash Default
    }
end

function RateLimiter:Check(player, action)
    local rule = self._rules[action]
    if not rule then return true end
    
    local key = player.UserId.."_"..action
    local now = os.time()
    local entry = self._track[key]
    
    -- [FIX] rule.Window is now guaranteed to be a number
    if not entry or (now - entry.Start > rule.Window) then
        self._track[key] = {Count=1, Start=now}
        return true
    end
    
    if entry.Count >= rule.Max then return false end
    entry.Count += 1
    return true
end
return RateLimiter
