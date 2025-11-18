--[[
OVHL ENGINE V1.0.0
@Component: Bootstrap (Core)
@Path: ReplicatedStorage.OVHL.Core.Bootstrap
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.2.3 (HOTFIX)
@Component: Bootstrap (Core Scanner)
@Path: ReplicatedStorage.OVHL.Core.Bootstrap
@Purpose: (V3.2.3) Menambahkan Environment Awareness (Server/Client/Shared) ke Scanner Manifest.
--]]

local Bootstrap = {}
Bootstrap.__index = Bootstrap

local SYSTEMS_FOLDER = script.Parent.Parent.Systems

function Bootstrap:DetectEnvironment()
    if game:GetService("RunService"):IsServer() then
        return "Server"
    else
        return "Client"
    end
end

-- =================================================================
-- V3.2.3: SCANNER LOGIC (ENVIRONMENT AWARE)
-- =================================================================
function Bootstrap:_ScanManifests(logger, environment)
    local results = {
        manifests = {},
        errors = {},
        unmigrated = {}
    }
    local manifestCache = {}

    -- === PASS 1: INDEKS SEMUA MANIFEST ===
    for _, module in ipairs(SYSTEMS_FOLDER:GetDescendants()) do
        if module:IsA("ModuleScript") and module.Name:match("Manifest$") then
            local systemName = module.Name:gsub("Manifest$", "")
            manifestCache[systemName] = module
        end
    end
    
    -- === PASS 2: COCOKKAN MODUL UTAMA DENGAN MANIFEST (DAN CEK ENVIRONMENT) ===
    for _, module in ipairs(SYSTEMS_FOLDER:GetDescendants()) do
        if module:IsA("ModuleScript") and not module.Name:match("Manifest$") then
            local systemName = module.Name
            local manifestModule = manifestCache[systemName]
            
            if manifestModule then
                -- V3.2.2 DITEMUKAN (Memiliki Manifest)
                local success, manifestData = pcall(require, manifestModule)
                
                if success then
                    -- Validasi manifest
                    if not manifestData.name or not manifestData.dependencies or not manifestData.context then
                        logger:Error("BOOTSTRAP", "Manifest Rusak!", {file = manifestModule:GetFullName(), details="Missing name/dependencies/context"})
                        results.errors[systemName] = "Manifest rusak (missing name/dependencies/context)"
                    else
                        -- [HOTFIX V3.2.3] CEK ENVIRONMENT
                        local context = manifestData.context -- "Server", "Client", atau "Shared"
                        if context == "Shared" or context == environment then
                            -- Load sistem ini
                            manifestData.modulePath = module
                            table.insert(results.manifests, manifestData)
                        else
                            -- Ini adalah sistem untuk environment lain, abaikan (bukan error)
                            logger:Debug("BOOTSTRAP", "Skipping system for env", {system=systemName, context=context})
                        end
                    end
                else
                    logger:Error("BOOTSTRAP", "Gagal require() manifest!", {file = manifestModule:GetFullName(), error = manifestData})
                    results.errors[systemName] = "Gagal require() manifest: " .. tostring(manifestData)
                end
                
                manifestCache[systemName] = nil
            else
                -- V3.1.0 DITEMUKAN (Tanpa Manifest)
                if module:IsDescendantOf(SYSTEMS_FOLDER.Foundation) or 
                   module:IsDescendantOf(SYSTEMS_FOLDER.Security) or
                   module:IsDescendantOf(SYSTEMS_FOLDER.Networking) or
                   module:IsDescendantOf(SYSTEMS_FOLDER.UI) or
                   module:IsDescendantOf(SYSTEMS_FOLDER.Advanced) then
                   
                    table.insert(results.unmigrated, module)
                end
            end
        end
    end
    
    -- === PASS 3: LAPORKAN MANIFEST YANG MENGGANTUNG ===
    for systemName, module in pairs(manifestCache) do
        logger:Warn("BOOTSTRAP", "Dangling Manifest Ditemukan", {
            details = "Ditemukan ".. module.Name .. " tetapi ".. systemName .. ".lua tidak ditemukan."
        })
        results.errors[systemName] = "Dangling Manifest (file *.lua utama hilang)"
    end
    
    return results
end

