--[[ @Component: Kernel (Server - Guaranteed Logger Injection) ]]
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerScriptService")

local Logger = require(RS.OVHL.Core.SmartLogger)
local Config = require(RS.OVHL.Core.SharedConfigLoader)
local Bridge = require(SS.OVHL.Core.NetworkBridge)
local RateLimiter = require(SS.OVHL.Core.RateLimiter)

-- Core Services
local PermSrv = require(SS.OVHL.Services.PermissionService)
local DataMgr = require(SS.OVHL.Services.DataManager)
local NotifSrv = require(SS.OVHL.Services.NotificationService)

local Kernel = {}

function Kernel.Boot()
    local log = Logger.New("SYSTEM")
    log:Info("🚀 SERVER STARTUP (Guaranteed Logger Injection)")
    
    local systems = {
        Logger = log,
        ConfigLoader = Config,
        RateLimiter = RateLimiter.New(),
        Network = nil,
        Permissions = PermSrv, 
        DataManager = DataMgr.New(),
        Notification = NotifSrv
    }
    systems.Network = Bridge.New(systems)
    
    -- GUARANTEED LOGGER INJECTION - SIMPLE & RELIABLE
    local services = {}
    local modFolder = SS.OVHL.Modules
    
    for _, f in ipairs(modFolder:GetChildren()) do
        local script = f:FindFirstChild("Service")
        if script then
            local srv = require(script)
            local cfg = Config.Load(f.Name)
            
            -- GUARANTEE: Setiap service dapat logger
            if f.Name == "Admin" then
                srv.Logger = Logger.New("ADMIN")
            elseif f.Name == "Inventory" then
                srv.Logger = Logger.New("INVENTORY")  
            elseif f.Name == "PrototypeShop" then
                srv.Logger = Logger.New("SHOP")
            else
                srv.Logger = Logger.New("SYSTEM")
            end
            
            srv._config = cfg
            services[f.Name] = srv
            
            if cfg.Network then
                systems.Network:Register(f.Name, cfg.Network)
                systems.Network:Bind(f.Name, srv)
            end
        end
    end
    
    -- GUARANTEE: Core services dapat logger
    systems.Permissions.Logger = Logger.New("PERMISSION")
    systems.DataManager.Logger = Logger.New("DATA")
    systems.Notification.Logger = Logger.New("NOTIFICATION")
    
    -- INIT PHASES
    log:Info("Phase 1: Core Init")
    if systems.Permissions.Init then systems.Permissions:Init(systems) end
    if systems.DataManager.Init then systems.DataManager:Init(systems) end
    if systems.Notification.Init then systems.Notification:Init(systems) end
    
    log:Info("Phase 2: Module Init")
    for _, s in pairs(services) do
        if s.Init then s:Init(systems) end
    end
    
    log:Info("Phase 3: Async Start")
    if systems.Permissions.Start then task.spawn(function() systems.Permissions:Start() end) end
    if systems.DataManager.Start then task.spawn(function() systems.DataManager:Start() end) end
    if systems.Notification.Start then task.spawn(function() systems.Notification:Start() end) end
    
    for _, s in pairs(services) do
        if s.Start then task.spawn(function() s:Start() end) end
    end
    
    log:Info("✅ SERVER READY")
end

return Kernel
