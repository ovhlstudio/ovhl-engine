--[[
OVHL ENGINE V3.2.3 (HOTFIX)
@Component: DataManager Manifest
@Path: ReplicatedStorage.OVHL.Systems.Advanced.DataManagerManifest
@Purpose: Deklarasi dependensi V3.2.2 untuk DataManager.
--]]

return {
	name = "DataManager",
	dependencies = { "SmartLogger", "ConfigLoader" },
	context = "Server",
}

--[[
@End: DataManagerManifest.lua
@Version: 3.2.3 (Patched)
@See: docs/ADR_V3-2-2.md
--]]
