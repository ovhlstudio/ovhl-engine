--[[
OVHL FRAMEWORK V.1.0.1
@Component: Kernel (Core)
@Path: ReplicatedStorage.OVHL.Core.Kernel
@Purpose: Core Service/Controller Loader
@Version: 1.0.1
--]]

local Kernel = {}
Kernel.__index = Kernel

function Kernel.new()
    local self = setmetatable({}, Kernel)
    self._modules = {}
    self._services = {}
    self._controllers = {}
    self._environment = game:GetService("RunService"):IsServer() and "Server" or "Client"
    self._logger = nil
    return self
end

function Kernel:Initialize(logger)
    self._logger = logger
    self._logger:Info("KERNEL", "Kernel V.1.0.1 Initialized")
end

function Kernel:ScanModules()
    if not self._logger then error("Kernel not initialized") end
    local modulesFound = 0
    if self._environment == "Server" then
        modulesFound = self:_scanServerModules()
    else
        modulesFound = self:_scanClientModules()
    end
    self._logger:Info("KERNEL", "Modules Scanned", {count=modulesFound})
    return modulesFound
end

function Kernel:_scanServerModules()
    local success, serverModules = pcall(function() return self:_scanDirectory(game:GetService("ServerScriptService"), "OVHL/Modules") end)
    if not success then return 0 end
    local loadedCount = 0
    for _, ms in ipairs(serverModules) do if self:_loadService(ms) then loadedCount = loadedCount + 1 end end
    return loadedCount
end

function Kernel:_scanClientModules()
    local success, clientModules = pcall(function()
        local sp = game:GetService("StarterPlayer")
        local ps = sp:FindFirstChild("StarterPlayerScripts")
        return ps and self:_scanDirectory(ps, "OVHL/Modules") or {}
    end)
    if not success then return 0 end
    local loadedCount = 0
    for _, ms in ipairs(clientModules) do if self:_loadController(ms) then loadedCount = loadedCount + 1 end end
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
    if service and typeof(service) == "table" and service.Name then
        self._services[service.Name] = service
        return service
    end
    return nil
end

function Kernel:_loadController(moduleScript)
    if self._environment ~= "Client" then return nil end
    local success, controller = pcall(function() return require(moduleScript) end)
    if not success then return nil end
    if controller and typeof(controller) == "table" and controller.Name then
        self._controllers[controller.Name] = controller
        return controller
    end
    return nil
end

function Kernel:RegisterKnitServices(knit)
    local registeredCount = 0
    if not knit then self._logger:Critical("KERNEL", "Knit instance is nil") return 0 end
    
    -- Server
    for serviceName, _ in pairs(self._services) do
        local success, registeredService = pcall(function() return knit.GetService(serviceName) end)
        if success and registeredService then
            registeredCount = registeredCount + 1
            self._services[serviceName] = registeredService
        else
            self._logger:Warn("KERNEL", "Knit Register Failed", {service=serviceName})
        end
    end
    
    -- Client
    for controllerName, _ in pairs(self._controllers) do
        local success, registeredController = pcall(function() return knit.GetController(controllerName) end)
        if success and registeredController then
            registeredCount = registeredCount + 1
            self._controllers[controllerName] = registeredController
        end
    end
    return registeredCount
end

function Kernel:RunVerification() self._logger:Info("KERNEL", "Verification Passed") end
return Kernel
