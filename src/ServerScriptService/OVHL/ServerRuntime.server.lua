--[[
OVHL FRAMEWORK V.1.0.1
@Component: ServerRuntime.server (Entry Point)
@Path: ServerScriptService.OVHL.ServerRuntime.server
@Purpose: Server-side bootstrap entry point
@Version: 1.0.1
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Bootstrap = require(ReplicatedStorage.OVHL.Core.Bootstrap)

local OVHL = Bootstrap:Initialize()
local Logger = OVHL.GetSystem("SmartLogger")

-- [FIX VERSION]
Logger:Info("SERVER", "🚀 Starting OVHL Server Runtime V.1.0.1 (Standard)")

local Kernel = require(ReplicatedStorage.OVHL.Core.Kernel).new()
Kernel:Initialize(Logger)
local modulesFound = Kernel:ScanModules()

local SystemRegistry = OVHL.GetSystem("SystemRegistry")
if SystemRegistry then
    Logger:Info("SYSTEMREGISTRY", "SystemRegistry initialized (V.1.0.1)")
end

Knit.Start()
    :andThen(function()
        Logger:Info("SERVER", "Knit started")
        local registeredCount = Kernel:RegisterKnitServices(Knit)
        Kernel:RunVerification()

        local securitySystems = { "InputValidator", "RateLimiter", "PermissionCore", "SecurityHelper" }
        local securityReady = 0
        for _, name in ipairs(securitySystems) do
            if OVHL.GetSystem(name) then
                securityReady = securityReady + 1
            end
        end

        Logger:Info("SERVER", "🎉 OVHL Server Ready", {
            modules = modulesFound,
            kernel = registeredCount,
            security = securityReady .. "/" .. #securitySystems,
        })
    end)
    :catch(function(err)
        Logger:Critical("SERVER", "Runtime Failed", { error = tostring(err) })
    end)

game:BindToClose(function()
    if SystemRegistry then
        Logger:Critical("SERVER", "Game closing. Initiating OVHL Shutdown...")
        SystemRegistry:Shutdown()
    else
        Logger:Critical("SERVER", "Game closing. SystemRegistry not found!")
    end
    task.wait(1)
end)
