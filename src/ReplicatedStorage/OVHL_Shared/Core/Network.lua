-- [[ NETWORK (ABSOLUTE STANDARD) ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- ABSOLUTE PATHS
local Shared = ReplicatedStorage:WaitForChild("OVHL_Shared")
local NetworkGuard = require(Shared.Library.Security.NetworkGuard)
local Logger = require(Shared.Core.Logger)

local Network = {}
local REMOTES_FOLDER_NAME = "OVHL_Remotes"

function Network.CreateEvent() return { _type = "RemoteEvent" } end
function Network.CreateFunction() return { _type = "RemoteFunction" } end

local function GetRemoteFolder()
    local folder = ReplicatedStorage:FindFirstChild(REMOTES_FOLDER_NAME)
    if not folder and RunService:IsServer() then
        folder = Instance.new("Folder")
        folder.Name = REMOTES_FOLDER_NAME
        folder.Parent = ReplicatedStorage
    elseif not folder then
        folder = ReplicatedStorage:WaitForChild(REMOTES_FOLDER_NAME)
    end
    return folder
end

function Network:InitServiceRemotes(serviceName, clientDef)
    if not RunService:IsServer() then return end
    local folder = GetRemoteFolder()
    
    for key, marker in pairs(clientDef) do
        if type(marker) == "table" and marker._type then
            local remoteName = serviceName .. "/" .. key
            local remote = Instance.new(marker._type)
            remote.Name = remoteName
            remote.Parent = folder
            
            -- AUTO-HOOK SECURITY
            if marker._type == "RemoteFunction" then
                remote.OnServerInvoke = function(player, ...)
                    local args = {...}
                    local cleanArgs = {}
                    for i, v in ipairs(args) do cleanArgs[i] = NetworkGuard.SanitizeInbound(v) end
                    return nil 
                end
            end
            Logger:Debug("NET", "Route Registered: " .. remoteName)
        end
    end
end

function Network:GetRemote(serviceName, key)
    local folder = GetRemoteFolder()
    local remoteName = serviceName .. "/" .. key
    local remote
    if RunService:IsServer() then remote = folder:FindFirstChild(remoteName)
    else remote = folder:WaitForChild(remoteName, 10) end
    
    if not remote then error("Remote Missing: " .. remoteName) end
    return remote
end

return Network
