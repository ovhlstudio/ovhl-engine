--[[ @Component: Kernel (Client - V2 Service Injection) ]]
local RS = game:GetService("ReplicatedStorage")
local PS = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts")

local Logger = require(RS.OVHL.Core.SmartLogger)
local Config = require(RS.OVHL.Core.SharedConfigLoader)
local Bridge = require(PS.OVHL.Core.NetworkBridge)

-- V2 SERVICES
local FinderService = require(PS.OVHL.Core.FinderService)
local UIService     = require(PS.OVHL.Core.UIService)
local Topbar        = require(PS.OVHL.Controllers.TopbarPlusAdapter)

local Kernel = {}

function Kernel.Boot()
    local log = Logger.New("KERNEL")
    log:Info("🚀 CLIENT STARTUP (Phase 2 Services Injected)")
    
    -- CONTEXT INJECTION
    local ctx = {
        Logger = log,
        Network = Bridge.New(),
        
        -- REPLACED "UI" (UIEngine) -> With 2 Explicit Services
        Finder = FinderService,
        UI = UIService,        -- Note: "ctx.UI" sekarang adalah Service Manager, bukan Engine Scan lagi.
        
        Topbar = Topbar.New()
    }
    
    ctx.Topbar:Init(ctx)
    
    local modules = {}
    
    local function Scan(dir)
        if not dir then return end
        for _, f in ipairs(dir:GetChildren()) do
            if f:IsA("Folder") then
                local script = f:FindFirstChild("Controller")
                if script then
                    local mod = require(script)
                    mod.Name = f.Name
                    
                    -- AUTO LOAD CONFIG STANDARD V2
                    mod._config = Config.Load(f.Name)
                    mod.Logger = Logger.New(string.upper(f.Name), mod._config.Meta and "INFO")
                    
                    modules[f.Name] = mod
                    log:Debug("Indexed Controller", {Name = f.Name})
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
                -- Topbar V2 Integration
                local t_cfg = m._config.Topbar
                ctx.Topbar:Add(name, t_cfg, function(state) 
                     -- Universal Toggle Handling
                    if m.Toggle then m:Toggle(state) end 
                end)
            end
            if m.Start then m:Start() end
        end)
    end
    
    log:Info("✅ CLIENT READY (Services Active)")
end
return Kernel
