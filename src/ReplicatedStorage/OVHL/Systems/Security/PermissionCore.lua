--[[
OVHL ENGINE V1.0.0
@Component: PermissionCore (Refactored - Adapter Loader)
@Path: ReplicatedStorage.OVHL.Systems.Security.PermissionCore
@Purpose: Load permission adapter based on config, delegate permission checks
@Stability: STABLE
--]]

local PermissionCore = {}
PermissionCore.__index = PermissionCore

function PermissionCore.new()
	local self = setmetatable({}, PermissionCore)
	self._logger = nil
	self._adapter = nil -- Will be loaded in Initialize
	self._adapterName = nil
	return self
end

function PermissionCore:Initialize(logger)
	self._logger = logger

	-- Load config to determine which adapter to use
	local ConfigLoader = require(script.Parent.Parent.Parent.Config.ConfigLoader)
	local engineConfig = ConfigLoader:LoadEngineConfig()

	if not engineConfig or not engineConfig.Adapters then
		self._logger:Warn("PERMISSION", "No adapter config found, using Internal")
		self._adapterName = "InternalAdapter"
	else
		self._adapterName = engineConfig.Adapters.Permission or "InternalAdapter"
	end

	self._logger:Info("PERMISSION", "PermissionCore initialized (will load adapter on Start)", {
		adapter = self._adapterName,
	})
end

function PermissionCore:Start()
	-- Load the selected adapter
	local adapterPath = script.Parent.Parent.Adapters.Permission:FindFirstChild(self._adapterName)

	if not adapterPath then
		self._logger:Warn("PERMISSION", "Adapter not found, falling back to Internal", {
			requested = self._adapterName,
		})
		adapterPath = script.Parent.Parent.Adapters.Permission:FindFirstChild("InternalAdapter")
	end

	if not adapterPath then
		self._logger:Critical("PERMISSION", "CRITICAL: No adapters found!")
		return false
	end

	-- Load adapter
	local success, AdapterClass = pcall(require, adapterPath)

	if not success then
		self._logger:Error("PERMISSION", "Failed to load adapter", {
			adapter = self._adapterName,
			error = tostring(AdapterClass),
		})

		-- Try Internal fallback
		local internalPath = script.Parent.Parent.Adapters.Permission:FindFirstChild("InternalAdapter")
		if internalPath then
			success, AdapterClass = pcall(require, internalPath)
		end
	end

	if success and AdapterClass then
		self._adapter = AdapterClass.new()
		self._adapter:Initialize(self._logger)

		self._logger:Info("PERMISSION", "Permission adapter loaded", {
			adapter = self._adapterName,
		})
		return true
	else
		self._logger:Critical("PERMISSION", "FAILED: Could not load any adapter")
		return false
	end
end

function PermissionCore:Check(player, permissionNode)
	if not self._adapter then
		self._logger:Error("PERMISSION", "Adapter not initialized")
		return false, "Adapter not ready"
	end

	local allowed, reason = self._adapter:CheckPermission(player, permissionNode)

	if allowed then
		self._logger:Debug("PERMISSION", "Access Granted", {
			player = player.Name,
			node = permissionNode,
		})
	else
		self._logger:Warn("PERMISSION", "Access Denied", {
			player = player.Name,
			node = permissionNode,
			reason = reason,
		})
	end

	return allowed, reason
end

function PermissionCore:GetRank(player)
	if not self._adapter then
		return 0
	end

	if self._adapter.GetRank then
		return self._adapter:GetRank(player)
	end

	return 0
end

function PermissionCore:SetRank(player, rank)
	if not self._adapter then
		return false
	end

	if self._adapter.SetRank then
		return self._adapter:SetRank(player, rank)
	end

	return false
end

return PermissionCore

--[[
@End: PermissionCore.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]
