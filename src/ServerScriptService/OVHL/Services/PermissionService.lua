--[[ @Component: PermissionService (Domain Restored + FailSafe) ]]
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local InternalCfg = require(SSS.OVHL.Config.PermissionConfig)
-- Kita butuh referensi class logger untuk create domain baru
local SmartLogger = require(RS.OVHL.Core.SmartLogger)

local Srv = {}

function Srv:Init(ctx)
	-- [FIX] CREATE SPECIFIC LOGGER DOMAIN
	self.Logger = SmartLogger.New("PERM")

	self._api = nil
	self._cache = {}
	self._queue = {}
	self._scanning = true
	self._startTick = tick()

	Players.PlayerAdded:Connect(function(p)
		self:HandleJoin(p)
	end)
	for _, p in ipairs(Players:GetPlayers()) do
		self:HandleJoin(p)
	end
end

function Srv:Start()
	-- HEARTBEAT FAIL-SAFE LOOP
	local CONNECTION
	local lastCheck = 0

	CONNECTION = RunService.Heartbeat:Connect(function(dt)
		if not self._scanning then
			CONNECTION:Disconnect()
			return
		end

		local now = tick()
		if now - lastCheck < 1 then
			return
		end -- Cek tiap 1 detik
		lastCheck = now

		-- LOG: Domain akan muncul sebagai [PERM]
		self.Logger:Info("Init", "Scanning for HD Admin... (" .. math.floor(now - self._startTick) .. "s)")

		-- 1. PROBE ATTEMPT
		local apiFound = nil

		-- Probe _G
		if _G.HDAdminMain then
			apiFound = _G.HDAdminMain
		end

		-- Probe ReplicatedStorage Module (Setup)
		if not apiFound then
			local m = RS:FindFirstChild("HDAdminSetup")
			if m then
				local s, lib = pcall(require, m)
				if s and lib and lib.GetMain then
					pcall(function()
						apiFound = lib:GetMain()
					end)
				end
			end
		end

		-- 2. SUCCESS
		if apiFound then
			self._api = apiFound
			self._scanning = false
			self.Logger:Info("Link", "🔗 CONNECTED to HD Admin API!")
			self:Flush()
			return
		end

		-- 3. TIMEOUT (8 DETIK)
		if (now - self._startTick) > 8 then
			self._scanning = false
			self.Logger:Warn("Timeout", "⏳ HD Admin not responding. Fallback to Internal.")
			self:Flush()
			CONNECTION:Disconnect()
		end
	end)
end

function Srv:HandleJoin(p)
	if self._scanning then
		-- Optional: Uncomment untuk debug tiap user masuk queue
		-- self.Logger:Debug("Queue", "Buffering player...", {User=p.Name})
		self._queue[p.UserId] = p
	else
		self:Resolve(p)
	end
end

function Srv:Flush()
	for uid, player in pairs(self._queue) do
		if player.Parent then
			self:Resolve(player)
		end
	end
	self._queue = {}
end

function Srv:Resolve(player)
	local result = { Rank = 0, Source = "ERR" }
	local useExternal = false

	-- LOGIC A: EXTERNAL
	if self._api then
		local s, cf = pcall(function()
			return self._api:GetModule("cf")
		end)
		if s and cf then
			local raw = cf:GetRankId(player)
			if type(raw) == "number" and raw > 0 then
				result.Rank = raw
				result.Source = "EXTERNAL_HD"
				useExternal = true
			elseif player.UserId == game.CreatorId then
				result.Rank = 1
				result.Source = "EXTERNAL_HD_FORCED"
				useExternal = true
			else
				result.Rank = 0
				result.Source = "EXTERNAL_HD_GUEST"
				useExternal = true
			end
		end
	end

	-- LOGIC B: INTERNAL (FALLBACK)
	if not useExternal then
		if InternalCfg.Users[player.UserId] then
			result.Rank = InternalCfg.Users[player.UserId]
			result.Source = "INTERNAL_USER"
		elseif InternalCfg.Settings.OwnerIsSuperAdmin and player.UserId == game.CreatorId then
			result.Rank = 5
			result.Source = "INTERNAL_OWNER"
		else
			result.Rank = 0
			result.Source = "INTERNAL_GUEST"
		end
	end

	self._cache[player.UserId] = result

	-- FINAL LOG WITH DOMAIN "PERM"
	if result.Rank > 0 or result.Source:match("EXTERNAL") or result.Source:match("INTERNAL") then
		local icn = result.Source:match("EXTERNAL") and "🌐" or "🏠"
		self.Logger:Info("Identity Scan", {
			User = player.Name,
			Id = player.UserId,
			Src = icn .. " " .. result.Source,
			Rank = result.Rank,
		})
	end
end

function Srv:Check(player, req)
	local data = self._cache[player.UserId]
	if not data then
		self:Resolve(player)
		data = self._cache[player.UserId]
	end
	if not data then
		return false
	end

	local t = 0
	if type(req) == "number" then
		t = req
	end
	if req == "Admin" then
		t = 3
	end
	if req == "Owner" then
		t = 5
	end
	return data.Rank >= t
end

return Srv
