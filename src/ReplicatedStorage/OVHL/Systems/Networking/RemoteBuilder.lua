--[[
OVHL ENGINE V1.0.0
@Component: RemoteBuilder (Networking)
@Path: ReplicatedStorage.OVHL.Systems.Networking.RemoteBuilder
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.0.0 - REMOTE BUILDER SYSTEM
Version: 3.0.0
Path: ReplicatedStorage.OVHL.Systems.Networking.RemoteBuilder

FEATURES:
- Type-safe remote communication
- Automatic validation schemas
- Request batching untuk performance
- Connection pooling
--]]

local RemoteBuilder = {}
RemoteBuilder.__index = RemoteBuilder

function RemoteBuilder.new()
    local self = setmetatable({}, RemoteBuilder)
    self._logger = nil
    self._router = nil
    self._endpoints = {}
    self._batchQueue = {}
    self._batchInterval = 0.1 -- 100ms batching window
    self._isBatching = false
    return self
end

function RemoteBuilder:Initialize(logger, router)
    self._logger = logger
    self._router = router
    self._logger:Info("REMOTEBUILDER", "Remote Builder initialized")
end

function RemoteBuilder:CreateEndpoint(name, config)
    config = config or {}
    
    if self._endpoints[name] then
        self._logger:Warn("REMOTEBUILDER", "Endpoint already exists", { endpoint = name })
        return self._endpoints[name]
    end
    
    local endpoint = {
        name = name,
        route = config.route or name,
        validationSchema = config.validationSchema,
        rateLimit = config.rateLimit,
        permission = config.permission,
        type = config.type or "Event" -- Event, Request, Response
    }
    
    self._endpoints[name] = endpoint
    
    -- Register with router jika ada handler
    if config.handler then
        self._router:RegisterHandler(endpoint.route, config.handler, {
            type = endpoint.type
        })
    end
    
    self._logger:Debug("REMOTEBUILDER", "Endpoint created", {
        endpoint = name,
        route = endpoint.route,
        type = endpoint.type
    })
    
    return endpoint
end

function RemoteBuilder:CreateEvent(name, config)
    config = config or {}
    config.type = "Event"
    return self:CreateEndpoint(name, config)
end

function RemoteBuilder:CreateRequest(name, config)
    config = config or {}
    config.type = "Request"
    return self:CreateEndpoint(name, config)
end

function RemoteBuilder:SendEvent(endpointName, data, target)
    local endpoint = self._endpoints[endpointName]
    if not endpoint then
        self._logger:Error("REMOTEBUILDER", "Unknown endpoint", { endpoint = endpointName })
        return false
    end
    
    -- Validation
    if endpoint.validationSchema then
        local valid, error = self:_validateData(data, endpoint.validationSchema)
        if not valid then
            self._logger:Error("REMOTEBUILDER", "Event validation failed", {
                endpoint = endpointName,
                error = error
            })
            return false
        end
    end
    
    -- Send based on environment and target
    if game:GetService("RunService"):IsServer() then
        if target then
            return self._router:SendToClient(target, endpoint.route, data)
        else
            return self._router:SendToAllClients(endpoint.route, data)
        end
    else
        return self._router:SendToServer(endpoint.route, data)
    end
end

function RemoteBuilder:SendRequest(endpointName, data)
    local endpoint = self._endpoints[endpointName]
    if not endpoint then
        self._logger:Error("REMOTEBUILDER", "Unknown endpoint", { endpoint = endpointName })
        return { success = false, error = "Unknown endpoint: " .. endpointName }
    end
    
    -- Validation
    if endpoint.validationSchema then
        local valid, error = self:_validateData(data, endpoint.validationSchema)
        if not valid then
            self._logger:Error("REMOTEBUILDER", "Request validation failed", {
                endpoint = endpointName,
                error = error
            })
            return { success = false, error = "Validation failed: " .. error }
        end
    end
    
    if game:GetService("RunService"):IsServer() then
        return { success = false, error = "Cannot send request from server to server" }
    else
        return self._router:RequestServer(endpoint.route, data)
    end
end

function RemoteBuilder:QueueEvent(endpointName, data)
    if not self._batchQueue[endpointName] then
        self._batchQueue[endpointName] = {}
    end
    
    table.insert(self._batchQueue[endpointName], data)
    
    if not self._isBatching then
        self:_startBatching()
    end
    
    return true
end

function RemoteBuilder:_startBatching()
    if self._isBatching then
        return
    end
    
    self._isBatching = true
    
    task.spawn(function()
        task.wait(self._batchInterval)
        self:_processBatchQueue()
        self._isBatching = false
    end)
end

function RemoteBuilder:_processBatchQueue()
    for endpointName, dataList in pairs(self._batchQueue) do
        if #dataList > 0 then
            local batchData = {
                _batch = true,
                count = #dataList,
                items = dataList
            }
            
            self:SendEvent(endpointName, batchData)
            self._batchQueue[endpointName] = {}
            
            self._logger:Debug("REMOTEBUILDER", "Batch processed", {
                endpoint = endpointName,
                count = #dataList
            })
        end
    end
end

function RemoteBuilder:_validateData(data, schema)
    -- Simple validation - bisa di-extend dengan InputValidator
    if schema.type and typeof(data) ~= schema.type then
        return false, "Expected type " .. schema.type .. ", got " .. typeof(data)
    end
    
    if schema.fields and typeof(data) == "table" then
        for fieldName, fieldSchema in pairs(schema.fields) do
            local fieldValue = data[fieldName]
            
            if not fieldSchema.optional and fieldValue == nil then
                return false, "Missing required field: " .. fieldName
            end
            
            if fieldValue ~= nil and fieldSchema.type and typeof(fieldValue) ~= fieldSchema.type then
                return false, "Field " .. fieldName .. ": expected " .. fieldSchema.type .. ", got " .. typeof(fieldValue)
            end
        end
    end
    
    return true
end

function RemoteBuilder:CreateModuleAPI(moduleName, endpoints)
    local api = {
        _module = moduleName,
        _endpoints = {}
    }
    
    for endpointName, config in pairs(endpoints) do
        local fullEndpointName = moduleName .. "." .. endpointName
        local endpoint = self:CreateEndpoint(fullEndpointName, config)
        
        -- Add to API
        api[endpointName] = function(data, target)
            if config.type == "Request" then
                return self:SendRequest(fullEndpointName, data)
            else
                return self:SendEvent(fullEndpointName, data, target)
            end
        end
        
        api._endpoints[endpointName] = endpoint
    end
    
    self._logger:Info("REMOTEBUILDER", "Module API created", {
        module = moduleName,
        endpoints = table.size(endpoints)
    })
    
    return api
end

function RemoteBuilder:GetEndpoint(name)
    return self._endpoints[name]
end

function RemoteBuilder:GetAllEndpoints()
    return self._endpoints
end

function RemoteBuilder:CleanupModule(moduleName)
    local removedCount = 0
    
    for endpointName, endpoint in pairs(self._endpoints) do
        if string.find(endpointName, "^" .. moduleName .. "%.") then
            self._endpoints[endpointName] = nil
            removedCount = removedCount + 1
        end
    end
    
    self._logger:Info("REMOTEBUILDER", "Module endpoints cleaned up", {
        module = moduleName,
        removed = removedCount
    })
    
    return removedCount
end

return RemoteBuilder

--[[
@End: RemoteBuilder.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

