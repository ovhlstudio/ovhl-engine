--[[ @Component: DomainResolver (V17 - Smart Deduction) ]]
local DomainResolver = {}

local MANUAL_MAPPINGS = {
    -- Core Hardcodes (Keep these for consistency)
    ["PermissionService"] = "PERMISSION",
    ["DataManager"] = "DATA",
    ["HDAdminAdapter"] = "HD_ADMIN",
    ["InternalDB"] = "DATABASE",
}

function DomainResolver.Resolve(moduleName)
    -- 1. Cek Mapping Manual
    if MANUAL_MAPPINGS[moduleName] then
        return MANUAL_MAPPINGS[moduleName]
    end
    
    -- 2. Smart String Cleaning (Auto-Domain)
    -- "InventoryController" -> "INVENTORY"
    -- "ShopSystem" -> "SHOP"
    local domain = moduleName
    domain = domain:gsub("Controller$", "")
    domain = domain:gsub("Service$", "")
    domain = domain:gsub("Adapter$", "")
    domain = domain:gsub("Manager$", "")
    domain = domain:gsub("System$", "")
    domain = domain:gsub("Panel$", "")
    
    -- Return UPPERCASE string. 
    -- SmartLogger V17 akan otomatis kasih icon 📦 kalau ini belum terdaftar di Config.
    return domain:upper()
end

return DomainResolver
