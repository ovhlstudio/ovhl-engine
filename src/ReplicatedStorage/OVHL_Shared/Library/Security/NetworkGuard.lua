local NetworkGuard = {}
local MAX_DEPTH = 10
function NetworkGuard.SanitizeInbound(data, depth)
    depth = depth or 1
    if depth > MAX_DEPTH then return nil end
    local t = type(data)
    if t == "string" then return string.sub(data, 1, 1000)
    elseif t == "number" then 
        if data ~= data or data == math.huge or data == -math.huge then return 0 end
        return data
    elseif t == "table" then
        local clean = {}
        for k,v in pairs(data) do if type(k)=="string" or type(k)=="number" then clean[k] = NetworkGuard.SanitizeInbound(v, depth+1) end end
        return clean
    elseif t == "function" or t == "thread" or t == "userdata" then return nil end
    return data
end
return NetworkGuard
