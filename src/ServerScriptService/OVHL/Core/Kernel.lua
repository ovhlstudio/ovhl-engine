--[[ @Component: Kernel (Server - LogFix) ]]
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerScriptService")

local Logger = require(RS.OVHL.Core.SmartLogger)
local Config = require(RS.OVHL.Core.SharedConfigLoader)
local Bridge = require(SS.OVHL.Core.NetworkBridge)
local RateLimiter = require(SS.OVHL.Core.RateLimiter)
local HDAdmin = require(SS.OVHL.Services.HDAdminAdapter)
local DataMgr = require(SS.OVHL.Services.DataManager)
local NotifSrv = require(SS.OVHL.Services.NotificationService)

local Kernel = {}

function Kernel.Boot()
    -- Logger Init tanpa argumen domain (default) atau fixed
    local log = Logger.New("KERNEL", {LogLevel="DEBUG"})
    log:Info("🚀 SERVER STARTUP (Phase 15 Strict)")
    
    local systems = {
        Logger = log,
        ConfigLoader = Config,
        RateLimiter = RateLimiter.New(),
        Network = nil,
        Permissions = HDAdmin.New(),
        DataManager = DataMgr.New(),
        Notification = NotifSrv
    }
    systems.Network = Bridge.New(systems)
    
    -- MODULE SCANNING
    local services = {}
    local modFolder = SS.OVHL.Modules
    
    for _, f in ipairs(modFolder:GetChildren()) do
        local script = f:FindFirstChild("Service")
        if script then
            local srv = require(script)
            local cfg = Config.Load(f.Name)
            
            -- Inject Dedicated Logger
            srv.Logger = Logger.New(string.upper(f.Name), cfg.Logging)
            srv._config = cfg
            services[f.Name] = srv
            
            if cfg.Network then
                systems.Network:Register(f.Name, cfg.Network)
                systems.Network:Bind(f.Name, srv)
            end
        end
    end
    
    log:Info("Phase 1: Core Init")
    if systems.Permissions.Init then systems.Permissions:Init(systems) end
    if systems.DataManager.Init then systems.DataManager:Init(systems) end
    if systems.Notification.Init then systems.Notification:Init(systems) end
    
    log:Info("Phase 2: Service Init")
    for _, s in pairs(services) do
        if s.Init then s:Init(systems) end
    end
    
    log:Info("Phase 3: Async Start")
    for _, s in pairs(services) do
        if s.Start then task.spawn(function() s:Start() end) end
    end
    
    log:Info("✅ SERVER READY")
end
return Kernel
