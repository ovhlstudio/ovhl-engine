--[[
    Type Validator - Strict Runtime Checking
    Part of Hybrid Security System (Inbound Defense)
]]

local TypeValidator = {}

local TYPE_CHECKERS = {
    string = function(v) return type(v) == 'string' end,
    number = function(v) return type(v) == 'number' end,
    boolean = function(v) return type(v) == 'boolean' end,
    table = function(v) return type(v) == 'table' end,
    ['function'] = function(v) return type(v) == 'function' end,
    Instance = function(v) return typeof(v) == 'Instance' end,
    Vector3 = function(v) return typeof(v) == 'Vector3' end,
    Color3 = function(v) return typeof(v) == 'Color3' end,
    Player = function(v) return typeof(v) == 'Instance' and v:IsA('Player') end,
    any = function(v) return true end
}

function TypeValidator.Validate(args, schema)
    if not schema then return true end
    local errors = {}

    for i, spec in ipairs(schema) do
        local val = args[i]
        local name = spec.name or ('arg #' .. i)
        
        -- Handle simple string types for backward compatibility
        local requiredType = type(spec) == 'string' and spec or spec.type
        local isOptional = (type(spec) == 'table' and spec.optional)

        if val == nil then
            if not isOptional then
                table.insert(errors, string.format('%s is required', name))
            end
        else
            local checker = TYPE_CHECKERS[requiredType]
            if not checker then
                -- Fallback to basic type check
                if type(val) ~= requiredType and typeof(val) ~= requiredType then
                     table.insert(errors, string.format('%s expected %s, got %s', name, requiredType, typeof(val)))
                end
            elseif not checker(val) then
                table.insert(errors, string.format('%s invalid format for %s', name, requiredType))
            end
        end
    end

    if #errors > 0 then return false, table.concat(errors, '; ') end
    return true
end

return TypeValidator
