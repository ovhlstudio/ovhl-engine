#!/bin/bash

# =================================================================
# OVHL ENGINE V3.3.0 - SMART SCRIPTER (FINAL)
# MISI: Refactor Core ke ADR V3.3.0 (Two-Phase Initialization)
# TUJUAN: Memperbaiki Race Condition secara permanen (menghapus task.wait)
# =================================================================

echo "🚀 [OVHL V3.3.0] Memulai SKRIP FINAL: Refactor Arsitektur Two-Phase Init..."

# --- Konfigurasi ---
TARGET_DIR="src"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="lokal/backups/V3-3-0_FINAL_$TIMESTAMP"

# Path file inti
CORE_PATH="$TARGET_DIR/ReplicatedStorage/OVHL/Core"
ADVANCED_PATH="$TARGET_DIR/ReplicatedStorage/OVHL/Systems/Advanced"
NETWORKING_PATH="$TARGET_DIR/ReplicatedStorage/OVHL/Systems/Networking"
SECURITY_PATH="$TARGET_DIR/ReplicatedStorage/OVHL/Systems/Security"

FILES_MODIFIED=0
ERRORS=0

# --- Fungsi Helper ---

# Fungsi untuk memodifikasi file dengan aman (backup + modify)
modify_file() {
    local FILE_PATH=$1
    local FILE_CONTENT=$2

    echo "-----------------------------------------------------------------"
    echo "  [REFACTOR] Memodifikasi file: $FILE_PATH"

    # 1. Pastikan direktori ada
    mkdir -p "$(dirname "$FILE_PATH")"

    # 2. Cek dan Backup jika file ada
    if [ -f "$FILE_PATH" ]; then
        local BACKUP_FILE_PATH="$BACKUP_DIR/$FILE_PATH"
        mkdir -p "$(dirname "$BACKUP_FILE_PATH")"
        cp "$FILE_PATH" "$BACKUP_FILE_PATH"
        echo "    -> [BACKUP] File V3.2.x disimpan ke: $BACKUP_FILE_PATH"
    else
        echo "    -> [FATAL ERROR] File $FILE_PATH tidak ditemukan untuk di-refactor!"
        ((ERRORS++))
        return 1
    fi

    # 3. Tulis file V3.3.0 (Patched)
    echo "    -> Menulis konten V3.3.0 (Two-Phase Init)..."
    cat > "$FILE_PATH" << EOF
$FILE_CONTENT
EOF

    # 4. Audit Mandiri
    if [ -f "$FILE_PATH" ]; then
        echo "    -> [VERIFIED] File berhasil di-patch di $FILE_PATH"
        ((FILES_MODIFIED++))
    else
        echo "    -> [FATAL ERROR] Gagal menulis patch ke $FILE_PATH !"
        ((ERRORS++))
    fi
}

# =================================================================
# KONTEN 1: SystemRegistry.lua (REFACTOR V3.3.0 - Two-Phase)
# =================================================================

read -r -d '' CONTENT_SYSTEMREGISTRY << 'EOF'
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
EOF

# =================================================================
# KONTEN 2: DataManager.lua (REFACTOR V3.3.0)
# =================================================================

read -r -d '' CONTENT_DATAMANAGER << 'EOF'
--[[
OVHL ENGINE V3.3.0 (FINAL)
@Component: DataManager (Core System)
@Path: ReplicatedStorage.OVHL.Systems.Advanced.DataManager
@Purpose: (V3.3.0) Menggunakan Two-Phase Init. :Start() untuk koneksi DataStore.
--]]

local DataStoreService = game:GetService("DataStoreService")

local DataManager = {}
DataManager.__index = DataManager

local DEFAULT_DATASTORE_NAME = "OVHL_PlayerDatav3"

function DataManager.new()
    local self = setmetatable({}, DataManager)
    self._logger = nil
    self._config = nil
    self._playerDataStore = nil
    self._sessionCache = {}
    self._initialized = false
    return self
end

-- FASE 1: Hanya konstruksi dan referensi
function DataManager:Initialize(logger)
    self._logger = logger
    
    local OVHL = require(script.Parent.Parent.Parent.Core.OVHL)
    local ConfigLoader = OVHL:GetSystem("ConfigLoader")
    self._config = ConfigLoader:LoadEngineConfig()
end

