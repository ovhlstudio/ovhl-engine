--[[ @Component: Kernel (Client - Complete Domain Mapping) ]]
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
    local log = Logger.New("SYSTEM")
    log:Info("🚀 CLIENT STARTUP (Complete Domain Mapping)")
    
    -- Enhanced Topbar dengan domain yang proper
    local topbarInstance = Topbar.New()
    
    -- CONTEXT INJECTION
    local ctx = {
        Logger = log,
        Network = Bridge.New(),
        Finder = FinderService,
        UI = UIService,
        Topbar = topbarInstance
    }
    
    topbarInstance:Init({ Logger = Logger.New("TOPBAR") })
    
    local modules = {}
    
    local function Scan(dir)
        if not dir then return end
        for _, f in ipairs(dir:GetChildren()) do
            if f:IsA("Folder") then
                local script = f:FindFirstChild("Controller")
                if script then
                    local mod = require(script)
                    mod.Name = f.Name
                    mod._config = Config.Load(f.Name)
                    
                    -- COMPLETE DOMAIN MAPPING
                    if f.Name == "Admin" then
                        mod.Logger = Logger.New("ADMIN")
                    elseif f.Name == "Inventory" then
                        mod.Logger = Logger.New("INVENTORY")
                    elseif f.Name == "PrototypeShop" then
                        mod.Logger = Logger.New("SHOP")
                    else
                        mod.Logger = Logger.New("SYSTEM")
                    end
                    
                    modules[f.Name] = mod
                    mod.Logger:Debug("Controller initialized", {Name = f.Name})
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
                local t_cfg = m._config.Topbar
                ctx.Topbar:Add(name, t_cfg, function(state) 
                    if m.Toggle then m:Toggle(state) end 
                end)
            end
            if m.Start then m:Start() end
        end)
    end
    
    log:Info("✅ CLIENT READY (Services Active)")
end

return Kernel
