--[[
	TOPBAR ZOMBIE DEBUG SCRIPT V1.1.2
	Place in: StarterPlayer > StarterPlayerScripts
	Name: OVHL_TopbarDebug.client.lua
	Run after game starts
--]]

task.wait(3)

print("\n" .. string.rep("=", 60))
print("[TOPBAR-DEBUG] Starting TopbarPlus analysis...")
print(string.rep("=", 60))

local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

if not success or not Icon then
	print("[FAIL] TopbarPlus not found")
	return
end

print("[OK] TopbarPlus module loaded")

-- Check IconController
if not Icon.IconController then
	print("[FAIL] IconController not available")
	return
end

print("[OK] IconController available")

-- Get all current icons
local icons = Icon.IconController:getIcons()
print(string.format("[INFO] Total icons in controller: %d", #icons))

print("\n[SCAN] Current icons:")
for i, icon in ipairs(icons) do
	local nameResult = { pcall(function()
		return icon:getName()
	end) }
	local labelResult = { pcall(function()
		return icon:getLabel()
	end) }

	local name = (nameResult[1] and nameResult[2]) or "N/A"
	local label = (labelResult[1] and labelResult[2]) or "N/A"

	print(string.format("  [%d] Name='%s' | Label='%s'", i, tostring(name), tostring(label)))
end

-- Check for duplicates
print("\n[CHECK] Looking for duplicates...")
local labelCounts = {}
for _, icon in ipairs(icons) do
	local labelResult = { pcall(function()
		return icon:getLabel()
	end) }
	local label = (labelResult[1] and labelResult[2]) or "N/A"

	labelCounts[label] = (labelCounts[label] or 0) + 1
end

local hasDuplicates = false
for label, count in pairs(labelCounts) do
	if count > 1 then
		print(string.format("[ALERT] DUPLICATE FOUND: '%s' appears %d times!", label, count))
		hasDuplicates = true
	end
end

if not hasDuplicates then
	print("[OK] No duplicates detected!")
end

-- Check internal state
print("\n[DEBUG] Internal IconController state:")
if Icon.IconController._icons then
	print(string.format("  IconController._icons table size: %d", #Icon.IconController._icons))
elseif Icon.IconController.icons then
	print(string.format("  IconController.icons table size: %d", #Icon.IconController.icons))
else
	print("  [INFO] No internal _icons or icons table found")
end

-- Test cleanup function
print("\n[TEST] Testing icon cleanup...")
if Icon.IconController.getIcons and Icon.IconController:getIcons()[1] then
	local testIcon = Icon.IconController:getIcons()[1]
	local nameResult = { pcall(function()
		return testIcon:getName()
	end) }
	local testName = (nameResult[1] and nameResult[2]) or "TestIcon"

	print(string.format("  Attempting to destroy test icon: '%s'", testName))
	local destroySuccess, destroyErr = pcall(function()
		testIcon:destroy()
	end)

	if destroySuccess then
		print("[OK] Icon destroyed successfully")
		-- Check if it's gone
		task.wait(0.5)
		local iconsAfter = Icon.IconController:getIcons()
		print(string.format("  Icons before: %d -> after: %d", #icons, #iconsAfter))
	else
		print(string.format("[FAIL] Destroy failed: %s", tostring(destroyErr)))
	end
end

print("\n" .. string.rep("=", 60))
print("[TOPBAR-DEBUG] Analysis complete")
print(string.rep("=", 60) .. "\n")