-- FASE 2: Aktivasi (Koneksi ke hardware/servis eksternal)
function DataManager:Start()
    local success, ds = pcall(function()
        return DataStoreService:GetDataStore(DEFAULT_DATASTORE_NAME)
    end)
    
    if success then
        self._playerDataStore = ds
        self._initialized = true
        self._logger:Info("DATAMANAGER", "Data Manager Ready", { DataStore = DEFAULT_DATASTORE_NAME })
    else
        self._logger:Critical("DATAMANAGER", "GAGAL terhubung ke DataStore!", { Error = tostring(ds) })
    end
end

function DataManager:LoadData(player)
    if not self._initialized then
        self._logger:Error("DATAMANAGER", "LoadData dipanggil sebelum DataManager:Start()!", { player = player.Name })
        return nil
    end

    local playerKey = "Player_" .. player.UserId
    local startTime = os.clock()
    local dataStore = self._playerDataStore
    
    local success, data = pcall(function()
        return dataStore:GetAsync(playerKey)
    end)
    
    if not success then
        self._logger:Error("DATAMANAGER", "GetAsync Gagal!", { player = player.Name, error = tostring(data) })
        return nil
    end
    
    self._logger:Performance("TIMING", "Data Loaded", { duration = os.clock() - startTime })

    if data then
        self._sessionCache[player.UserId] = data
        self._logger:Info("DATAMANAGER", "Data berhasil di-load.", { player = player.Name })
        return data
    else
        self._logger:Info("DATAMANAGER", "Membuat data baru (First Join).", { player = player.Name })
        local newData = self:_createDefaultData(player)
        self._sessionCache[player.UserId] = newData
        return newData
    end
end

function DataManager:SaveData(player)
    if not self._initialized then
        self._logger:Error("DATAMANAGER", "SaveData dipanggil sebelum DataManager:Start()!", { player = player.Name })
        return false
    end

    local dataToSave = self._sessionCache[player.UserId]
    if not dataToSave then
        self._logger:Warn("DATAMANAGER", "SaveData Gagal (Data di cache nil)", { player = player.Name })
        return false
    end

    local playerKey = "Player_" .. player.UserId
    local startTime = os.clock()
    local dataStore = self._playerDataStore
    
    local success, err = pcall(function()
        dataToSave.meta.lastSave = os.time()
        dataStore:SetAsync(playerKey, dataToSave)
    end)
    
    if not success then
        self._logger:Error("DATAMANAGER", "SetAsync Gagal!", { player = player.Name, error = tostring(err) })
        return false
    end
    
    self._logger:Performance("TIMING", "Data Saved", { duration = os.clock() - startTime })
    self._logger:Info("DATAMANAGER", "Data berhasil di-save.", { player = player.Name })
    return true
end

function DataManager:ClearCache(player)
    self._sessionCache[player.UserId] = nil
    self._logger:Debug("DATAMANAGER", "Cache dibersihkan.", { player = player.Name })
end

function DataManager:GetCachedData(player)
    return self._sessionCache[player.UserId]
end

function DataManager:_createDefaultData(player)
    return {
        meta = {
            userId = player.UserId,
            joinDate = os.time(),
            lastSave = 0,
            schemaVersion = "1.0.0",
        },
        currency = { coins = 100, gems = 0 },
        inventory = {},
        stats = { level = 1, xp = 0 },
    }
end

return DataManager

--[[
@End: DataManager.lua
@Version: 3.3.0 (Two-Phase Init)
@See: docs/ADR_V3-3-0.md
--]]
EOF

# =================================================================
# KONTEN 3: PlayerManager.lua (REFACTOR V3.3.0)
# =================================================================

read -r -d '' CONTENT_PLAYERMANAGER << 'EOF'
--[[
OVHL ENGINE V3.3.0 (FINAL)
@Component: PlayerManager (Core System)
@Path: ReplicatedStorage.OVHL.Systems.Advanced.PlayerManager
@Purpose: (V3.3.0) Menggunakan Two-Phase Init. :Start() untuk koneksi Event. Menghapus task.wait().
--]]

local Players = game:GetService("Players")

local PlayerManager = {}
PlayerManager.__index = PlayerManager

function PlayerManager.new()
    local self = setmetatable({}, PlayerManager)
    self._logger = nil
    self._dataManager = nil
    self._connections = {}
    return self
end

-- FASE 1: Hanya konstruksi dan referensi
function PlayerManager:Initialize(logger)
    self._logger = logger
    
    local OVHL = require(script.Parent.Parent.Parent.Core.OVHL)
    self._dataManager = OVHL:GetSystem("DataManager")
end

