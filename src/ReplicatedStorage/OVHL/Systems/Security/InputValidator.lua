--[[
OVHL ENGINE V3.0.0 - INPUT VALIDATOR SYSTEM
Version: 3.0.0
Path: ReplicatedStorage.OVHL.Systems.Security.InputValidator

FEATURES:
- Structured input validation dengan schemas
- Type checking & range validation
- Custom validation rules
- Security-focused validation patterns
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
    self._logger:Info("INPUTVALIDATOR", "Input Validator initialized")
end

function InputValidator:_getDefaultSchemas()
    return {
        -- Basic action schema untuk module actions
        ActionData = {
            type = "table",
            fields = {
                action = { type = "string", min = 1, max = 50, pattern = "^[%w_]+$" },
                target = { type = "string", optional = true, min = 1, max = 100 },
                amount = { type = "number", optional = true, min = 0, max = 1000000 },
                data = { type = "table", optional = true }
            }
        },
        
        -- Player-related data schema
        PlayerAction = {
            type = "table", 
            fields = {
                playerId = { type = "number", min = 1 },
                actionType = { type = "string", min = 1, max = 30 },
                parameters = { type = "table", optional = true }
            }
        },
        
        -- UI interaction schema
        UIInteraction = {
            type = "table",
            fields = {
                screen = { type = "string", min = 1, max = 50 },
                element = { type = "string", min = 1, max = 50 },
                interaction = { type = "string", min = 1, max = 20 },
                data = { type = "table", optional = true }
            }
        }
    }
end

function InputValidator:Validate(schemaName, data)
    if not self._schemas[schemaName] then
        return false, "Unknown schema: " .. tostring(schemaName)
    end
    
    local schema = self._schemas[schemaName]
    local validationResult = self:_validateAgainstSchema(schema, data)
    
    if validationResult.valid then
        self._logger:Debug("INPUTVALIDATOR", "Input validation passed", {
            schema = schemaName,
            dataType = typeof(data)
        })
        return true, "Valid"
    else
        self._logger:Warn("INPUTVALIDATOR", "Input validation failed", {
            schema = schemaName,
            error = validationResult.error,
            data = data
        })
        return false, validationResult.error
    end
end

function InputValidator:_validateAgainstSchema(schema, data)
    -- Check root type
    if schema.type and typeof(data) ~= schema.type then
        return { valid = false, error = "Expected type " .. schema.type .. ", got " .. typeof(data) }
    end
    
    -- Table validation
    if schema.type == "table" and schema.fields then
        for fieldName, fieldSchema in pairs(schema.fields) do
            local fieldValue = data[fieldName]
            
            -- Check required fields
            if not fieldSchema.optional and fieldValue == nil then
                return { valid = false, error = "Missing required field: " .. fieldName }
            end
            
            -- Validate field if present
            if fieldValue ~= nil then
                local fieldResult = self:_validateField(fieldName, fieldValue, fieldSchema)
                if not fieldResult.valid then
                    return fieldResult
                end
            end
        end
        
        -- Check for unexpected fields
        for fieldName, fieldValue in pairs(data) do
            if not schema.fields[fieldName] then
                self._logger:Debug("INPUTVALIDATOR", "Unexpected field in input", {
                    field = fieldName,
                    value = fieldValue
                })
                -- Note: We don't fail on unexpected fields, just log them
            end
        end
    end
    
    return { valid = true }
end

function InputValidator:_validateField(fieldName, value, schema)
    -- Type checking
    if schema.type and typeof(value) ~= schema.type then
        return { valid = false, error = "Field " .. fieldName .. ": expected " .. schema.type .. ", got " .. typeof(value) }
    end
    
    -- String validation
    if typeof(value) == "string" then
        if schema.min and #value < schema.min then
            return { valid = false, error = "Field " .. fieldName .. ": too short (min " .. schema.min .. ")" }
        end
        
        if schema.max and #value > schema.max then
            return { valid = false, error = "Field " .. fieldName .. ": too long (max " .. schema.max .. ")" }
        end
        
        if schema.pattern and not string.match(value, schema.pattern) then
            return { valid = false, error = "Field " .. fieldName .. ": invalid format" }
        end
    end
    
    -- Number validation
    if typeof(value) == "number" then
        if schema.min and value < schema.min then
            return { valid = false, error = "Field " .. fieldName .. ": too small (min " .. schema.min .. ")" }
        end
        
        if schema.max and value > schema.max then
            return { valid = false, error = "Field " .. fieldName .. ": too large (max " .. schema.max .. ")" }
        end
        
        if schema.whole and value % 1 ~= 0 then
            return { valid = false, error = "Field " .. fieldName .. ": must be whole number" }
        end
    end
    
    -- Table validation (recursive)
    if typeof(value) == "table" and schema.fields then
        local tableResult = self:_validateAgainstSchema(schema, value)
        if not tableResult.valid then
            return tableResult
        end
    end
    
    return { valid = true }
end

function InputValidator:AddSchema(schemaName, schema)
    if self._schemas[schemaName] then
        self._logger:Warn("INPUTVALIDATOR", "Overwriting existing schema", { schema = schemaName })
    end
    
    self._schemas[schemaName] = schema
    self._logger:Debug("INPUTVALIDATOR", "Schema added", { schema = schemaName })
end

function InputValidator:GetSchema(schemaName)
    return self._schemas[schemaName]
end

function InputValidator:GetAvailableSchemas()
    local schemas = {}
    for name, _ in pairs(self._schemas) do
        table.insert(schemas, name)
    end
    return schemas
end

return InputValidator
