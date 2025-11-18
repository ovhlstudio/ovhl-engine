--[[
OVHL ENGINE V1.0.0
@Component: ClientRuntime.client (Entry Point)
@Path: StarterPlayer.StarterPlayerScripts.OVHL.ClientRuntime.client
@Purpose: Client-side bootstrap - initialize OVHL systems and Knit framework
@Stability: STABLE
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Bootstrap = require(ReplicatedStorage.OVHL.Core.Bootstrap)
local OVHL = Bootstrap:Initialize()
local Logger = OVHL:GetSystem("SmartLogger")

Logger:Info("CLIENT", "🚀 Starting OVHL Client Runtime V1.0.0")

local Kernel = require(ReplicatedStorage.OVHL.Core.Kernel).new()
Kernel:Initialize(Logger)

local modulesFound = Kernel:ScanModules()
Logger:Debug("CLIENT", "Pre-Knit system verification")

local uiSystems = { "UIEngine", "UIManager", "AssetLoader" }
local uiReady = 0
for _, systemName in ipairs(uiSystems) do
	local system = OVHL:GetSystem(systemName)
	if system then
		if system.Initialize then
			system:Initialize(Logger)
		end
		uiReady = uiReady + 1
		Logger:Debug("UI", "UI system ready", { system = systemName })
	else
		Logger:Warn("UI", "UI system not available", { system = systemName })
	end
end

Knit.Start()
	:andThen(function()
		Logger:Info("CLIENT", "Knit framework started successfully")

		local registeredCount = Kernel:RegisterKnitServices(Knit)
		Kernel:RunVerification()

		-- FIX: Safe access to Knit.Controllers (Handle if nil)
		local controllers = Knit.Controllers or {}
		local knitControllerCount = 0

		for controllerName, controller in pairs(controllers) do
			knitControllerCount = knitControllerCount + 1
			Logger:Debug("KERNEL", "Knit controller operational", {
				controller = controllerName,
				type = typeof(controller),
			})
		end

		Logger:Info("CLIENT", "🎉 OVHL Client Ready", {
			modules = modulesFound,
			kernel = registeredCount,
			controllers = knitControllerCount,
			ui = uiReady .. "/" .. #uiSystems,
		})

		Logger:Critical("BOOT", "🎊 CLIENT BOOT COMPLETE")
	end)
	:catch(function(err)
		Logger:Critical("CLIENT", "Runtime Failed", { error = tostring(err) })

		-- Emergency UI
		pcall(function()
			local sg = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
			local tl = Instance.new("TextLabel", sg)
			tl.Size = UDim2.new(1, 0, 0.1, 0)
			tl.Text = "OVHL Error: " .. tostring(err)
			tl.TextColor3 = Color3.new(1, 0, 0)
		end)
	end)

--[[
@End: ClientRuntime.client.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]
