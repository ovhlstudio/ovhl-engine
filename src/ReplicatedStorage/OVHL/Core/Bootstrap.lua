--[[
OVHL ENGINE V3.0.0 - SMART BOOTSTRAP SYSTEM (PATCHED)
Version: 3.0.1
Path: ReplicatedStorage.OVHL.Core.Bootstrap
FIXES: 
- Replaced FindFirstChild("path/to") with proper path traversal
--]]

local Bootstrap = {}
Bootstrap.__index = Bootstrap

function Bootstrap:DetectEnvironment()
    if game:GetService("RunService"):IsServer() then
        return "Server"
    else
        return "Client"
    end
end

function Bootstrap:ScanSystems()
    local environment = self:DetectEnvironment()
    local systemsFolder = script.Parent.Parent.Systems
    local loadedSystems = {}
    
    -- System loading rules
    local loadRules = {
        Universal = {
            "Foundation/SmartLogger",
            "Foundation/ConfigLoader", 
            "Security/InputValidator",
            "Security/RateLimiter",
            "Security/PermissionCore",
            "Networking/NetworkingRouter"
        },
        ServerOnly = {
            "Advanced/StateManager",
            "Advanced/PerformanceMonitor"
        },
        ClientOnly = {
            "UI/UIEngine",
            "UI/UIManager",
            "UI/AssetLoader"
        }
    }
    
    -- Load universal systems
    for _, systemPath in ipairs(loadRules.Universal) do
        self:_loadSystem(systemsFolder, systemPath, loadedSystems)
    end
    
    -- Load environment-specific systems
    if environment == "Server" then
        for _, systemPath in ipairs(loadRules.ServerOnly) do
            self:_loadSystem(systemsFolder, systemPath, loadedSystems)
        end
    else
        for _, systemPath in ipairs(loadRules.ClientOnly) do
            self:_loadSystem(systemsFolder, systemPath, loadedSystems)
        end
    end
    
    return loadedSystems
end

function Bootstrap:_loadSystem(systemsFolder, systemPath, loadedSystems)
    -- FIX: Split path by '/' and traverse manually
    local currentObj = systemsFolder
    for part in string.gmatch(systemPath, "[^/]+") do
        currentObj = currentObj:FindFirstChild(part)
        if not currentObj then break end
    end
    
    local fullPath = currentObj
    
    -- Fallback search logic (removed for stability, stick to explicit paths first)
    if not fullPath then
        -- Try searching recursively if explicit path fails
        local folderName = string.match(systemPath, "([^/]+)$") -- Get last part
        if folderName then
            for _, child in ipairs(systemsFolder:GetDescendants()) do
                if child:IsA("ModuleScript") and child.Name == folderName then
                    fullPath = child
                    break
                end
            end
        end
    end
    
    if fullPath and fullPath:IsA("ModuleScript") then
        local success, system = pcall(function()
            local systemModule = require(fullPath)
            if type(systemModule) == "table" and systemModule.new then
                return systemModule.new()
            else
                return systemModule
            end
        end)
        
        if success then
            local systemName = fullPath.Name
            -- Remove extension if present (though .Name usually doesn't have it in Studio)
            if string.sub(systemName, -4) == ".lua" then
                systemName = string.sub(systemName, 1, -5)
            end
            
            loadedSystems[systemName] = system
            return true
        else
            warn("[BOOTSTRAP] Failed to load system: " .. systemPath .. " | Error: " .. tostring(system))
        end
    end
    
    return false
end

function Bootstrap:Initialize()
    local environment = self:DetectEnvironment()
    local OVHL = require(script.Parent.OVHL)
    
    -- Load Logger manually first
    local loggerPath = script.Parent.Parent.Systems.Foundation:FindFirstChild("SmartLogger")
    local logger
    if loggerPath then
        local success, result = pcall(function() 
            local cls = require(loggerPath)
            return cls.new()
        end)
        if success then logger = result end
    end
    
    if logger then
        OVHL:RegisterSystem("SmartLogger", logger)
        logger:Info("BOOTSTRAP", "Smart Bootstrap Initializing", {environment = environment})
    else
        -- Fallback logger
        OVHL:RegisterSystem("SmartLogger", {
            Debug = function(...) end, Info = function(...) print(...) end,
            Warn = function(...) warn(...) end, Error = function(...) warn(...) end,
            Critical = function(...) error(...) end,
        })
        print("🚀 OVHL Bootstrap (Fallback Logger)")
    end
    
    local Logger = OVHL:GetSystem("SmartLogger")
    
    -- Initialize SystemRegistry
    local SystemRegistry = require(script.Parent.SystemRegistry).new()
    SystemRegistry:Initialize(OVHL, Logger)
    OVHL:RegisterSystem("SystemRegistry", SystemRegistry)
    
    Logger:Info("BOOTSTRAP", "Starting OVHL system discovery")
    
    local discoveredSystems = self:ScanSystems()
    
    -- Dependencies Config
    local systemDependencies = {
        ConfigLoader = {},
        SmartLogger = {"ConfigLoader"},
        InputValidator = {"SmartLogger"},
        RateLimiter = {"SmartLogger", "ConfigLoader"},
        PermissionCore = {"SmartLogger", "ConfigLoader"},
        NetworkingRouter = {"SmartLogger"},
        UIEngine = {"SmartLogger", "ConfigLoader"},
        UIManager = {"SmartLogger", "UIEngine"},
        AssetLoader = {"SmartLogger"},
        StateManager = {"SmartLogger", "ConfigLoader"},
        PerformanceMonitor = {"SmartLogger"}
    }
    
    for systemName, systemInstance in pairs(discoveredSystems) do
        local dependencies = systemDependencies[systemName] or {}
        SystemRegistry:RegisterSystem(systemName, systemInstance, dependencies)
    end
    
    local startedCount, failedCount = SystemRegistry:AutoStartSystems()
    SystemRegistry:RegisterWithOVHL()
    
    Logger:Info("BOOTSTRAP", "Bootstrap complete", {
        environment = environment,
        started = startedCount,
        failed = failedCount
    })
    
    OVHL:MarkInitialized()
    return OVHL
end

return Bootstrap
