-- [[ OVHL SHARED ENGINE V2 (GOLD MASTER) ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local OVHL = {}

-- Explicit Internal Loading
OVHL.Logger = require(script.Core.Logger)
OVHL.Network = require(script.Core.Network)
OVHL.Bootstrapper = require(script.Core.Bootstrapper)
OVHL.Permission = require(script.Core.Permission)

local _systems = {}

-- [[ API STANDARDS ]]
function OVHL.RegisterSystem(name, system)
    _systems[name] = system
    system.Name = name
    system._type = "System"
    -- Auto-Hook ke Bootstrapper untuk Lifecycle
    OVHL.Bootstrapper:Register(system)
end

function OVHL.GetSystem(name)
    return _systems[name]
end

function OVHL.CreateService(def)
    def._type = "Service"
    if def.Client then OVHL.Network:InitServiceRemotes(def.Name, def.Client) end
    OVHL.Bootstrapper:Register(def)
    return def
end

function OVHL.CreateController(def)
    def._type = "Controller"
    OVHL.Bootstrapper:Register(def)
    return def
end

function OVHL.GetService(name)
    if RunService:IsClient() then
        return setmetatable({}, {
            __index = function(_, key)
                return function(self, ...)
                    local remote = OVHL.Network:GetRemote(name, key)
                    if remote:IsA("RemoteEvent") then remote:FireServer(...) 
                    elseif remote:IsA("RemoteFunction") then return remote:InvokeServer(...) end
                end
            end
        })
    else
        return nil -- Server Side: Use DI or GetSystem for Systems
    end
end

function OVHL.GetController(name)
    return OVHL.Bootstrapper:GetModule(name)
end

function OVHL.Start()
    OVHL.Bootstrapper:Start()
end

return OVHL
