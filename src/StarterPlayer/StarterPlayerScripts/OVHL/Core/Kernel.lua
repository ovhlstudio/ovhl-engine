--[[ @Component: Kernel (Client - AAA Automation) [PATCHED 3.1] ]]
local RS = game:GetService('ReplicatedStorage')
local PS = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts")

local LoggerFactory = require(RS.OVHL.Core.LoggerFactory)
local Config = require(RS.OVHL.Core.SharedConfigLoader)
local Bridge = require(PS.OVHL.Core.NetworkBridge)
local DomainResolver = require(RS.OVHL.Core.Logging.DomainResolver)
local Context = require(RS.OVHL.Core.Context)

-- Client Services
local FinderService = require(PS.OVHL.Core.FinderService)
local UIService     = require(PS.OVHL.Core.UIService)
local Topbar        = require(PS.OVHL.Controllers.TopbarPlusAdapter)

local Kernel = {}

function Kernel.Boot()
    local log = LoggerFactory.System()
    log:Info("🚀 CLIENT STARTUP (AAA v3.1 Patched)")
    
    local topbarInstance = Topbar.New()
    
    -- [FIX] Added ConfigLoader to systems table
    local systems = {
        LoggerFactory = LoggerFactory,
        ConfigLoader = Config, -- WAS MISSING
        Network = Bridge.New(),
        Finder = FinderService,
        UI = UIService,
        Topbar = topbarInstance
    }
    
    local ctx = Context.New(systems)
    
    topbarInstance:Init(ctx)
    
    local modules = {}
    
    -- Scanner
    local function Scan(dir)
        if not dir then return end
        for _, f in ipairs(dir:GetChildren()) do
            if f:IsA("Folder") then
                local script = f:FindFirstChild("Controller")
                if script then
                    local mod = require(script)
                    mod.Name = f.Name
                    mod._config = Config.Load(f.Name)
                    
                    local domain = DomainResolver.Resolve(f.Name)
                    mod.Logger = LoggerFactory.Create(domain)
                    
                    modules[f.Name] = mod
                    log:Debug("Indexed", {Name=f.Name})
                end
            end
        end
    end
    
    Scan(PS.OVHL.Modules)
    Scan(PS.OVHL.Controllers)

    log:Info("Phase 1: Init Modules")
    for _, m in pairs(modules) do
        if m.Init then pcall(function() m:Init(ctx) end) end
    end
    
    log:Info("Phase 2: Start Modules")
    for name, m in pairs(modules) do
        task.spawn(function()
            if m._config and m._config.Topbar and m._config.Topbar.Enabled then
                ctx.Topbar:Add(name, m._config.Topbar, function(state) 
                    if m.Toggle then m:Toggle(state) end 
                end)
            end
            if m.Start then m:Start() end
        end)
    end
    
    log:Info("✅ CLIENT READY")
end

return Kernel
