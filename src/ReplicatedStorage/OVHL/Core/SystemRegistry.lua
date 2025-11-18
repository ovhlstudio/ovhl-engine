--[[
OVHL ENGINE V3.3.0 (FINAL)
@Component: SystemRegistry (Core Orchestrator)
@Path: ReplicatedStorage.OVHL.Core.SystemRegistry
@Purpose: (V3.3.0) Mengimplementasikan "Two-Phase Initialization" (Initialize + Start) untuk
         menjamin tidak ada race condition.
--]]

local SystemRegistry = {}
SystemRegistry.__index = SystemRegistry

function SystemRegistry.new(ovhl, logger)
    local self = setmetatable({}, SystemRegistry)
    self._systems = {}          -- Penyimpanan instance yang sudah READY
    self._manifests = {}        -- Penyimpanan manifest mentah
    self._loadOrder = {}        -- Hasil TopoSort
    self._status = {}           -- Status (INIT, READY, ERROR)
    self._ovhl = ovhl
    self._logger = logger
    self._logger:Info("SYSTEMREGISTRY", "System Registry V3.3.0 (Two-Phase) initialized")
    return self
end

-- =================================================================
-- V3.3.0: TWO-PHASE ORCHESTRATOR
-- =================================================================

function SystemRegistry:RegisterAndStartFromManifests(manifestsMap)
    self._manifests = manifestsMap
    
    -- 1. Resolve Load Order (TopoSort)
    local success, result = pcall(function()
        return self:_ResolveLoadOrder()
    end)
    
    if not success then
        self._logger:Critical("SYSTEMREGISTRY", "FATAL BOOT ERROR: Circular Dependency!", {error = result})
        return 0, table.getn(self._manifests)
    end
    
    self._loadOrder = result
    
    -- 2. FASE 1: INITIATION (Konstruksi & Referensi)
    local initCount, initFailed = self:_RunInitializationPhase()
    if initFailed > 0 then
        self._logger:Critical("SYSTEMREGISTRY", "FATAL BOOT ERROR: Gagal pada Fase Inisialisasi!", {failed = initFailed})
        return initCount, initFailed
    end

    -- 3. FASE 2: START (Aktivasi & Event Connect)
    local startCount, startFailed = self:_RunStartPhase()
    
    -- 4. Register with OVHL API
    self:_RegisterWithOVHL()
    
    return startCount, startFailed
end

function SystemRegistry:_ResolveLoadOrder()
    local visited = {}      
    local tempMarked = {}   
    local order = {}        
    
    local function visit(systemName)
        if tempMarked[systemName] then 
            error("Circular Dependency: " .. systemName, 2) 
        end
        
        if not visited[systemName] then
            local manifest = self._manifests[systemName]
            if not manifest then
                error("Missing Dependency: Sistem '" .. systemName .. "' tidak ditemukan.", 2)
            end
            
            tempMarked[systemName] = true
            for _, depName in ipairs(manifest.dependencies or {}) do
                visit(depName)
            end
            
            tempMarked[systemName] = nil
            visited[systemName] = true
            table.insert(order, systemName)
        end
    end
    
    for systemName, _ in pairs(self._manifests) do visit(systemName) end
    return order
end

-- FASE 1: Panggil .new() dan :Initialize()
function SystemRegistry:_RunInitializationPhase()
    local startedCount = 0
    local failedCount = 0
    
    self._logger:Info("SYSTEMREGISTRY", "Memulai Fase 1 (Initialize)...")
    
    for _, systemName in ipairs(self._loadOrder) do
        local manifest = self._manifests[systemName]
        
        -- 1. Load (Require) Modul
        local success, moduleClass = pcall(require, manifest.modulePath)
        if not success then
            self._status[systemName] = "ERROR_LOAD"
            self._logger:Error("SYSREG(Fase 1)", "Startup GAGAL", {system = systemName, error = "Gagal require(): " .. tostring(moduleClass)})
            failedCount = failedCount + 1
            continue
        end
        
        -- 2. Buat Instance (.new)
        local success, systemInstance = pcall(moduleClass.new)
        if not success then
            self._status[systemName] = "ERROR_NEW"
            self._logger:Error("SYSREG(Fase 1)", "Startup GAGAL", {system = systemName, error = "Gagal .new(): " .. tostring(systemInstance)})
            failedCount = failedCount + 1
            continue
        end
        
        -- 3. Inisialisasi (:Initialize)
        if systemInstance.Initialize and type(systemInstance.Initialize) == "function" then
            local success, errorMsg = pcall(function() systemInstance:Initialize(self._logger) end)
            if not success then
                self._status[systemName] = "ERROR_INIT"
                self._logger:Error("SYSREG(Fase 1)", "Startup GAGAL", {system = systemName, error = "Gagal Initialize(): " .. errorMsg})
                failedCount = failedCount + 1
                continue
            end
        end
        
        -- 4. Selesai (Fase 1)
        self._status[systemName] = "INIT"
        self._systems[systemName] = systemInstance -- Simpan instance
        startedCount = startedCount + 1
    end
    
    return startedCount, failedCount
end

-- FASE 2: Panggil :Start()
function SystemRegistry:_RunStartPhase()
    local startedCount = 0
    local failedCount = 0

    self._logger:Info("SYSTEMREGISTRY", "Memulai Fase 2 (Start)...")

    for _, systemName in ipairs(self._loadOrder) do
        local systemInstance = self._systems[systemName]
        
        -- Hanya jalankan jika sistem berhasil di-init
        if self._status[systemName] == "INIT" then
            if systemInstance.Start and type(systemInstance.Start) == "function" then
                local success, errorMsg = pcall(function() systemInstance:Start() end)
                if not success then
                    self._status[systemName] = "ERROR_START"
                    self._logger:Error("SYSREG(Fase 2)", "Startup GAGAL", {system = systemName, error = "Gagal Start(): " .. errorMsg})
                    failedCount = failedCount + 1
                else
                    self._status[systemName] = "READY"
                    startedCount = startedCount + 1
                    self._logger:Debug("SYSTEMREGISTRY", "Started (Ready)", {system = systemName})
                end
            else
                -- Sistem pasif (tidak punya :Start()), tandai sebagai READY
                self._status[systemName] = "READY"
                startedCount = startedCount + 1
                self._logger:Debug("SYSTEMREGISTRY", "Started (Pasif)", {system = systemName})
            end
        end
    end
    
    return startedCount, failedCount
end

function SystemRegistry:_RegisterWithOVHL()
    for systemName, systemInstance in pairs(self._systems) do
        if self._status[systemName] == "READY" then
            self._ovhl:RegisterSystem(systemName, systemInstance)
        end
    end
end

-- Getter API
function SystemRegistry:GetSystemStatus(systemName) return self._status[systemName] or "NOT_FOUND" end
function SystemRegistry:GetLoadOrder() return self._loadOrder end

function SystemRegistry:GetHealthStatus()
    local health = {}
    for systemName, manifest in pairs(self._manifests) do
        health[systemName] = {
            Status = self._status[systemName] or "REGISTERED",
            Dependencies = manifest.dependencies or {}
        }
    end
    return health
end

return SystemRegistry

--[[
@End: SystemRegistry.lua
@Version: 3.3.0 (Two-Phase Init)
@See: docs/ADR_V3-3-0.md
--]]
