--[[
OVHL FRAMEWORK V.1.0.1
@Component: Bootstrap (Core Scanner)
@Path: ReplicatedStorage.OVHL.Core.Bootstrap
@Purpose: System Bootstrapper & Manifest Scanner
@Version: 1.0.1
--]]

local Bootstrap = {}
Bootstrap.__index = Bootstrap

local RS_SYSTEMS = script.Parent.Parent.Systems
-- [PHASE 5] Add Server Systems Path
local SS_SYSTEMS = nil
if game:GetService("RunService"):IsServer() then
    SS_SYSTEMS = game:GetService("ServerScriptService").OVHL.Systems
end

function Bootstrap:DetectEnvironment()
    return game:GetService("RunService"):IsServer() and "Server" or "Client"
end

function Bootstrap:_ScanFolder(folder, logger, environment, results, manifestCache)
    if not folder then return end
    
    -- Pass 1: Index Manifests
    for _, module in ipairs(folder:GetDescendants()) do
        if module:IsA("ModuleScript") and module.Name:match("Manifest$") then
            local systemName = module.Name:gsub("Manifest$", "")
            manifestCache[systemName] = module
        end
    end
    
    -- Pass 2: Match Modules
    for _, module in ipairs(folder:GetDescendants()) do
        if module:IsA("ModuleScript") and not module.Name:match("Manifest$") then
            local systemName = module.Name
            local manifestModule = manifestCache[systemName]
            
            if manifestModule then
                local success, manifestData = pcall(require, manifestModule)
                if success then
                    if not manifestData.name or not manifestData.dependencies or not manifestData.context then
                        logger:Error("BOOTSTRAP", "Manifest Invalid", {file=manifestModule.Name})
                    else
                        if manifestData.context == "Shared" or manifestData.context == environment then
                            manifestData.modulePath = module
                            table.insert(results.manifests, manifestData)
                        end
                    end
                end
                manifestCache[systemName] = nil
            end
        end
    end
end

function Bootstrap:Initialize()
    local environment = self:DetectEnvironment()
    local OVHL = require(script.Parent.OVHL)
    
    -- 1. Load Logger (Manual)
    local logger
    local loggerPath = RS_SYSTEMS.Foundation:FindFirstChild("SmartLogger")
    if loggerPath then
        local success, result = pcall(function() return require(loggerPath).new() end)
        if success then logger = result end
    end
    
    -- Use Dot Notation for Register
    if logger then OVHL.RegisterSystem("SmartLogger", logger) end
    
    -- 2. SystemRegistry
    local SystemRegistry = require(script.Parent.SystemRegistry).new(OVHL, logger)
    OVHL.RegisterSystem("SystemRegistry", SystemRegistry)
    
    if logger then logger:Info("BOOTSTRAP", "Initializing OVHL V.1.0.1 ("..environment..")") end

    local results = { manifests = {}, errors = {}, unmigrated = {} }
    local manifestCache = {}
    
    -- 3. Scan ReplicatedStorage (Shared/Client)
    self:_ScanFolder(RS_SYSTEMS, logger, environment, results, manifestCache)
    
    -- 4. Scan ServerScriptService (Server Only) - [PHASE 5]
    if environment == "Server" then
        self:_ScanFolder(SS_SYSTEMS, logger, environment, results, manifestCache)
    end

    -- 5. Register & Start
    local allManifests = {}
    for _, m in ipairs(results.manifests) do allManifests[m.name] = m end
    
    local started, failed = SystemRegistry:RegisterAndStartFromManifests(allManifests)
    
    if logger then
        logger:Info("BOOTSTRAP", "Boot Complete", {started=started, failed=failed})
    end
    
    OVHL.MarkInitialized()
    return OVHL
end

return Bootstrap
