--[[
	OVHL ENGINE V.1.2.2 - CONFIG LOADER SYSTEM (PATCHED)
	@Component: ConfigLoader (Foundation)
	@Path: ReplicatedStorage.OVHL.Systems.Foundation.ConfigLoader
	@Fixes: CRITICAL! MergeDeep now performs true deep copy to prevent EngineConfig pollution.
--]]

local ConfigLoader = {}
ConfigLoader.__index = ConfigLoader

function ConfigLoader.new()
	local self = setmetatable({}, ConfigLoader)
	self._logger = nil
	return self
end

function ConfigLoader:Initialize(logger)
	self._logger = logger
	self._logger:Info("CONFIG", "ConfigLoader initialized (DeepMerge Fixed)")
end

function ConfigLoader:ResolveConfig(moduleName, context)
	local finalConfig = {}

	-- LAYER 1: Engine Config
	local engineConfig = self:LoadEngineConfig()
	self:MergeDeep(finalConfig, engineConfig)

	-- LAYER 2: Shared Module Config
	local sharedConfig = self:LoadSharedConfig(moduleName)
	if sharedConfig then
		self:MergeDeep(finalConfig, sharedConfig)
	end

	-- LAYER 3: Context-Specific Config
	if context == "Server" then
		local serverConfig = self:LoadServerConfig(moduleName)
		if serverConfig then
			self:MergeDeep(finalConfig, serverConfig)
		end
	elseif context == "Client" then
		local clientConfig = self:LoadClientConfig(moduleName)
		if clientConfig then
			self:MergeDeep(finalConfig, clientConfig)
		end
	end

	return finalConfig
end

function ConfigLoader:LoadEngineConfig()
	local success, config = pcall(function()
		return require(game:GetService("ReplicatedStorage").OVHL.Config.EngineConfig)
	end)
	return success and config or {}
end

function ConfigLoader:LoadSharedConfig(moduleName)
	local success, config = pcall(function()
		return require(game:GetService("ReplicatedStorage").OVHL.Shared.Modules[moduleName].SharedConfig)
	end)
	return success and config or nil
end

function ConfigLoader:LoadServerConfig(moduleName)
	local success, config = pcall(function()
		return require(game:GetService("ServerScriptService").OVHL.Modules[moduleName].ServerConfig)
	end)
	return success and config or nil
end

function ConfigLoader:LoadClientConfig(moduleName)
	local success, config = pcall(function()
		return require(game:GetService("StarterPlayer").StarterPlayerScripts.OVHL.Modules[moduleName].ClientConfig)
	end)
	return success and config or nil
end

-- [CRITICAL FIX] TRUE DEEP MERGE
-- Mencegah referensi table 'source' mencemari 'target'
function ConfigLoader:MergeDeep(target, source)
	for key, value in pairs(source) do
		if type(value) == "table" then
			-- Jika target belum punya table, BUAT BARU (Break Reference)
			if type(target[key]) ~= "table" then
				target[key] = {}
			end
			-- Recurse ke dalam table baru tersebut
			self:MergeDeep(target[key], value)
		else
			-- Jika primitive value, langsung assign
			target[key] = value
		end
	end
end

function ConfigLoader:GetClientSafeConfig(moduleName)
	local serverConfig = self:ResolveConfig(moduleName, "Server")
	local clientSafe = {}
	local SENSITIVE_KEYS = {"Permissions", "API", "DebugMode", "APIKey", "Secret", "Token"}

	for key, value in pairs(serverConfig) do
		local isSensitive = false
		for _, sensitiveKey in ipairs(SENSITIVE_KEYS) do
			if string.lower(tostring(key)) == string.lower(tostring(sensitiveKey)) then
				isSensitive = true
				break
			end
		end
		if not isSensitive then
			clientSafe[key] = value
		end
	end
	return clientSafe
end

return ConfigLoader
