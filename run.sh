#!/bin/bash

echo "🎯 FINAL FIX - COMPLETE DOMAIN MAPPING"
echo "======================================"

# --------------------------------------------------
# 1. FIX CLIENT KERNEL DOMAIN MAPPING
# --------------------------------------------------
echo "⚡ Fixing Client Kernel Domain Mapping..."

cat > "src/StarterPlayer/StarterPlayerScripts/OVHL/Core/Kernel.lua" << 'EOF'
--[[ @Component: Kernel (Client - Complete Domain Mapping) ]]
local RS = game:GetService("ReplicatedStorage")
local PS = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts")

local Logger = require(RS.OVHL.Core.SmartLogger)
local Config = require(RS.OVHL.Core.SharedConfigLoader)
local Bridge = require(PS.OVHL.Core.NetworkBridge)

-- V2 SERVICES
local FinderService = require(PS.OVHL.Core.FinderService)
local UIService     = require(PS.OVHL.Core.UIService)
local Topbar        = require(PS.OVHL.Controllers.TopbarPlusAdapter)

local Kernel = {}

function Kernel.Boot()
    local log = Logger.New("SYSTEM")
    log:Info("🚀 CLIENT STARTUP (Complete Domain Mapping)")
    
    -- Enhanced Topbar dengan domain yang proper
    local topbarInstance = Topbar.New()
    
    -- CONTEXT INJECTION
    local ctx = {
        Logger = log,
        Network = Bridge.New(),
        Finder = FinderService,
        UI = UIService,
        Topbar = topbarInstance
    }
    
    topbarInstance:Init({ Logger = Logger.New("TOPBAR") })
    
    local modules = {}
    
    local function Scan(dir)
        if not dir then return end
        for _, f in ipairs(dir:GetChildren()) do
            if f:IsA("Folder") then
                local script = f:FindFirstChild("Controller")
                if script then
                    local mod = require(script)
                    mod.Name = f.Name
                    mod._config = Config.Load(f.Name)
                    
                    -- COMPLETE DOMAIN MAPPING
                    if f.Name == "Admin" then
                        mod.Logger = Logger.New("ADMIN")
                    elseif f.Name == "Inventory" then
                        mod.Logger = Logger.New("INVENTORY")
                    elseif f.Name == "PrototypeShop" then
                        mod.Logger = Logger.New("SHOP")
                    else
                        mod.Logger = Logger.New("SYSTEM")
                    end
                    
                    modules[f.Name] = mod
                    mod.Logger:Debug("Controller initialized", {Name = f.Name})
                end
            end
        end
    end
    
    Scan(PS.OVHL.Modules)
    Scan(PS.OVHL.Controllers)

    log:Info("Phase 1: Init Modules")
    for _, m in pairs(modules) do
        if m.Init then pcall(function() m:Init(ctx) end) end
    end
    
    log:Info("Phase 2: Start Modules")
    for name, m in pairs(modules) do
        task.spawn(function()
            if m._config and m._config.Topbar and m._config.Topbar.Enabled then
                local t_cfg = m._config.Topbar
                ctx.Topbar:Add(name, t_cfg, function(state) 
                    if m.Toggle then m:Toggle(state) end 
                end)
            end
            if m.Start then m:Start() end
        end)
    end
    
    log:Info("✅ CLIENT READY (Services Active)")
end

return Kernel
EOF

# --------------------------------------------------
# 2. FIX UI COMPONENTS DOMAIN
# --------------------------------------------------
echo "🎨 Fixing UI Components Domain..."

# Update Button component
sed -i '5s/Logger.New("UX")/Logger.New("UI")/' "src/ReplicatedStorage/OVHL/UI/Components/Inputs/Button.lua"

# Update other UI components jika ada
find "src/ReplicatedStorage/OVHL/UI" -name "*.lua" -exec sed -i 's/Logger.New("UX")/Logger.New("UI")/g' {} \;

# --------------------------------------------------
# 3. FIX MODULE VIEWS DOMAIN
# --------------------------------------------------
echo "📱 Fixing Module Views Domain..."

# Update Inventory View
if [ -f "src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/Inventory/View.lua" ]; then
    sed -i 's/self.Log = ctx.Logger/self.Log = require(game:GetService("ReplicatedStorage").OVHL.Core.SmartLogger).New("INVENTORY")/' "src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/Inventory/View.lua"
fi

# Update Shop View  
if [ -f "src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypeShop/View.lua" ]; then
    sed -i 's/self.Ctx.Logger/require(game:GetService("ReplicatedStorage").OVHL.Core.SmartLogger).New("SHOP")/' "src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypeShop/View.lua"
fi

# --------------------------------------------------
# 4. UPDATE DOMAIN RESOLVER FOR BETTER MAPPING
# --------------------------------------------------
echo "🧠 Enhancing Domain Resolver..."

cat > "src/ReplicatedStorage/OVHL/Core/Logging/DomainResolver.lua" << 'EOF'
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
EOF

echo ""
echo "🎉 FINAL DOMAIN FIX COMPLETED!"
echo ""
echo "📊 EXPECTED DOMAIN MAPPING:"
echo "   • Admin Panel → 👑 ADMIN"
echo "   • Inventory → 🎒 INVENTORY" 
echo "   • Shop → 🏪 SHOP"
echo "   • UI Components → 🎨 UI"
echo "   • Topbar → 🔘 TOPBAR"
echo ""
echo "🚀 RESTART UNTUK VERIFY DOMAIN MAPPING!"
EOF


echo "🎯 FINAL DOMAIN FIX DEPLOYED - SYSTEM HARUSNYA SEMPURNA SEKARANG!"