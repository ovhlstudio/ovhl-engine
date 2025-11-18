--[[
OVHL ENGINE V1.0.0
@Component: PermissionCoreManifest (Core)
@Path: ReplicatedStorage.OVHL.Systems.Security.PermissionCoreManifest
@Purpose: Manifest file for PermissionCore
@Stability: STABLE
--]]

-- [PHASE 1 FIX] Pindah ke Server (Context: Server)
return {
    name = "PermissionCore",
    dependencies = {"SmartLogger", "ConfigLoader"},
    context = "Server" -- SECURITY FIX: Client blocked
}
