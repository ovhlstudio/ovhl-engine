--[[
	OVHL DIAGNOSTIC SCRIPT V1.1.2
	@Purpose: Test HD Admin integration and TopbarPlus functionality
	@How to use: Place in StarterPlayer > StarterPlayerScripts, name it OVHL_Diagnostic.client.lua
	@Runtime: Client-side
--]]

task.wait(5) -- Wait for everything to initialize

print("\n" .. string.rep("=", 60))
print("[DIAGNOSTIC] OVHL V1.1.2 DIAGNOSTIC START")
print(string.rep("=", 60))

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ========== TEST 1: HD ADMIN RANK REPLICATION ==========
print("\n[TEST 1] HD Admin Rank Replication")
print("-" .. string.rep("-", 58))

local function checkRankAttribute()
	local rank = player:GetAttribute("OVHL_Rank")
	if rank then
		print(string.format("[OK] Rank attribute received: %d", rank))
		return rank
	else
		print("[WAIT] Rank attribute NOT SET (waiting for server...)")
		return nil
	end
end

print("Initial check...")
local initialRank = checkRankAttribute()

if not initialRank then
	print("Waiting 10 seconds for rank sync...")
	task.wait(10)
	local synced = checkRankAttribute()
	if synced then
		print("[OK] Rank synced after wait!")
	else
		print("[FAIL] Rank still not synced. Server may be having issues.")
	end
end

-- ========== TEST 2: TOPBARPLUS ICON CHECK ==========
print("\n[TEST 2] TopbarPlus Icon Enumeration")
print("-" .. string.rep("-", 58))

local success, Icon = pcall(function()
	local mod = ReplicatedStorage:FindFirstChild("Icon")
	if mod then
		return require(mod)
	end
	local packages = ReplicatedStorage:FindFirstChild("Packages")
	if packages then
		return require(packages:FindFirstChild("Icon") or packages:FindFirstChild("TopbarPlus"))
	end
	return nil
end)

if success and Icon then
	print("[OK] TopbarPlus module found")

	if Icon.IconController then
		print("[OK] IconController available")

		if Icon.IconController.getIcons then
			local icons = Icon.IconController:getIcons()
			print(string.format("Total icons: %d", #icons))

			for i, icon in ipairs(icons) do
				local nameResult = { pcall(function()
					return icon:getName()
				end) }
				local labelResult = { pcall(function()
					return icon:getLabel()
				end) }
				local name = nameResult[1] and nameResult[2] or "ERROR"
				local label = labelResult[1] and labelResult[2] or "ERROR"
				print(string.format("  [%d] Name: %s | Label: %s", i, tostring(name), tostring(label)))
			end
		else
			print("[FAIL] getIcons() not available")
		end
	else
		print("[FAIL] IconController not available in module")
	end
else
	print("[FAIL] TopbarPlus NOT found")
end

-- ========== TEST 3: OVHL PERMISSION CORE ==========
print("\n[TEST 3] PermissionCore Status (Client)")
print("-" .. string.rep("-", 58))

local success, OVHL = pcall(function()
	return require(ReplicatedStorage.OVHL.Core.OVHL)
end)

if success then
	local PermCore = OVHL.GetSystem("PermissionCore")
	if PermCore then
		print("[OK] PermissionCore loaded")
		print(string.format("  Adapter available: %s", tostring(PermCore._adapter ~= nil)))
		if PermCore._adapter then
			print(string.format("  Adapter type: %s", PermCore._adapter._logger and "Initialized" or "Not initialized"))
		end
	else
		print("[FAIL] PermissionCore not found")
	end
else
	print("[FAIL] Failed to load OVHL")
end

-- ========== TEST 4: UI SYSTEMS CHECK ==========
print("\n[TEST 4] UI Systems Status")
print("-" .. string.rep("-", 58))

if success then
	local systems = { "UIEngine", "UIManager", "AssetLoader" }
	for _, sysName in ipairs(systems) do
		local sys = OVHL.GetSystem(sysName)
		if sys then
			print(string.format("[OK] %s loaded", sysName))
		else
			print(string.format("[FAIL] %s NOT found", sysName))
		end
	end
else
	print("SKIPPED (OVHL not loaded)")
end

-- ========== TEST 5: ATTRIBUTE LISTENER ==========
print("\n[TEST 5] Real-time Rank Attribute Listener")
print("-" .. string.rep("-", 58))
print("Listening for rank changes for 20 seconds...")

local changeCount = 0
local conn = player:GetAttributeChangedSignal("OVHL_Rank"):Connect(function()
	changeCount = changeCount + 1
	local newRank = player:GetAttribute("OVHL_Rank")
	print(string.format("  [Update %d] Rank changed to: %d", changeCount, newRank or 0))
end)

task.wait(20)
conn:Disconnect()

if changeCount > 0 then
	print(string.format("[OK] Received %d rank update(s)", changeCount))
else
	print("[FAIL] No rank updates received (possible issue)")
end

-- ========== SUMMARY ==========
print("\n" .. string.rep("=", 60))
print("[DIAGNOSTIC] OVHL V1.1.2 DIAGNOSTIC COMPLETE")
print(string.rep("=", 60))
print("\nRECOMMENDATIONS:")
if initialRank then
	print("[OK] Rank system working correctly")
else
	print("[ALERT] Check: Server HD Admin API connection")
	print("        Look at Server console for 'returned 0' messages")
end
print("\nFor detailed logs, check:")
print("  - Server: ServerScriptService output")
print("  - Client: Studio/Game console")
print(string.rep("=", 60) .. "\n")
