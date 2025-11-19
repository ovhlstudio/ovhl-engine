--[[
	OVHL FRAMEWORK V.1.1.1 - NETWORKING ROUTER
	@Component: NetworkingRouter (Core System)
	@Path: ReplicatedStorage.OVHL.Systems.Networking.NetworkingRouter
	@Purpose: Networking with Middleware Support & Broadcast Capability
	@Fixes: Implemented SendToAllClients properly.
--]]

local Players = game:GetService("Players")
local NetworkingRouter = {}
NetworkingRouter.__index = NetworkingRouter

function NetworkingRouter.new()
	local self = setmetatable({}, NetworkingRouter)
	self._logger = nil
	self._remotes = {}
	self._handlers = {}
	self._middlewares = {} 
	return self
end

function NetworkingRouter:Initialize(logger)
	self._logger = logger
end

function NetworkingRouter:Start()
	self:_setupRemotes()
	self._logger:Info("NETWORKING", "Networking Router Ready (Broadcast Enabled).")
end

function NetworkingRouter:AddMiddleware(middleware)
	table.insert(self._middlewares, middleware)
	self._logger:Debug("NETWORKING", "Middleware registered", {name = middleware.name})
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

function NetworkingRouter:_runMiddlewares(type, player, route, data)
	for _, mw in ipairs(self._middlewares) do
		if type == "Receive" and mw.onReceive then
			if not mw.onReceive(player, route, data) then return false end
		elseif type == "Request" and mw.onRequest then
			if not mw.onRequest(player, route, data) then return false end
		end
	end
	return true
end

function NetworkingRouter:_handleClientToServer(player, route, data)
	if not self:_runMiddlewares("Receive", player, route, data) then
		self._logger:Warn("NETWORKING", "Request blocked by middleware", {player=player.Name, route=route})
		return
	end
	local handler = self._handlers[route]
	if handler then 
		local success, err = pcall(handler, player, data) 
		if not success then self._logger:Error("NETWORKING", "Handler Error", {route=route, error=err}) end
	else
		self._logger:Debug("NETWORKING", "No handler found", {route=route})
	end
end

function NetworkingRouter:_handleRequestResponse(player, route, data)
	if not self:_runMiddlewares("Request", player, route, data) then
		return {success=false, error="Blocked by middleware"}
	end
	local handler = self._handlers[route]
	if handler then 
		local success, res = pcall(handler, player, data)
		return success and {success=true, data=res} or {success=false, error=res}
	end
	return {success=false, error="No handler"}
end

function NetworkingRouter:_handleServerToClient(route, data)
	local handler = self._handlers[route]
	if handler then pcall(handler, data) end
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

function NetworkingRouter:SendToAllClients(route, data)
	if not self._remotes.ServerToClient then return end
	
	-- [FIX PRIORITY 3] IMPLEMENTASI BROADCAST
	-- Roblox tidak punya FireAllClients bawaan untuk RemoteEvent di beberapa konteks,
	-- tapi biasanya ada. Untuk aman, kita pakai FireAllClients.
	-- Jika error, fallback ke looping.
	
	local success = pcall(function()
		self._remotes.ServerToClient:FireAllClients(route, data)
	end)
	
	if not success then
		-- Fallback manual loop
		for _, player in ipairs(Players:GetPlayers()) do
			self._remotes.ServerToClient:FireClient(player, route, data)
		end
	end
end

function NetworkingRouter:RequestServer(route, data)
    if not self._remotes.RequestResponse then return {success=false} end
    return self._remotes.RequestResponse:InvokeServer(route, data)
end

return NetworkingRouter
