--[[ @Component: ConfigSchema (Validation) ]]
local ConfigSchema = {}

local REQUIRED_FIELDS = {
    Meta = { Name="string", Type="string", Version="string" }
}

local OPTIONAL_FIELDS = {
    Topbar = { Enabled="boolean" }, -- Loose check for flex
    Network = { Route="string", Requests="table" },
    UI = { Type="string" },
    Behavior = "table",
    Contract = "table"
}

local function validateTable(data, schema, path)
    local errors = {}
    for field, expectedType in pairs(schema) do
        local val = data[field]
        local context = path .. "." .. field
        
        if val == nil then
            table.insert(errors, "Missing required: " .. context)
        elseif type(expectedType) == "table" then
            if type(val) ~= "table" then
                table.insert(errors, context .. " expected table, got " .. type(val))
            else
                local subErrors = validateTable(val, expectedType, context)
                for _, e in ipairs(subErrors) do table.insert(errors, e) end
            end
        elseif type(val) ~= expectedType then
            table.insert(errors, context .. " expected " .. expectedType .. ", got " .. type(val))
        end
    end
    return errors
end

function ConfigSchema.Validate(config, moduleName)
    local errors = validateTable(config, REQUIRED_FIELDS, moduleName)
    
    if #errors > 0 then
        local msg = "[CONFIG VALIDATION FAILED] " .. moduleName .. "\n" .. table.concat(errors, "\n")
        error(msg)
    end
    return true
end

return ConfigSchema
