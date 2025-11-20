--[[ @Component: Kernel (Server - With Logger Injection) ]]
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerScriptService")

local LoggerFactory = require(RS.OVHL.Core.LoggerFactory)
local Config = require(RS.OVHL.Core.SharedConfigLoader)
local Bridge = require(SS.OVHL.Core.NetworkBridge)
local RateLimiter = require(SS.OVHL.Core.RateLimiter)

-- Core Services
local PermSrv = require(SS.OVHL.Services.PermissionService)
local DataMgr = require(SS.OVHL.Services.DataManager)
local NotifSrv = require(SS.OVHL.Services.NotificationService)

local Kernel = {}

function Kernel.Boot()
    local log = LoggerFactory.System()
    log:Info("🚀 SERVER STARTUP (Enterprise Logger)")
    
    local systems = {
        LoggerFactory = LoggerFactory, -- INJECT FACTORY
        ConfigLoader = Config,
        RateLimiter = RateLimiter.New(),
        Network = nil,
        Permissions = PermSrv, 
        DataManager = DataMgr.New(),
        Notification = NotifSrv
    }
    systems.Network = Bridge.New(systems)
    
    -- MODULE SCANNING WITH PROPER LOGGER INJECTION
    local services = {}
    local modFolder = SS.OVHL.Modules
    
    for _, f in ipairs(modFolder:GetChildren()) do
        local script = f:FindFirstChild("Service")
        if script then
            local srv = require(script)
            local cfg = Config.Load(f.Name)
            
            -- ENTERPRISE LOGGER INJECTION
            if f.Name == "Admin" then
                srv.Logger = LoggerFactory.Admin()
            elseif f.Name == "Inventory" then
                srv.Logger = LoggerFactory.Inventory()  
            elseif f.Name == "PrototypeShop" then
                srv.Logger = LoggerFactory.Shop()
            else
                srv.Logger = LoggerFactory.System()
            end
            
            srv._config = cfg
            services[f.Name] = srv
            
            if cfg.Network then
                systems.Network:Register(f.Name, cfg.Network)
                systems.Network:Bind(f.Name, srv)
            end
        end
    end
    
    -- [PHASE 1] CORE INIT
    log:Info("Phase 1: Core Init")
    if systems.Permissions.Init then systems.Permissions:Init(systems) end
    if systems.DataManager.Init then systems.DataManager:Init(systems) end
    if systems.Notification.Init then systems.Notification:Init(systems) end
    
    -- [PHASE 2] MODULE INIT
    log:Info("Phase 2: Module Init")
    for _, s in pairs(services) do
        if s.Init then s:Init(systems) end
    end
    
    -- [PHASE 3] STARTUP SEQUENCE
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
