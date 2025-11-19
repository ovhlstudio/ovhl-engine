-- [[ INPUT VALIDATOR V2 ]]
local Validator = {}

function Validator.Validate(schema, data)
    if schema.type and type(data) ~= schema.type then
        return false, "Expected " .. schema.type .. ", got " .. type(data)
    end
    
    if schema.fields and type(data) == "table" then
        for field, rule in pairs(schema.fields) do
            local val = data[field]
            if not rule.optional and val == nil then
                return false, "Missing field: " .. field
            end
            if val ~= nil and rule.type and type(val) ~= rule.type then
                return false, "Field " .. field .. " type mismatch"
            end
        end
    end
    return true
end

return Validator
