--[[ @Component: NetworkGuard (Complete) ]]
local Guard = {}

local MAX_DEPTH = 10
local SENSITIVE_KEYS = {"API", "TOKEN", "WEBHOOK", "SECRET", "PASSWORD"}

-- INBOUND CLEANER (CLIENT -> SERVER)
function Guard.CleanIn(val, d)
    d = d or 0
    if d > MAX_DEPTH then return nil end
    
    local t = type(val)
    if t == "string" then return string.sub(val, 1, 1000) end -- Prevent giant strings
    if t == "number" then return (val == val and val) or 0 end -- NaN Check
    if t == "boolean" then return val end
    
    if t == "table" then
        local n = {}
        for k,v in pairs(val) do
            -- Only allow string/number keys
            if type(k) == "string" or type(k) == "number" then
                n[k] = Guard.CleanIn(v, d+1)
            end
        end
        return n
    end
    
    -- Allow common Roblox types (Vector3, etc) pass through strictly?
    -- For V2 safety, we deny Instances to prevent replication abuse unless needed.
    -- (Modify here if you need to pass Parts)
    if typeof(val) == "Instance" then return nil end 
    
    return nil
end

-- OUTBOUND SANITIZER (SERVER -> CLIENT)
-- Fungsi ini yang sebelumnya HILANG (NIL)
function Guard.SanitizeOutbound(val, d)
    d = d or 0
    if d > MAX_DEPTH then return nil end
    
    local t = type(val)
    
    if t == "table" then
        local n = {}
        for k,v in pairs(val) do
            local isSafe = true
            
            -- REDACT SENSITIVE KEYS
            if type(k) == "string" then
                local upper = string.upper(k)
                for _, bad in ipairs(SENSITIVE_KEYS) do
                    if string.find(upper, bad) then 
                        n[k] = "[REDACTED]" 
                        isSafe = false
                        break 
                    end
                end
            end
            
            if isSafe then
                n[k] = Guard.SanitizeOutbound(v, d+1)
            end
        end
        return n
    end
    
    return val
end

return Guard
