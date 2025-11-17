--[[
OVHL ENGINE V3.0.0 - SERVER RUNTIME (PATCHED)
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Bootstrap = require(ReplicatedStorage.OVHL.Core.Bootstrap)

-- Helper for table size
local function count(t) local c=0 for _ in pairs(t) do c=c+1 end return c end

local OVHL = Bootstrap:Initialize()
local Logger = OVHL:GetSystem("SmartLogger")

Logger:Info("SERVER", "🚀 Starting OVHL Server Runtime V3.0.0")

local Kernel = require(ReplicatedStorage.OVHL.Core.Kernel).new()
Kernel:Initialize(Logger)
local modulesFound = Kernel:ScanModules()

local SystemRegistry = OVHL:GetSystem("SystemRegistry")
if SystemRegistry then
    Logger:Info("SYSTEMREGISTRY", "SystemRegistry initialized")
end

Knit.Start():andThen(function()
    Logger:Info("SERVER", "Knit started")
    local registeredCount = Kernel:RegisterKnitServices(Knit)
    Kernel:RunVerification()
    
    local securitySystems = {"InputValidator", "RateLimiter", "PermissionCore", "SecurityHelper"}
    local securityReady = 0
    for _, name in ipairs(securitySystems) do
        if OVHL:GetSystem(name) then securityReady = securityReady + 1 end
    end
    
    Logger:Info("SERVER", "🎉 OVHL Server Ready", {
        modules = modulesFound,
        kernel = registeredCount,
        security = securityReady .. "/" .. #securitySystems
    })
    
end):catch(function(err)
    Logger:Critical("SERVER", "Runtime Failed", {error = tostring(err)})
end)
