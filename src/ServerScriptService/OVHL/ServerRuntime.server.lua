--[[
    OVHL FRAMEWORK V.1.2.2
    @Component: ServerRuntime
    @Purpose: Bootstraps OVHL & Knit with FULL Security Middleware
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Bootstrap = require(ReplicatedStorage.OVHL.Core.Bootstrap)

local OVHL = Bootstrap:Initialize()
local Logger = OVHL.GetSystem("SmartLogger")
Logger:Info("SERVER", "🚀 Starting OVHL Server Runtime V1.2.2")

local Kernel = require(ReplicatedStorage.OVHL.Core.Kernel).new()
Kernel:Initialize(Logger)
Kernel:ScanModules()

-- Load Firewall
local NetworkGuard = require(ServerScriptService.OVHL.Systems.Security.NetworkGuard)

-- Start Knit with Full Protection
Knit.Start({
    Middleware = {
        -- [INBOUND] Sanitasi data kotor dari Client
        Inbound = { NetworkGuard.Inbound },
        
        -- [OUTBOUND] Sensor data rahasia Server
        Outbound = { NetworkGuard.Outbound } 
    }
}):andThen(function()
    Logger:Info("SERVER", "Knit Started. Firewall Active (In/Out).")
    Kernel:RegisterKnitServices(Knit)
end):catch(function(err)
    Logger:Critical("SERVER", "Fatal Boot Error", {error = tostring(err)})
end)
