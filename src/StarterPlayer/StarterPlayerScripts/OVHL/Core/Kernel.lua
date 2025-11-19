--[[ @Component: Kernel (Client - Syntax Fixed) ]]
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
    log:Info("🚀 CLIENT STARTUP (Fixed)")
    
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
                    mod._config = Config.Load(f.Name)
                    mod.Logger = Logger.New(string.upper(f.Name), mod._config and mod._config.Logging)
                    modules[f.Name] = mod
                    log:Debug("Indexed", {Name = f.Name})
                end
            elseif f:IsA("ModuleScript") then
                -- Standalone controller
                local ctrl = require(f)
                ctrl.Logger = Logger.New(string.upper(f.Name))
                modules[f.Name] = ctrl
                log:Debug("Indexed", {Name = f.Name})
            end
        end
    end
    
    Scan(PS.OVHL.Modules)
    Scan(PS.OVHL.Controllers) -- Scan Controllers folder

    log:Info("Phase 1: Init")
    for _, m in pairs(modules) do
        if m.Init then pcall(function() m:Init(ctx) end) end
    end
    
    log:Info("Phase 2: Start")
    for _, m in pairs(modules) do
        task.spawn(function()
            if m._config and m._config.Topbar then
                ctx.Topbar:Add(m._config.Topbar, function(s) 
                    if m.Toggle then m:Toggle(s) end 
                end)
            end
            if m.Start then m:Start() end
        end)
    end
    
    -- SYNC WATCHER
    local p = Players.LocalPlayer
    p:GetAttributeChangedSignal("OVHL_Rank"):Connect(function()
        log:Info("Perm Update", {
            Rank = p:GetAttribute("OVHL_Rank"), 
            Src = p:GetAttribute("OVHL_Src")
        })
    end)

    -- INITIAL CHECK
    if p:GetAttribute("OVHL_Rank") then
        log:Info("Initial Perm", {
            Rank = p:GetAttribute("OVHL_Rank"), 
            Src = p:GetAttribute("OVHL_Src")
        })
    end
    
    log:Info("✅ CLIENT READY")
end
return Kernel
