--[[ @Component: DomainResolver (Enhanced Mapping) ]]
local DomainResolver = {}

local DOMAIN_MAPPINGS = {
    -- Server Services
    ["PermissionService"] = "PERMISSION",
    ["DataManager"] = "DATA",
    ["NotificationService"] = "NOTIFICATION",
    ["HDAdminAdapter"] = "HDADMIN",
    ["InternalPolicy"] = "POLICY",
    
    -- Server Modules
    ["InventoryService"] = "INVENTORY",
    ["PrototypeShopService"] = "SHOP",
    
    -- Server Core
    ["NetworkBridge"] = "NETWORK",
    ["NetworkGuard"] = "NETWORK",
    ["RateLimiter"] = "SYSTEM",
    ["Kernel"] = "SYSTEM",
    
    -- Client Controllers
    ["TopbarPlusAdapter"] = "TOPBAR",
    ["NotificationController"] = "NOTIFICATION",
    ["AdminController"] = "ADMIN",
    
    -- Client Modules
    ["InventoryController"] = "INVENTORY",
    ["InventoryView"] = "INVENTORY",
    ["PrototypeShopController"] = "SHOP",
    ["PrototypeShopView"] = "SHOP",
    
    -- Client Core
    ["UIService"] = "UI",
    ["FinderService"] = "FINDER",
    ["AssetLoader"] = "ASSET",
    
    -- Shared Core
    ["SmartLogger"] = "LOGGER",
    ["AssetSystem"] = "ASSET",
    ["EngineEnums"] = "ENUM",
    ["PermissionCore"] = "PERMISSION",
    ["SharedConfigLoader"] = "CONFIG",
    ["CoreTypes"] = "TYPE",
    
    -- Shared Configs
    ["AdminSharedConfig"] = "ADMIN",
    ["InventorySharedConfig"] = "INVENTORY",
    ["ShopSharedConfig"] = "SHOP",
    
    -- UI Components
    ["Button"] = "UI",
    ["TextField"] = "UI",
    ["Window"] = "UI",
    ["Theme"] = "UI"
}

function DomainResolver.Resolve(moduleName)
    if DOMAIN_MAPPINGS[moduleName] then
        return DOMAIN_MAPPINGS[moduleName]
    end
    
    local domain = moduleName
    domain = domain:gsub("Controller$", "")
    domain = domain:gsub("Service$", "")
    domain = domain:gsub("Adapter$", "")
    domain = domain:gsub("View$", "")
    domain = domain:gsub("Manager$", "")
    domain = domain:gsub("System$", "")
    domain = domain:gsub("Panel$", "")
    domain = domain:upper()
    
    if domain:find("ADMIN") then return "ADMIN" end
    if domain:find("INVENTORY") then return "INVENTORY" end
    if domain:find("SHOP") then return "SHOP" end
    if domain:find("NETWORK") then return "NETWORK" end
    if domain:find("PERMISSION") then return "PERMISSION" end
    if domain:find("NOTIFICATION") then return "NOTIFICATION" end
    if domain:find("UI") or domain:find("THEME") or domain:find("BUTTON") then return "UI" end
    if domain:find("DATA") then return "DATA" end
    if domain:find("CONFIG") then return "CONFIG" end
    
    return "SYSTEM"
end

function DomainResolver.GetMappings()
    return DOMAIN_MAPPINGS
end

return DomainResolver
