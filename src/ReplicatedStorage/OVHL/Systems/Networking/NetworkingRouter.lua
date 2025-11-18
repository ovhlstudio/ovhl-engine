--[[
OVHL ENGINE V1.0.0
@Component: NetworkingRouter (Networking)
@Path: ReplicatedStorage.OVHL.Systems.Networking.NetworkingRouter
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.3.0 (FINAL)
@Component: NetworkingRouter (Core System)
@Path: ReplicatedStorage.OVHL.Systems.Networking.NetworkingRouter
@Purpose: (V3.3.0) Menggunakan Two-Phase Init. :Start() untuk koneksi Remotes.
--]]

local NetworkingRouter = {}
NetworkingRouter.__index = NetworkingRouter

function NetworkingRouter.new()
    local self = setmetatable({}, NetworkingRouter)
    self._logger = nil
    self._remotes = {}
    self._handlers = {}
    self._middlewares = {}
    self._connectionStats = {}
    return self
end

-- FASE 1: Hanya konstruksi
function NetworkingRouter:Initialize(logger)
    self._logger = logger
end

-- FASE 2: Aktivasi (Setup Remotes & Connect)
function NetworkingRouter:Start()
    self:_setupRemotes()
    self:_startMonitoring()
    self._logger:Info("NETWORKING", "Networking Router Ready (V3.3.0).")
end

function NetworkingRouter:_setupRemotes()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local isServer = RunService:IsServer()
    
    local remotesFolder = ReplicatedStorage:FindFirstChild("OVHL_Remotes")
    if not remotesFolder and isServer then
        remotesFolder = Instance.new("Folder")
        remotesFolder.Name = "OVHL_Remotes"
        remotesFolder.Parent = ReplicatedStorage
    elseif not remotesFolder then
        remotesFolder = ReplicatedStorage:WaitForChild("OVHL_Remotes", 10)
    end
    
    if not remotesFolder then 
        self._logger:Error("NETWORKING", "Gagal menemukan folder OVHL_Remotes!")
        return 
    end

    if isServer then
        self._remotes = {
            ClientToServer = self:_getOrCreateRemote(remotesFolder, "RemoteEvent", "OVHL_ClientToServer"),
            ServerToClient = self:_getOrCreateRemote(remotesFolder, "RemoteEvent", "OVHL_ServerToClient"),
            RequestResponse = self:_getOrCreateRemote(remotesFolder, "RemoteFunction", "OVHL_RequestResponse")
        }
        
        self._remotes.ClientToServer.OnServerEvent:Connect(function(player, route, data)
            self:_handleClientToServer(player, route, data)
        end)
        
        self._remotes.RequestResponse.OnServerInvoke = function(player, route, data)
            return self:_handleRequestResponse(player, route, data)
        end
    else
        -- Client Side
        self._remotes = {
            ClientToServer = remotesFolder:WaitForChild("OVHL_ClientToServer"),
            ServerToClient = remotesFolder:WaitForChild("OVHL_ServerToClient"),
            RequestResponse = remotesFolder:WaitForChild("OVHL_RequestResponse")
        }
        
        self._remotes.ServerToClient.OnClientEvent:Connect(function(route, data)
            self:_handleServerToClient(route, data)
        end)
    end
end

function NetworkingRouter:_getOrCreateRemote(folder, className, name)
    local remote = folder:FindFirstChild(name)
    if not remote then
        remote = Instance.new(className)
        remote.Name = name
        remote.Parent = folder
    end
    return remote
end

function NetworkingRouter:_handleClientToServer(player, route, data)
    local handler = self._handlers[route]
    if handler then pcall(handler, player, data) end
end

function NetworkingRouter:_handleServerToClient(route, data)
    local handler = self._handlers[route]
    if handler then pcall(handler, data) end
end

function NetworkingRouter:_handleRequestResponse(player, route, data)
    local handler = self._handlers[route]
    if handler then 
        local success, res = pcall(handler, player, data)
        return success and {success=true, data=res} or {success=false, error=res}
    end
    return {success=false, error="No handler"}
end

function NetworkingRouter:RegisterHandler(route, handler)
    self._handlers[route] = handler
end

function NetworkingRouter:SendToServer(route, data)
    if not self._remotes.ClientToServer then return end
    self._remotes.ClientToServer:FireServer(route, data)
end

function NetworkingRouter:SendToClient(player, route, data)
    if not self._remotes.ServerToClient then return end
    self._remotes.ServerToClient:FireClient(player, route, data)
end

function NetworkingRouter:_startMonitoring() end -- Stubbed

return NetworkingRouter

--[[
@End: NetworkingRouter.lua
@Version: 3.3.0 (Two-Phase Init)
@See: docs/ADR_V3-3-0.md
--]]

--[[
@End: NetworkingRouter.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

