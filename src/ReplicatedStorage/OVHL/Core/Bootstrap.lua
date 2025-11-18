--[[
OVHL FRAMEWORK V.1.1.0
@Component: Bootstrap (Core Scanner)
@Path: ReplicatedStorage.OVHL.Core.Bootstrap
@Purpose: System Bootstrapper & Manifest Scanner (Physical Separation Support)
@Version: 1.1.0
--]]

local Bootstrap = {}
Bootstrap.__index = Bootstrap

-- [V1.1.0] DEFINISI LOKASI
local RS_SYSTEMS = script.Parent.Parent.Systems
local SS_SYSTEMS = nil
local CL_SYSTEMS = nil

if game:GetService("RunService"):IsServer() then
    SS_SYSTEMS = game:GetService("ServerScriptService").OVHL.Systems
else
    -- Client Path: StarterPlayerScripts.OVHL.Systems
    local playerScripts = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts")
    CL_SYSTEMS = playerScripts:WaitForChild("OVHL"):WaitForChild("Systems")
end

function Bootstrap:DetectEnvironment()
    return game:GetService("RunService"):IsServer() and "Server" or "Client"
end

function Bootstrap:_ScanFolder(folder, logger, environment, results, manifestCache)
    if not folder then return end
    
    -- Pass 1: Index Manifests
    for _, descendant in ipairs(folder:GetDescendants()) do
        if descendant:IsA("ModuleScript") and descendant.Name:match("Manifest$") then
            local systemName = descendant.Name:gsub("Manifest$", "")
            manifestCache[systemName] = descendant
        end
    end
    
    -- Pass 2: Match Modules
    for _, descendant in ipairs(folder:GetDescendants()) do
        if descendant:IsA("ModuleScript") and not descendant.Name:match("Manifest$") then
            local systemName = descendant.Name
            local manifestModule = manifestCache[systemName]
            
            -- Hanya proses jika ada manifest (Strict Mode V1.1.0)
            if manifestModule then
                local success, manifestData = pcall(require, manifestModule)
                if success then
                    if not manifestData.name or not manifestData.dependencies or not manifestData.context then
                        if logger then logger:Error("BOOTSTRAP", "Manifest Invalid", {file=manifestModule.Name}) end
                    else
                        -- [V1.1.0 Logic] Context Validation
                        -- Shared load di semua, Server di Server, Client di Client
                        local loadIt = false
                        if manifestData.context == "Shared" then loadIt = true end
                        if environment == "Server" and manifestData.context == "Server" then loadIt = true end
                        if environment == "Client" and manifestData.context == "Client" then loadIt = true end
                        
                        if loadIt then
                            manifestData.modulePath = descendant
                            table.insert(results.manifests, manifestData)
                        end
                    end
                end
                manifestCache[systemName] = nil -- Consume cache
            end
        end
    end
end

function Bootstrap:Initialize()
    local environment = self:DetectEnvironment()
    local OVHL = require(script.Parent.OVHL)
    
    -- 1. Load Logger (Manual - Shared Foundation)
    local logger
    local loggerPath = RS_SYSTEMS.Foundation:FindFirstChild("SmartLogger")
    if loggerPath then
        local success, result = pcall(function() return require(loggerPath).new() end)
        if success then logger = result end
    end
    
    -- Register Logger
    if logger then OVHL.RegisterSystem("SmartLogger", logger) end
    
    -- 2. SystemRegistry
    local SystemRegistry = require(script.Parent.SystemRegistry).new(OVHL, logger)
    OVHL.RegisterSystem("SystemRegistry", SystemRegistry)
    
    if logger then logger:Info("BOOTSTRAP", "Initializing OVHL V.1.1.0 ("..environment..") - Architecture Split") end

    local results = { manifests = {}, errors = {}, unmigrated = {} }
    local manifestCache = {}
    
    -- 3. SCAN SHARED (ReplicatedStorage)
    self:_ScanFolder(RS_SYSTEMS, logger, environment, results, manifestCache)
    
    -- 4. SCAN SERVER ONLY (ServerScriptService)
    if environment == "Server" and SS_SYSTEMS then
        self:_ScanFolder(SS_SYSTEMS, logger, environment, results, manifestCache)
    end

    -- 5. SCAN CLIENT ONLY (StarterPlayerScripts)
    if environment == "Client" and CL_SYSTEMS then
        self:_ScanFolder(CL_SYSTEMS, logger, environment, results, manifestCache)
    end

    -- 6. Register & Start
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
