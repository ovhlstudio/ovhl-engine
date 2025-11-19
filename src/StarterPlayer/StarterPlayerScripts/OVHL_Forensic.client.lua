--[[
	🕵️‍♂️ OVHL DATA FORENSIC UNIT
	Tujuan: Melacak dari mana "HELLO !!" menyusup masuk ke ModuleTestV2.
]]

task.wait(2) -- Tunggu loading awal reda
print("\n" .. string.rep("🟥", 20))
print("🕵️‍♂️ STARTING DATA FORENSIC ANALYSIS")
print(string.rep("🟥", 20))

local RS = game:GetService("ReplicatedStorage")
local OVHL_Folder = RS:WaitForChild("OVHL")
local Modules = OVHL_Folder.Shared.Modules

-- 1. CEK FISIK FOLDER & FILE
print("\n[1] PHYSICAL FILE CHECK")
local v2Folder = Modules:FindFirstChild("ModuleTestV2")
if v2Folder then
	print("✅ Folder ModuleTestV2 found.")
	local sharedConf = v2Folder:FindFirstChild("SharedConfig")
	if sharedConf then
		print("✅ SharedConfig found inside ModuleTestV2.")
	else
		warn("❌ SharedConfig MISSING inside ModuleTestV2!")
	end
else
	warn("❌ Folder ModuleTestV2 NOT FOUND in ReplicatedStorage!")
end

-- 2. RAW REQUIRE (BYPASS CONFIG LOADER)
print("\n[2] RAW DATA EXTRACTION (Bypassing Loader)")
if v2Folder and v2Folder:FindFirstChild("SharedConfig") then
	local success, data = pcall(require, v2Folder.SharedConfig)
	if success then
		print("   Raw Require Result:")
		print("   - ModuleName:", data.ModuleName)

		if data.UI and data.UI.Topbar then
			print("   - UI.Topbar.Text:", data.UI.Topbar.Text) -- INI KUNCINYA

			if data.UI.Topbar.Text == "HELLO !!" then
				warn("🚨 CRITICAL: FILE FISIKNYA MEMANG ISINYA 'HELLO !!'. CEK SCRIPT EDITOR!")
			elseif data.UI.Topbar.Text == "TEST V2 SUKSES" then
				print("✅ Raw File is CORRECT ('TEST V2 SUKSES'). Masalah ada di ConfigLoader.")
			else
				warn("⚠️ Unknown Text Content:", data.UI.Topbar.Text)
			end
		else
			warn("❌ Config structure invalid (Missing UI.Topbar)")
		end
	else
		warn("❌ Failed to require SharedConfig:", data)
	end
end

-- 3. CONFIG LOADER SIMULATION
print("\n[3] CONFIG LOADER SIMULATION")
local success, ConfigLoader = pcall(function()
	return require(OVHL_Folder.Systems.Foundation.ConfigLoader).new()
end)

if success then
	print("✅ ConfigLoader Instantiated.")

	-- Debug LoadSharedConfig specifically
	local sharedLoad = ConfigLoader:LoadSharedConfig("ModuleTestV2")
	if sharedLoad then
		print(
			"   LoadSharedConfig('ModuleTestV2') returned Text:",
			sharedLoad.UI and sharedLoad.UI.Topbar and sharedLoad.UI.Topbar.Text
		)
	else
		warn("❌ LoadSharedConfig returned nil!")
	end

	-- Debug Full Resolution (Simulate what Controller does)
	-- NOTE: GetClientSafeConfig force-calls "Server" context.
	local resolved = ConfigLoader:ResolveConfig("ModuleTestV2", "Server")
	print(
		"   ResolveConfig('ModuleTestV2', 'Server') returned Text:",
		resolved.UI and resolved.UI.Topbar and resolved.UI.Topbar.Text
	)
else
	warn("❌ Failed to load ConfigLoader System")
end

print(string.rep("🟥", 20) .. "\n")