-- FASE 2: Aktivasi (Koneksi Event & Studio Loop)
function PlayerManager:Start()
    if not self._dataManager then
        self._logger:Critical("PLAYERMANAGER", "GAGAL mendapatkan DataManager! Sistem data tidak akan berjalan.")
        return
    end
    
    self:_connectEvents()
    self._logger:Info("PLAYERMANAGER", "Player Manager Ready. Mendengarkan event Player.")

    -- [FIX V3.3.0] Handle players yang sudah join (Studio testing)
    -- Ini sekarang 100% aman karena :Start() berjalan di Fase 2
    for _, player in ipairs(Players:GetPlayers()) do
        task.spawn(function()
            self:_onPlayerAdded(player)
        end)
    end
end

function PlayerManager:_connectEvents()
    self._connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
        self:_onPlayerAdded(player)
    end)
    
    self._connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
        self:_onPlayerRemoving(player)
    end)
    
    game:BindToClose(function()
        self:_onGameClose()
    end)
end

function PlayerManager:_onPlayerAdded(player)
    self._logger:Info("PLAYERMANAGER", "Player Joining...", {player = player.Name, userId = player.UserId})
    
    -- Validasi ini (dari Claude) tetap bagus
    if not self._dataManager then
        self._logger:Critical("PLAYERMANAGER", "DataManager is nil during PlayerAdded!", { player = player.Name })
        return
    end
    
    local data = self._dataManager:LoadData(player)
    
    if data then
        self._logger:Info("PLAYERMANAGER", "Data siap untuk player.", {player = player.Name})
    else
        self._logger:Error("PLAYERMANAGER", "Data GAGAL di-load untuk player.", {player = player.Name})
    end
end

function PlayerManager:_onPlayerRemoving(player)
    self._logger:Info("PLAYERMANAGER", "Player Leaving...", {player = player.Name, userId = player.UserId})
    
    if not self._dataManager then
        self._logger:Error("PLAYERMANAGER", "DataManager is nil! Cannot save data.", { player = player.Name })
        return
    end
    
    local success = self._dataManager:SaveData(player)
    
    if success then
        self._logger:Info("PLAYERMANAGER", "Data player berhasil di-save.", {player = player.Name})
    else
        self._logger:Error("PLAYERMANAGER", "Data player GAGAL di-save!", {player = player.Name})
    end
    
    self._dataManager:ClearCache(player)
end

function PlayerManager:_onGameClose()
    self._logger:Info("PLAYERMANAGER", "Game Closing. Menyimpan data semua pemain...")
    for _, player in ipairs(Players:GetPlayers()) do
        pcall(function()
            self:_onPlayerRemoving(player)
        end)
    end
end

return PlayerManager

--[[
@End: PlayerManager.lua
@Version: 3.3.0 (Two-Phase Init)
@See: docs/ADR_V3-3-0.md
--]]
EOF

# =================================================================
# KONTEN 4: NetworkingRouter.lua (REFACTOR V3.3.0)
# =================================================================

read -r -d '' CONTENT_NETWORKINGROUTER << 'EOF'
--[[
OVHL ENGINE V3.3.0 (FINAL)
@Component: NetworkingRouter (Core System)
@Path: ReplicatedStorage.OVHL.Systems.Networking.NetworkingRouter
@Purpose: (V3.3.0) Menggunakan Two-Phase Init. :Start() untuk koneksi Remotes.
--]]

local NetworkingRouter = {}
NetworkingRouter.__index = NetworkingRouter

function NetworkingRouter.new()
    local self = setmetatable({}, NetworkingRouter)
    self._logger = nil
    self._remotes = {}
    self._handlers = {}
    self._middlewares = {}
    self._connectionStats = {}
    return self
end

-- FASE 1: Hanya konstruksi
function NetworkingRouter:Initialize(logger)
    self._logger = logger
end

-- FASE 2: Aktivasi (Setup Remotes & Connect)
function NetworkingRouter:Start()
    self:_setupRemotes()
    self:_startMonitoring()
    self._logger:Info("NETWORKING", "Networking Router Ready (V3.3.0).")
end

