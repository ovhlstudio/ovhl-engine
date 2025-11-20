--[[ @Component: Kernel (Server - DI Container) ]]
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerScriptService")

local LoggerFactory = require(RS.OVHL.Core.LoggerFactory)
local Config = require(RS.OVHL.Core.SharedConfigLoader)
local Context = require(RS.OVHL.Core.Context)
local Bridge = require(SS.OVHL.Core.NetworkBridge)
local RateLimiter = require(SS.OVHL.Core.RateLimiter)
local DomainResolver = require(RS.OVHL.Core.Logging.DomainResolver)

-- Static Requires for Core Services
local Services = {
    Perms = require(SS.OVHL.Services.PermissionService),
    Data  = require(SS.OVHL.Services.DataManager),
    Notif = require(SS.OVHL.Services.NotificationService)
}
-- Adapters Loaded Here
local Adapters = {
    DB = require(SS.OVHL.Core.Permissions.Adapters.InternalDB),
    HD = require(SS.OVHL.Core.Permissions.Adapters.HDAdmin)
}

local Kernel = {}

function Kernel.Boot()
    local log = LoggerFactory.System()
    log:Info("🚀 SERVER STARTUP")

    local systems = {
        LoggerFactory = LoggerFactory, ConfigLoader = Config, RateLimiter = RateLimiter.New(),
        Permissions = Services.Perms, DataManager = Services.Data, Notification = Services.Notif,
        Adapters = Adapters
    }

    local ctx = Context.New(systems)
    ctx.Network = Bridge.New(ctx)
    systems.Network = ctx.Network

    -- Inject Loggers
    Services.Perms.Logger = LoggerFactory.Create("PERMISSION")
    Services.Data.Logger = LoggerFactory.Create("DATA")
    Services.Notif.Logger = LoggerFactory.Create("NOTIF")

    -- Load Feature Modules
    local modules = {}
    for _, f in ipairs(SS.OVHL.Modules:GetChildren()) do
        local script = f:FindFirstChild("Service")
        if script then
            local srv = require(script)
            local domain = DomainResolver.Resolve(f.Name)
            srv.Logger = LoggerFactory.Create(domain)
            srv._config = Config.Load(f.Name)
            modules[f.Name] = srv
            
            if srv._config.Network then
                systems.Network:Register(f.Name, srv._config.Network)
                systems.Network:Bind(f.Name, srv)
            end
        end
    end

    -- Lifecycle
    local function run(o, m) if o[m] then o[m](o, ctx) end end
    
    log:Info("Phase 1: Init")
    run(Services.Perms, "Init"); run(Services.Data, "Init"); run(Services.Notif, "Init")
    for _, m in pairs(modules) do run(m, "Init") end

    log:Info("Phase 2: Start")
    local function bg(o) if o.Start then task.spawn(function() o:Start() end) end end
    bg(Services.Perms); bg(Services.Data); bg(Services.Notif)
    for _, m in pairs(modules) do bg(m) end

    log:Info("✅ SERVER READY")
end
return Kernel
