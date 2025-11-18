--[[
OVHL ENGINE V1.0.0
@Component: RateLimiterManifest (Security)
@Path: ReplicatedStorage.OVHL.Systems.Security.RateLimiterManifest
@Purpose: Manifest file for RateLimiter
@Stability: STABLE
--]]

-- [PHASE 1 FIX] Pindah ke Server (Context: Server)
return {
    name = "RateLimiter",
    dependencies = {"SmartLogger", "ConfigLoader"},
    context = "Server" -- SECURITY FIX: Server only
}
