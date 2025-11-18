--[[
OVHL ENGINE V3.0.0 - ENHANCED KERNEL SYSTEM (PATCHED V2)
Version: 3.0.2
Path: ReplicatedStorage.OVHL.Core.Kernel
FIXES: Fixed Knit.GetService/GetController calling convention
--]]

local Kernel = {}
Kernel.__index = Kernel

function Kernel.new()
    local self = setmetatable({}, Kernel)
    self._modules = {}
    self._services = {}
    self._controllers = {}
    self._environment = self:_detectEnvironment()
    self._logger = nil
    return self
end

function Kernel:_detectEnvironment()
    return game:GetService("RunService"):IsServer() and "Server" or "Client"
end

function Kernel:Initialize(logger)
    self._logger = logger
    self._logger:Info("KERNEL", "Enhanced Kernel initialized", {environment = self._environment})
end

function Kernel:ScanModules()
    if not self._logger then error("Kernel not initialized") end
    local modulesFound = 0
    if self._environment == "Server" then
        modulesFound = self:_scanServerModules()
    else
        modulesFound = self:_scanClientModules()
    end
    self._logger:Info("KERNEL", "Module scan complete", {environment = self._environment, found = modulesFound})
    return modulesFound
end

function Kernel:_scanServerModules()
    local success, serverModules = pcall(function()
        return self:_scanDirectory(game:GetService("ServerScriptService"), "OVHL/Modules")
    end)
    if not success then return 0 end
    local loadedCount = 0
    for _, moduleScript in ipairs(serverModules) do
        if self:_loadService(moduleScript) then loadedCount = loadedCount + 1 end
    end
    return loadedCount
end

function Kernel:_scanClientModules()
    local success, clientModules = pcall(function()
        local starterPlayer = game:GetService("StarterPlayer")
        local playerScripts = starterPlayer:FindFirstChild("StarterPlayerScripts")
        return playerScripts and self:_scanDirectory(playerScripts, "OVHL/Modules") or {}
    end)
    if not success then return 0 end
    local loadedCount = 0
    for _, moduleScript in ipairs(clientModules) do
        if self:_loadController(moduleScript) then loadedCount = loadedCount + 1 end
    end
    return loadedCount
end

function Kernel:_scanDirectory(rootFolder, relativePath)
    local modules = {}
    local targetFolder = rootFolder
    for part in string.gmatch(relativePath, "([^/]+)") do
        targetFolder = targetFolder:FindFirstChild(part)
        if not targetFolder then return modules end
    end
    
    local function scanRecursive(folder)
        for _, item in ipairs(folder:GetChildren()) do
            if item:IsA("ModuleScript") then
                if string.match(item.Name, "Service$") then table.insert(modules, item)
                elseif string.match(item.Name, "Controller$") then table.insert(modules, item) end
            elseif item:IsA("Folder") then scanRecursive(item) end
        end
    end
    if targetFolder then scanRecursive(targetFolder) end
    return modules
end

function Kernel:_loadService(moduleScript)
    if self._environment ~= "Server" then return nil end
    local success, service = pcall(function() return require(moduleScript) end)
    if not success then return nil end
    if service and typeof(service) == "table" and service.KnitInit then
        self._services[service.Name] = service
        return service
    end
    return nil
end

function Kernel:_loadController(moduleScript)
    if self._environment ~= "Client" then return nil end
    local success, controller = pcall(function() return require(moduleScript) end)
    if not success then return nil end
    if controller and typeof(controller) == "table" and controller.KnitInit then
        self._controllers[controller.Name] = controller
        return controller
    end
    return nil
end

function Kernel:RegisterKnitServices(knit)
    local registeredCount = 0
    
    -- Register services (Server)
    for serviceName, service in pairs(self._services) do
        -- FIX: Use colon notation for Knit calls
        local success, registeredService = pcall(function()
            return knit:GetService(serviceName) 
        end)
        
        if success and registeredService then
            registeredCount = registeredCount + 1
        else
            -- Fallback: try dot notation if colon fails (just in case)
             pcall(function() return knit.GetService(serviceName) end)
        end
    end
    
    -- Register controllers (Client)
    for controllerName, controller in pairs(self._controllers) do
        -- FIX: Use colon notation
        local success, registeredController = pcall(function()
            return knit:GetController(controllerName)
        end)
        
        if success and registeredController then
            registeredCount = registeredCount + 1
        end
    end
    
    return registeredCount
end

function Kernel:GetService(serviceName) return self._services[serviceName] end
function Kernel:GetController(controllerName) return self._controllers[controllerName] end

function Kernel:RunVerification()
    self._logger:Info("KERNEL", "Running Kernel verification")
end

return Kernel
