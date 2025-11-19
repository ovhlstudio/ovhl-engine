local OVHL = require(game:GetService("ReplicatedStorage").OVHL_Shared) -- Absolute
local RateLimiter = { Name = "RateLimiter" }
OVHL.RegisterSystem("RateLimiter", RateLimiter)

local _limits = {Default={Max=10,Window=60}}
local _tracker = {}

function RateLimiter:OnInit() OVHL.Logger:Info("SEC", "RateLimiter Init") end
function RateLimiter:OnStart() task.spawn(function() while true do task.wait(60); _tracker={} end end) end
function RateLimiter:SetLimit(a,m,w) _limits[a]={Max=m,Window=w} end
function RateLimiter:Check(p,a)
    local k = p.UserId..a; local r = _limits[a] or _limits.Default; local n = os.time()
    if not _tracker[k] then _tracker[k]={c=1,s=n} return true end
    if n-_tracker[k].s > r.Window then _tracker[k]={c=1,s=n} return true end
    if _tracker[k].c >= r.Max then return false end
    _tracker[k].c += 1; return true
end
return RateLimiter
