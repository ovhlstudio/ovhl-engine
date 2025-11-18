--[[
OVHL FRAMEWORK V.1.0.1
@Component: InputValidator (Security)
@Path: ReplicatedStorage.OVHL.Systems.Security.InputValidator
@Purpose: Robust Input Validation (Clean OOP)
--]]

local InputValidator = {}
InputValidator.__index = InputValidator

function InputValidator.new()
    local self = setmetatable({}, InputValidator)
    self._logger = nil
    self._schemas = self:_getDefaultSchemas()
    return self
end

function InputValidator:Initialize(logger)
    self._logger = logger
    if self._logger then self._logger:Info("INPUTVALIDATOR", "Input Validator initialized") end
end

function InputValidator:_getDefaultSchemas()
    return {
        ActionData = {
            type = "table",
            fields = {
                action = { type = "string", min = 1, max = 50 },
                data = { type = "table", optional = true }
            }
        }
    }
end

function InputValidator:Validate(schemaName, data)
    if not self._schemas[schemaName] then return false, "Unknown schema: " .. tostring(schemaName) end
    local schema = self._schemas[schemaName]
    local result = self:_validateAgainstSchema(schema, data)
    
    if result.valid then
        if self._logger then self._logger:Debug("INPUTVALIDATOR", "Valid", {schema=schemaName}) end
        return true, "Valid"
    else
        if self._logger then self._logger:Warn("INPUTVALIDATOR", "Invalid", {schema=schemaName, error=result.error}) end
        return false, result.error
    end
end

function InputValidator:_validateAgainstSchema(schema, data)
    if schema.type and typeof(data) ~= schema.type then
        return { valid = false, error = "Expected " .. schema.type .. ", got " .. typeof(data) }
    end
    if schema.type == "table" and schema.fields then
        for fieldName, fieldSchema in pairs(schema.fields) do
            local val = data[fieldName]
            if not fieldSchema.optional and val == nil then return { valid = false, error = "Missing: " .. fieldName } end
            if val ~= nil then
                local res = self:_validateField(fieldName, val, fieldSchema)
                if not res.valid then return res end
            end
        end
    end
    return { valid = true }
end

function InputValidator:_validateField(name, val, schema)
    if schema.type and typeof(val) ~= schema.type then return { valid = false, error = "Field " .. name .. " type mismatch" } end
    return { valid = true }
end

function InputValidator:AddSchema(schemaName, schema)
    self._schemas[schemaName] = schema
    if self._logger then self._logger:Debug("INPUTVALIDATOR", "Schema added", {schema = schemaName}) end
end

return InputValidator
