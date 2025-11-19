--[[
	TOPBAR SETUP CALL COUNTER
	Place in: StarterPlayer > StarterPlayerScripts
	Name: OVHL_TopbarCallCounter.client.lua
	Purpose: Monitor how many times SetupTopbar is called
--]]

task.wait(3)

print("\n" .. string.rep("=", 60))
print("[COUNTER] Waiting 5 seconds to check SetupTopbar call count...")
print(string.rep("=", 60))

task.wait(5)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

-- Get MinimalController
local minimalCtrl = Knit.GetController("MinimalController")
if minimalCtrl and minimalCtrl.GetDebugStats then
	local stats = minimalCtrl:GetDebugStats()

	print("\n" .. string.rep("=", 60))
	print("[RESULT] SETUP CALL COUNTS:")
	print(string.rep("=", 60))
	print(string.format("SetupUI called: %d times", stats.setupUICallCount or 0))
	print(string.format("SetupInput called: %d times", stats.setupInputCallCount or 0))
	print(string.format("SetupTopbar called: %d times", stats.setupTopbarCallCount or 0))
	print(string.rep("=", 60))

	if stats.setupTopbarCallCount > 1 then
		print("[ALERT] SetupTopbar called MULTIPLE TIMES!")
		print("        This explains the double buttons!")
	else
		print("[OK] SetupTopbar called only once (normal)")
	end

	print(string.rep("=", 60) .. "\n")
else
	print("[FAIL] Cannot get MinimalController or GetDebugStats not available")
end
