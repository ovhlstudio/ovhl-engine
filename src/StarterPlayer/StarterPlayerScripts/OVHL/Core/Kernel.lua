--[[ @Component: Kernel (Client - Self Aware) ]]
local RS = game:GetService("ReplicatedStorage")
local PS = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts")
local Players = game:GetService("Players")

local Logger = require(RS.OVHL.Core.SmartLogger)
local Config = require(RS.OVHL.Core.SharedConfigLoader)
local Bridge = require(PS.OVHL.Core.NetworkBridge)
local UIEngine = require(PS.OVHL.Core.UIEngine)
local Topbar = require(PS.OVHL.Controllers.TopbarPlusAdapter)

local Kernel = {}

function Kernel.Boot()
    local log = Logger.New("KERNEL")
    log:Info("🚀 CLIENT STARTUP (Phase 37 Sync)")
    
    local ctx = {
        Logger = log,
        Network = Bridge.New(),
        UI = UIEngine,
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
                    -- [NEW] INJECT IDENTITY
                    mod.Name = f.Name
                    
                    mod._config = Config.Load(f.Name)
                    mod.Logger = Logger.New(string.upper(f.Name), mod._config and mod._config.Logging)
                    modules[f.Name] = mod
                    log:Debug("Indexed", {Name = f.Name})
                end
            end
        end
    end
    
    Scan(PS.OVHL.Modules)
    Scan(PS.OVHL.Controllers)

    log:Info("Phase 1: Init")
    for _, m in pairs(modules) do
        if m.Init then pcall(function() m:Init(ctx) end) end
    end
    
    log:Info("Phase 2: Start")
    for name, m in pairs(modules) do
        task.spawn(function()
            if m._config and m._config.Topbar then
                -- Adapter sekarang simpan referensi pakai 'name' ini
                ctx.Topbar:Add(name, m._config.Topbar, function(s) 
                    if m.Toggle then m:Toggle(s) end 
                end)
            end
            if m.Start then m:Start() end
        end)
    end
    
    log:Info("✅ CLIENT READY")
end
return Kernel