-- =================================================================
-- V3.1.0: FALLBACK LOGIC (UNTUK HYBRID MIGRATION)
-- =================================================================
function Bootstrap:_GetLegacySystems(logger, unmigratedModules, environment)
    local legacyManifests = {}
    
    -- SSoT V3.1.0
    local legacyDependencies = {
        ConfigLoader = {deps = {}, context = "Shared"},
        SmartLogger = {deps = {"ConfigLoader"}, context = "Shared"},
        InputValidator = {deps = {"SmartLogger"}, context = "Shared"},
        RateLimiter = {deps = {"SmartLogger", "ConfigLoader"}, context = "Shared"},
        PermissionCore = {deps = {"SmartLogger", "ConfigLoader"}, context = "Shared"},
        NetworkingRouter = {deps = {"SmartLogger"}, context = "Shared"},
        
        UIEngine = {deps = {"SmartLogger", "ConfigLoader"}, context = "Client"},
        UIManager = {deps = {"SmartLogger", "UIEngine"}, context = "Client"},
        AssetLoader = {deps = {"SmartLogger"}, context = "Client"}
    }
    
    for _, module in ipairs(unmigratedModules) do
        local systemName = module.Name
        local legacyInfo = legacyDependencies[systemName]
        
        if legacyInfo then
            -- [HOTFIX V3.2.3] CEK ENVIRONMENT
            if legacyInfo.context == "Shared" or legacyInfo.context == environment then
                logger:Warn("BOOTSTRAP", "Sistem V3.1.0 (Legacy) Terdeteksi", {
                    system = systemName,
                    details = "Mohon buat file " .. systemName .. "Manifest.lua"
                })
                
                table.insert(legacyManifests, {
                    name = systemName,
                    dependencies = legacyInfo.deps,
                    modulePath = module
                })
            end
        end
    end
    
    return legacyManifests
end

-- =================================================================
-- V3.2.3: BOOTSTRAP INITIALIZE (FUNGSI UTAMA)
-- =================================================================
function Bootstrap:Initialize()
    local environment = self:DetectEnvironment()
    local OVHL = require(script.Parent.OVHL)
    
    -- 1. Load Logger (Manual)
    local logger
    local loggerPath = SYSTEMS_FOLDER.Foundation:FindFirstChild("SmartLogger")
    if loggerPath then
        local success, result = pcall(function() return require(loggerPath).new() end)
        if success then logger = result end
    end
    
    if logger then
        OVHL:RegisterSystem("SmartLogger", logger)
        logger:Info("BOOTSTRAP", "Smart Bootstrap V3.2.3 (Patched) Initializing", {environment = environment})
    else
        logger = {
            Debug = function(...) end, Info = function(...) print(...) end,
            Warn = function(...) warn(...) end, Error = function(...) warn(...) end,
            Critical = function(...) error(...) end,
        }
        OVHL:RegisterSystem("SmartLogger", logger)
        print("🚀 OVHL Bootstrap V3.2.3 (Fallback Logger)")
    end

    -- 2. Dapatkan SystemRegistry
    local SystemRegistry = require(script.Parent.SystemRegistry).new(OVHL, logger)
    OVHL:RegisterSystem("SystemRegistry", SystemRegistry)
    
    logger:Info("BOOTSTRAP", "Memulai V3.2.3 Manifest Scan (Env-Aware)...")

    -- 3. FASE 1: Pindai V3.2.2 (dengan cek Env)
    local scanResult = self:_ScanManifests(logger, environment)
    
    -- 4. FASE 2: Pindai V3.1.0 (dengan cek Env)
    local legacyManifests = self:_GetLegacySystems(logger, scanResult.unmigrated, environment)
    
    -- 5. FASE 3: Gabungkan Daftar
    local allManifests = {}
    for _, m in ipairs(scanResult.manifests) do allManifests[m.name] = m end
    for _, m in ipairs(legacyManifests) do
        if not allManifests[m.name] then
            allManifests[m.name] = m
        end
    end
    
    logger:Info("BOOTSTRAP", "Scan Selesai", {
        migrated = #scanResult.manifests,
        legacy = #legacyManifests,
        errors = #scanResult.errors,
        totalLoaded = #scanResult.manifests + #legacyManifests
    })

    -- 6. FASE 4: Serahkan ke Orchestrator
    local startedCount, failedCount = SystemRegistry:RegisterAndStartFromManifests(allManifests)
    
    logger:Info("BOOTSTRAP", "Bootstrap V3.2.3 complete", {
        environment = environment,
        started = startedCount,
        failed = failedCount
    })
    
    OVHL:MarkInitialized()
    return OVHL
end

return Bootstrap

--[[
@End: Bootstrap.lua
@Version: 3.2.3
@See: docs/ADR_V3-2-2.md
--]]

--[[
@End: Bootstrap.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

