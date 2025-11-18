--[[
OVHL ENGINE V3.4.0 (ADR-004)
@Component: ServerRuntime
@Path: ServerScriptService.OVHL.ServerRuntime.server.lua
@Purpose: (V3.4.0) Entry point server. Menambahkan hook BindToClose untuk memicu Fase 4 (Shutdown).
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Bootstrap = require(ReplicatedStorage.OVHL.Core.Bootstrap)

-- Helper for table size
local function count(t)
	local c = 0
	for _ in pairs(t) do
		c = c + 1
	end
	return c
end

local OVHL = Bootstrap:Initialize()
local Logger = OVHL:GetSystem("SmartLogger")

Logger:Info("SERVER", "🚀 Starting OVHL Server Runtime V3.4.0 (4-Phase)")

local Kernel = require(ReplicatedStorage.OVHL.Core.Kernel).new()
Kernel:Initialize(Logger)
local modulesFound = Kernel:ScanModules()

local SystemRegistry = OVHL:GetSystem("SystemRegistry")
if SystemRegistry then
	Logger:Info("SYSTEMREGISTRY", "SystemRegistry initialized (V3.4.0)")
end

Knit.Start()
	:andThen(function()
		Logger:Info("SERVER", "Knit started")
		local registeredCount = Kernel:RegisterKnitServices(Knit)
		Kernel:RunVerification()

		local securitySystems = { "InputValidator", "RateLimiter", "PermissionCore", "SecurityHelper" }
		local securityReady = 0
		for _, name in ipairs(securitySystems) do
			if OVHL:GetSystem(name) then
				securityReady = securityReady + 1
			end
		end

		Logger:Info("SERVER", "🎉 OVHL Server Ready", {
			modules = modulesFound,
			kernel = registeredCount,
			security = securityReady .. "/" .. #securitySystems,
		})
	end)
	:catch(function(err)
		Logger:Critical("SERVER", "Runtime Failed", { error = tostring(err) })
	end)

-- [BARU V3.4.0] Implementasi Fase 4 (Shutdown) saat game ditutup
game:BindToClose(function()
	if SystemRegistry then
		Logger:Critical("SERVER", "Game closing. Initiating OVHL Fase 4 (Shutdown)...")

		-- Ini akan memanggil :Destroy() pada semua sistem secara terbalik
		SystemRegistry:Shutdown()
	else
		Logger:Critical("SERVER", "Game closing. SystemRegistry not found! Cannot run Phase 4.")
	end

	-- Beri waktu 1 detik untuk proses cleanup sebelum server benar-benar mati
	task.wait(1)
end)

--[[
@End: ServerRuntime.server.lua
@Version: 3.4.0 (ADR-004)
@See: docs/ADR_V3-4-0.md (Diusulkan)
--]]
