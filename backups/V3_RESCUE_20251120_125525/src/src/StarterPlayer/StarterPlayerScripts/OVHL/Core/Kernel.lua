--[[ @Component: Kernel (Client - With Logger Injection) ]]
local RS = game:GetService("ReplicatedStorage")
local PS = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts")

local LoggerFactory = require(RS.OVHL.Core.LoggerFactory)
local Config = require(RS.OVHL.Core.SharedConfigLoader)
local Bridge = require(PS.OVHL.Core.NetworkBridge)

-- V2 SERVICES
local FinderService = require(PS.OVHL.Core.FinderService)
local UIService     = require(PS.OVHL.Core.UIService)
local Topbar        = require(PS.OVHL.Controllers.TopbarPlusAdapter)

local Kernel = {}

function Kernel.Boot()
    local log = LoggerFactory.System()
    log:Info("🚀 CLIENT STARTUP (Enterprise Logger)")
    
    -- CONTEXT INJECTION WITH LOGGER FACTORY
    local ctx = {
        LoggerFactory = LoggerFactory, -- INJECT FACTORY
        Network = Bridge.New(),
        Finder = FinderService,
        UI = UIService,
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
                    mod._config = Config.Load(f.Name)
                    
                    -- ENTERPRISE LOGGER INJECTION
                    if f.Name == "Admin" then
                        mod.Logger = LoggerFactory.Admin()
                    elseif f.Name == "Inventory" then
                        mod.Logger = LoggerFactory.Inventory()
                    elseif f.Name == "PrototypeShop" then
                        mod.Logger = LoggerFactory.Shop()
                    else
                        mod.Logger = LoggerFactory.System()
                    end
                    
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