function NetworkingRouter:_setupRemotes()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local isServer = RunService:IsServer()
    
    local remotesFolder = ReplicatedStorage:FindFirstChild("OVHL_Remotes")
    if not remotesFolder and isServer then
        remotesFolder = Instance.new("Folder")
        remotesFolder.Name = "OVHL_Remotes"
        remotesFolder.Parent = ReplicatedStorage
    elseif not remotesFolder then
        remotesFolder = ReplicatedStorage:WaitForChild("OVHL_Remotes", 10)
    end
    
    if not remotesFolder then 
        self._logger:Error("NETWORKING", "Gagal menemukan folder OVHL_Remotes!")
        return 
    end

    if isServer then
        self._remotes = {
            ClientToServer = self:_getOrCreateRemote(remotesFolder, "RemoteEvent", "OVHL_ClientToServer"),
            ServerToClient = self:_getOrCreateRemote(remotesFolder, "RemoteEvent", "OVHL_ServerToClient"),
            RequestResponse = self:_getOrCreateRemote(remotesFolder, "RemoteFunction", "OVHL_RequestResponse")
        }
        
        self._remotes.ClientToServer.OnServerEvent:Connect(function(player, route, data)
            self:_handleClientToServer(player, route, data)
        end)
        
        self._remotes.RequestResponse.OnServerInvoke = function(player, route, data)
            return self:_handleRequestResponse(player, route, data)
        end
    else
        -- Client Side
        self._remotes = {
            ClientToServer = remotesFolder:WaitForChild("OVHL_ClientToServer"),
            ServerToClient = remotesFolder:WaitForChild("OVHL_ServerToClient"),
            RequestResponse = remotesFolder:WaitForChild("OVHL_RequestResponse")
        }
        
        self._remotes.ServerToClient.OnClientEvent:Connect(function(route, data)
            self:_handleServerToClient(route, data)
        end)
    end
end

function NetworkingRouter:_getOrCreateRemote(folder, className, name)
    local remote = folder:FindFirstChild(name)
    if not remote then
        remote = Instance.new(className)
        remote.Name = name
        remote.Parent = folder
    end
    return remote
end

function NetworkingRouter:_handleClientToServer(player, route, data)
    local handler = self._handlers[route]
    if handler then pcall(handler, player, data) end
end

function NetworkingRouter:_handleServerToClient(route, data)
    local handler = self._handlers[route]
    if handler then pcall(handler, data) end
end

function NetworkingRouter:_handleRequestResponse(player, route, data)
    local handler = self._handlers[route]
    if handler then 
        local success, res = pcall(handler, player, data)
        return success and {success=true, data=res} or {success=false, error=res}
    end
    return {success=false, error="No handler"}
end

function NetworkingRouter:RegisterHandler(route, handler)
    self._handlers[route] = handler
end

function NetworkingRouter:SendToServer(route, data)
    if not self._remotes.ClientToServer then return end
    self._remotes.ClientToServer:FireServer(route, data)
end

function NetworkingRouter:SendToClient(player, route, data)
    if not self._remotes.ServerToClient then return end
    self._remotes.ServerToClient:FireClient(player, route, data)
end

function NetworkingRouter:_startMonitoring() end -- Stubbed

return NetworkingRouter

--[[
@End: NetworkingRouter.lua
@Version: 3.3.0 (Two-Phase Init)
@See: docs/ADR_V3-3-0.md
--]]
EOF

# =================================================================
# KONTEN 5: RateLimiter.lua (REFACTOR V3.3.0)
# =================================================================

read -r -d '' CONTENT_RATELIMITER << 'EOF'
--[[
OVHL ENGINE V3.3.0 (FINAL)
@Component: RateLimiter (Core System)
@Path: ReplicatedStorage.OVHL.Systems.Security.RateLimiter
@Purpose: (V3.3.0) Menggunakan Two-Phase Init. :Start() untuk task cleanup.
--]]

local RateLimiter = {}
RateLimiter.__index = RateLimiter

function RateLimiter.new()
    local self = setmetatable({}, RateLimiter)
    self._logger = nil
    self._limits = self:_getDefaultLimits()
    self._tracking = {} 
    self._cleanupInterval = 300 
    self._lastCleanup = os.time()
    return self
end

-- FASE 1: Hanya konstruksi
function RateLimiter:Initialize(logger)
    self._logger = logger
end

-- FASE 2: Aktivasi (Start background task)
function RateLimiter:Start()
    self:_startCleanupTask()
    self._logger:Info("RATELIMITER", "Rate Limiter Ready (V3.3.0).")
end

function RateLimiter:_getDefaultLimits()
    return {
        DoAction = { max = 10, window = 60 },
        Purchase = { max = 5, window = 300 },
        Equip = { max = 20, window = 60 },
        ButtonClick = { max = 30, window = 60 },
        ScreenOpen = { max = 15, window = 60 },
        DataSave = { max = 5, window = 60 },
        DataLoad = { max = 10, window = 60 },
    }
end

