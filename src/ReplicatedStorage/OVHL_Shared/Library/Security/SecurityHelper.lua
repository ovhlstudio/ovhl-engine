-- [[ SECURITY HELPER (RESTORED) ]]
local SecurityHelper = {}

function SecurityHelper.ValidateRequest(player, OVHL, data, options)
    local Validator = require(script.Parent.InputValidator)
    local options = options or {}
    
    -- 1. Rate Limit
    if options.RateLimit then
        local Limiter = OVHL.GetService("RateLimiter")
        if Limiter and not Limiter:Check(player, options.RateLimit) then
            return false, "Rate limit exceeded"
        end
    end
    
    -- 2. Schema
    if options.Schema then
        local valid, err = Validator.Validate(options.Schema, data)
        if not valid then return false, "Invalid Data: " .. tostring(err) end
    end
    
    return true
end

return SecurityHelper
