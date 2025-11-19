--[[
	OVHL FRAMEWORK V.1.1.2 - HD ADMIN ADAPTER (EVENT LISTENER APPROACH)
	@Component: HDAdminAdapter (Permission)
	@Purpose: Listen to HD Admin events instead of polling GetRank()
	@Strategy:
		1. Hook into HD Admin's internal rank change events
		2. Listen to RemoteEvent signals
		3. Parse player rank from event data
		4. Cache and replicate to client
    @Credit: Solution provided by Claude AI
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local HDAdminAdapter = {}
HDAdminAdapter.__index = HDAdminAdapter

local CONFIG = {
	WAIT_FOR_API = 10,
	EVENT_LISTEN_TIMEOUT = 15,
	FALLBACK_CHECK_INTERVAL = 5,
}

function HDAdminAdapter.new()
	local self = setmetatable({}, HDAdminAdapter)
	self._logger = nil
	self._isServer = RunService:IsServer()
	self._api = nil
	self._folderDetected = false
	self._playerCache = {}
	self._eventConnections = {}
	self._rankEventHooked = false
	return self
end

function HDAdminAdapter:Initialize(logger)
	self._logger = logger

	-- [CLIENT]
	if not self._isServer then
		self._folderDetected = true
		self._logger:Info("PERMISSION", "HDAdminAdapter (Client) Listening...")
		local p = Players.LocalPlayer
		if p then
			p:GetAttributeChangedSignal("OVHL_Rank"):Connect(function()
				logger:Info("PERMISSION", "[CLIENT] Rank Update Received", {rank = p:GetAttribute("OVHL_Rank")})
			end)
		end
		return
	end

	-- [SERVER]
	local hdFolder = ServerScriptService:FindFirstChild("HD Admin")
	if hdFolder then
		self._folderDetected = true
		self._logger:Info("PERMISSION", "HDAdminAdapter: Folder Detected. Initializing Event Listeners...")
		task.spawn(function() self:_connectAPI() end)
		task.spawn(function() self:_setupEventListeners() end)
	else
		self._folderDetected = false
		self._logger:Warn("PERMISSION", "HDAdminAdapter: Folder NOT FOUND. Using Internal fallback.")
	end
end

function HDAdminAdapter:IsAvailable() 
	return self._folderDetected 
end

function HDAdminAdapter:_connectAPI()
	if self._api then return self._api end

	local setup = ReplicatedStorage:WaitForChild("HDAdminSetup", 3)
	if setup then 
		pcall(function() require(setup):GetMain() end) 
	end

	local startTime = os.clock()
	local maxWait = CONFIG.WAIT_FOR_API
	
	while (os.clock() - startTime) < maxWait do
		if _G.HDAdminMain then
			self._api = _G.HDAdminMain
			self._logger:Info("PERMISSION", "[OK] HDAdminAdapter: API Connected.")
			self:_refreshAllRanks()
			return self._api
		end
		task.wait(0.5)
	end

	self._logger:Warn("PERMISSION", "[TIMEOUT] HD Admin API not ready after " .. maxWait .. "s")
	return nil
end

-- [NEW] Setup event listeners on HD Admin internals
function HDAdminAdapter:_setupEventListeners()
	-- Wait for API to actually connect (not just exist)
	local waitStart = os.clock()
	while not self._api and (os.clock() - waitStart) < CONFIG.WAIT_FOR_API do
		task.wait(0.5)
		self:_connectAPI()
	end
	
	if not self._api then 
		self._logger:Warn("PERMISSION", "[SETUP] API still not ready, will retry on first GetRank call")
		return 
	end

	self._logger:Info("PERMISSION", "[SETUP] Scanning for HD Admin RemoteEvents...")

	-- Strategy 1: Hook rank change events via RemoteEvent
	self:_hookRemoteEvents()
	
	-- Strategy 2: Listen to player-added in HD Admin
	self:_hookPlayerEvents()
	
	self._logger:Info("PERMISSION", "[SETUP] Event listeners registered")
end

-- Listen to RemoteEvents in HD Admin folder
function HDAdminAdapter:_hookRemoteEvents()
	local hdFolder = ServerScriptService:FindFirstChild("HD Admin")
	if not hdFolder then return end

	-- Scan for RemoteEvents that might fire on rank changes
	local function scanForRemotes(folder, depth)
		if depth > 5 then return end
		
		for _, item in ipairs(folder:GetDescendants()) do
			if item:IsA("RemoteEvent") then
				-- Common HD Admin event names
				if string.match(item.Name, "[Rr]ank") or 
				   string.match(item.Name, "[Pp]erm") or
				   string.match(item.Name, "[Aa]dmin") then
					
					self._logger:Debug("PERMISSION", "[HOOK] Found RemoteEvent: " .. item.Name)
					
					-- Hook OnServerEvent to listen for rank data
					local conn = item.OnServerEvent:Connect(function(player, ...)
						self:_onRemoteEventFired(player, item.Name, ...)
					end)
					
					table.insert(self._eventConnections, conn)
				end
			end
		end
	end
	
	pcall(function() scanForRemotes(hdFolder, 0) end)
end

-- Listen when players join for HD Admin to assign them ranks
function HDAdminAdapter:_hookPlayerEvents()
	local conn = Players.PlayerAdded:Connect(function(player)
		-- Wait for HD Admin to process this player
		task.spawn(function()
			task.wait(2)  -- Give HD Admin time to load player data
			
			-- Try to grab rank now
			local rank = self:GetRank(player)
			if rank > 0 then
				self._logger:Info("PERMISSION", "[HOOK] Player rank captured on join", {
					player = player.Name,
					rank = rank
				})
			end
		end)
	end)
	
	table.insert(self._eventConnections, conn)
end

-- Handle RemoteEvent fires - extract rank data if present
function HDAdminAdapter:_onRemoteEventFired(player, eventName, ...)
	local args = {...}
	
	-- Try to find rank data in arguments
	for i, arg in ipairs(args) do
		if type(arg) == "number" and arg >= 0 and arg <= 255 then
			-- Likely a rank number
			self._logger:Debug("PERMISSION", "[EVENT] Rank signal detected", {
				player = player.Name,
				event = eventName,
				rank = arg
			})
			
			self._playerCache[player.UserId] = { rank = arg, time = os.time() }
			player:SetAttribute("OVHL_Rank", arg)
			return
		end
	end
end

function HDAdminAdapter:_refreshAllRanks()
	if not self._isServer then return end
	for _, p in ipairs(Players:GetPlayers()) do
		task.spawn(function()
			local rank = self:GetRank(p)
			p:SetAttribute("OVHL_Rank", rank)
		end)
	end
end

-- [HYBRID] Try GetRank, but with smarter fallback
function HDAdminAdapter:GetRank(player)
	if not self._isServer then 
		return player:GetAttribute("OVHL_Rank") or 0 
	end

	-- Check local cache first
	local cacheKey = player.UserId
	if self._playerCache[cacheKey] and (os.time() - self._playerCache[cacheKey].time) < 60 then
		return self._playerCache[cacheKey].rank
	end

	local api = self:_connectAPI()
	if not api then 
		return self:_getOwnerFallback(player)
	end

	local finalRank = 0

	-- [ATTEMPT 1] Try cf:GetRank directly
	local success, result = pcall(function()
		if api.GetModule then
			local cf = api:GetModule("cf")
			if cf and cf.GetRank then
				local r = cf:GetRank(player)
				if type(r) == "number" and r > 0 then return r end
				if type(r) == "table" and r.Id and r.Id > 0 then return r.Id end
			end
		end
		return 0
	end)

	if success and type(result) == "number" and result > 0 then
		finalRank = result
		self._logger:Info("PERMISSION", "[OK] Rank from cf:GetRank", {
			player = player.Name,
			rank = finalRank
		})
	end

	-- [ATTEMPT 2] Try legacy API
	if finalRank == 0 then
		success, result = pcall(function()
			if api.GetPlayerRank then 
				return api:GetPlayerRank(player) 
			elseif api.GetRank then 
				return api:GetRank(player) 
			end
			return 0
		end)
		
		if success and type(result) == "number" and result > 0 then
			finalRank = result
			self._logger:Info("PERMISSION", "[OK] Rank from legacy API", {
				player = player.Name,
				rank = finalRank
			})
		end
	end

	-- [ATTEMPT 3] Check if in cache from RemoteEvent listener
	if finalRank == 0 and self._playerCache[cacheKey] then
		finalRank = self._playerCache[cacheKey].rank
		self._logger:Info("PERMISSION", "[OK] Rank from event cache", {
			player = player.Name,
			rank = finalRank
		})
	end

	-- [LAST RESORT] Owner check only
	if finalRank == 0 then
		finalRank = self:_getOwnerFallback(player)
		if finalRank > 0 then
			self._logger:Warn("PERMISSION", "[FALLBACK] Using owner check", {
				player = player.Name
			})
		else
			self._logger:Debug("PERMISSION", "[NONE] No rank found - player is regular user", {
				player = player.Name
			})
		end
	end

	-- Cache result
	self._playerCache[cacheKey] = { rank = finalRank, time = os.time() }
	player:SetAttribute("OVHL_Rank", finalRank)

	return finalRank
end

function HDAdminAdapter:_getOwnerFallback(player)
	if game.CreatorType == Enum.CreatorType.User and player.UserId == game.CreatorId then
		return 5
	end
	
	if RunService:IsStudio() and player.UserId == game.CreatorId then
		return 5
	end
	
	return 0
end

function HDAdminAdapter:CheckPermission(player, permissionNode) 
	return true 
end

function HDAdminAdapter:SetRank(player, rank) 
	return false 
end

function HDAdminAdapter:Destroy()
	for _, conn in ipairs(self._eventConnections) do
		pcall(function() conn:Disconnect() end)
	end
	self._eventConnections = {}
	self._logger:Info("PERMISSION", "[OK] HDAdminAdapter destroyed")
end

return HDAdminAdapter