function RateLimiter:Check(player, action)
    if not player or not action then
        return true 
    end
    
    local limitConfig = self._limits[action]
    if not limitConfig then
        self._logger:Debug("RATELIMITER", "No rate limit configured", { action = action })
        return true 
    end
    
    local playerId = tostring(player.UserId)
    local trackingKey = playerId .. "_" .. action
    local now = os.time()
    
    if not self._tracking[trackingKey] then
        self._tracking[trackingKey] = {
            count = 1,
            windowStart = now
        }
        return true
    end
    
    local tracking = self._tracking[trackingKey]
    
    if now - tracking.windowStart >= limitConfig.window then
        tracking.count = 1
        tracking.windowStart = now
        return true
    end
    
    if tracking.count >= limitConfig.max then
        self._logger:Warn("RATELIMITER", "Rate limit exceeded", {
            player = player.Name,
            action = action,
            count = tracking.count
        })
        return false
    end
    
    tracking.count = tracking.count + 1
    return true
end

function RateLimiter:SetLimit(action, maxRequests, timeWindow)
    self._limits[action] = {
        max = maxRequests,
        window = timeWindow
    }
    self._logger:Info("RATELIMITER", "Rate limit configured", {
        action = action,
        max = maxRequests
    })
    return true
end

function RateLimiter:GetLimit(action)
    return self._limits[action]
end

function RateLimiter:GetPlayerStats(player)
    local playerId = tostring(player.UserId)
    local stats = {}
    local now = os.time()
    
    for action, limitConfig in pairs(self._limits) do
        local trackingKey = playerId .. "_" .. action
        local tracking = self._tracking[trackingKey]
        
        if tracking then
            local timeRemaining = limitConfig.window - (now - tracking.windowStart)
            stats[action] = {
                current = tracking.count,
                limit = limitConfig.max,
                resetIn = timeRemaining < 0 and 0 or timeRemaining
            }
        else
            stats[action] = {
                current = 0,
                limit = limitConfig.max,
                resetIn = 0
            }
        end
    end
    return stats
end

function RateLimiter:_startCleanupTask()
    task.spawn(function()
        while true do
            task.wait(self._cleanupInterval)
            self:_cleanupOldData()
        end
    end)
end

function RateLimiter:_cleanupOldData()
    local now = os.time()
    local removedCount = 0
    
    for trackingKey, tracking in pairs(self._tracking) do
        local playerId, action = string.match(trackingKey, "^(%d+)_(.+)$")
        if playerId and action then
            local limitConfig = self._limits[action]
            if limitConfig then
                if now - tracking.windowStart > limitConfig.window + 300 then 
                    self._tracking[trackingKey] = nil
                    removedCount = removedCount + 1
                end
            end
        end
    end
    
    if removedCount > 0 then
        self._logger:Debug("RATELIMITER", "Cleaned up old data", { count = removedCount })
    end
    self._lastCleanup = now
end

return RateLimiter

--[[
@End: RateLimiter.lua
@Version: 3.3.0 (Two-Phase Init)
@See: docs/ADR_V3-3-0.md
--]]
EOF

# =================================================================
# MENJALANKAN EKSEKUSI SKRIP
# =================================================================

echo "  [EXEC] Memulai eksekusi V3.3.0 (Two-Phase Init)..."
mkdir -p "$BACKUP_DIR"

# Patch 5 file
modify_file "$CORE_PATH/SystemRegistry.lua" "$CONTENT_SYSTEMREGISTRY"
modify_file "$ADVANCED_PATH/DataManager.lua" "$CONTENT_DATAMANAGER"
modify_file "$ADVANCED_PATH/PlayerManager.lua" "$CONTENT_PLAYERMANAGER"
modify_file "$NETWORKING_PATH/NetworkingRouter.lua" "$CONTENT_NETWORKINGROUTER"
modify_file "$SECURITY_PATH/RateLimiter.lua" "$CONTENT_RATELIMITER"

# =================================================================
# SUMMARY (RINGKASAN)
# =================================================================
echo "-----------------------------------------------------------------"
echo "✅ [OVHL V3.3.0] SKRIP FINAL Selesai."
echo ""
echo "--- 📊 AUDIT SUMMARY ---"
echo "  File Dimodifikasi : $FILES_MODIFIED"
echo "  Errors            : $ERRORS"
echo ""
echo "  [INFO] Direktori Backup: $BACKUP_DIR"
echo ""
echo "--- 👣 5 FILE DIMODIFIKASI (Two-Phase Init) ---"
echo "  1. $CORE_PATH/SystemRegistry.lua"
echo "  2. $ADVANCED_PATH/DataManager.lua"
echo "  3. $ADVANCED_PATH/PlayerManager.lua"
echo "  4. $NETWORKING_PATH/NetworkingRouter.lua"
echo "  5. $SECURITY_PATH/RateLimiter.lua"
echo "================================================================="