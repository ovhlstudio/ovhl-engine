--[[ @Component: RateLimiter (Server) ]]
local RateLimiter = {}
RateLimiter.__index = RateLimiter

function RateLimiter.New()
    return setmetatable({_rules={}, _track={}}, RateLimiter)
end

function RateLimiter:SetRule(action, max, window)
    self._rules[action] = {Max=max, Window=window}
end

function RateLimiter:Check(player, action)
    local rule = self._rules[action]
    if not rule then return true end
    
    local key = player.UserId.."_"..action
    local now = os.time()
    local entry = self._track[key]
    
    if not entry or (now - entry.Start > rule.Window) then
        self._track[key] = {Count=1, Start=now}
        return true
    end
    
    if entry.Count >= rule.Max then return false end
    entry.Count += 1
    return true
end
return RateLimiter
