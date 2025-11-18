> START OF ./docs/200_USER_GUIDES/201_CONTRIBUTING_MODULE.md
>
> **OVHL ENGINE V1.0.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** GAMEPLAY PROGRAMMERS, USERS
> **PURPOSE:** "Cookbook" dan "Golden Standard" untuk membuat Modul Gameplay baru menggunakan Knit + OVHL pattern.

---

# 🍳 201_CONTRIBUTING_MODULE.md (V1.0.0)

> **CATATAN:** Dokumen ini adalah template + guide untuk membuat modul baru yang patuh OVHL patterns.
> **Reference:** Lihat `MinimalModule` di snapshot sebagai contoh lengkap.

---

## 1. KONSEP DASAR

### **Apa itu Modul?**

Modul adalah **fitur gameplay** (Shop, Inventory, Quest, etc) yang dibuat dengan Knit Service/Controller pattern.

**Bukan:** Sistem engine (bukan Logger, bukan DataManager, dll)

**Struktur:**

```
Modules/[ModuleName]/
├── Shared/
│   └── SharedConfig.lua          # Kontrak: schema, izin, rate limit
├── Server/
│   ├── [Name]Service.lua         # Business logic server
│   └── ServerConfig.lua          # Rahasia: API keys, db creds
└── Client/
    ├── [Name]Controller.lua      # Logic client + UI
    └── ClientConfig.lua          # Preferensi: keybinds, theme
```

### **3-Config Pattern**

Setiap modul wajib punya 3 file config yang di-merge secara layered:

1. **SharedConfig.lua** (ReplicatedStorage)

   - Accessible: Both client + server
   - Isi: Kontrak data, schema validasi, permission rules, rate limits
   - Public: TIDAK ada secret data di sini

2. **ServerConfig.lua** (ServerScriptService)

   - Accessible: Server only
   - Isi: API keys, database credentials, secret settings
   - Hidden: Tidak replicated ke client

3. **ClientConfig.lua** (StarterPlayer)
   - Accessible: Client only
   - Isi: Keybinds, UI theme, visual preferences
   - Local: Player-specific settings

**Resolution order:**

```
Engine config (global)
    ↓
SharedConfig (modul public)
    ↓
ServerConfig / ClientConfig (layered overrides)
    ↓
Final merged config
```

---

## 2. EXAMPLE: INVENTORY MODULE (MINIMAL PATTERN)

Copy structure dari `MinimalModule`, rename ke `InventoryModule`.

### **A. SharedConfig.lua** (Kontrak)

```lua
--[[
OVHL ENGINE V1.0.0
@Component: InventoryModule (Shared Config)
@Path: ReplicatedStorage.OVHL.Shared.Modules.Inventory.SharedConfig
@Purpose: Kontrak data, schema validasi, permission rules
@Stability: STABLE
--]]

return {
    ModuleName = "InventoryModule",
    Version = "1.0.0",
    Author = "Game Team",
    Enabled = true,

    -- UI configuration
    UI = {
        DefaultMode = "FUSION",
        Screens = {
            MainUI = { Mode = "FUSION", FallbackMode = "NATIVE" },
            EquipUI = { Mode = "FUSION", FallbackMode = "NATIVE" }
        },
        Topbar = {
            Enabled = true,
            Icon = "rbxassetid://1234567890",
            Text = "Inventory"
        }
    },

    -- Security & Validation
    Security = {
        -- Input validation schemas
        ValidationSchemas = {
            EquipRequest = {
                type = "table",
                fields = {
                    itemId = { type = "string", min = 1, max = 50 },
                    slotId = { type = "number", min = 1, max = 10 }
                }
            },
            DropRequest = {
                type = "table",
                fields = {
                    itemId = { type = "string", min = 1 },
                    quantity = { type = "number", min = 1, max = 999 }
                }
            }
        },

        -- Rate limiting per action
        RateLimits = {
            Equip = { max = 5, window = 1 },      -- 5x per detik
            Drop = { max = 10, window = 60 },      -- 10x per menit
            Move = { max = 20, window = 60 }       -- 20x per menit
        }
    },

    -- HD Admin style permissions
    Permissions = {
        Equip = { Rank = "NonAdmin", Description = "Equip items" },
        Drop = { Rank = "NonAdmin", Description = "Drop items" },
        Admin_ClearInventory = { Rank = "Admin", Description = "Admin: clear inventory" }
    }
}

--[[
@End: SharedConfig.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: Game Team
--]]
```

### **B. ServerConfig.lua** (Rahasia)\*\*

```lua
--[[
OVHL ENGINE V1.0.0
@Component: InventoryModule (Server Config)
@Path: ServerScriptService.OVHL.Modules.Inventory.ServerConfig
@Purpose: Secret config - API keys, database credentials
@Stability: STABLE
--]]

return {
    -- Server-only settings (jangan exposed ke client)
    DebugMode = false,

    -- Database
    DataStore = {
        Name = "PlayerInventory_v1",
        Scope = "global"
    },

    -- External APIs
    ItemDatabase = {
        Endpoint = "https://api.example.com/items",
        APIKey = "secret_key_xyz123"
    },

    -- Performance
    MaxInventorySlots = 50,
    SaveInterval = 300  -- Detik
}

--[[
@End: ServerConfig.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: Game Team
--]]
```

### **C. ClientConfig.lua** (Preferensi)\*\*

```lua
--[[
OVHL ENGINE V1.0.0
@Component: InventoryModule (Client Config)
@Path: StarterPlayer.StarterPlayerScripts.OVHL.Modules.Inventory.ClientConfig
@Purpose: Client preferences - keybinds, UI theme
@Stability: STABLE
--]]

return {
    -- UI Theme
    Theme = "Dark",
    AnimationDuration = 0.3,

    -- Input keybinds
    Input = {
        Keybinds = {
            ToggleInventory = Enum.KeyCode.I,
            DropItem = Enum.KeyCode.X,
            SearchInventory = Enum.KeyCode.F
        }
    },

    -- Visual
    InventoryGridColumns = 5,
    ShowItemTooltips = true,
    UseCustomCursor = false
}

--[[
@End: ClientConfig.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: Game Team
--]]
```

### **D. InventoryService.lua** (Server Logic)\*\*

```lua
--[[
OVHL ENGINE V1.0.0
@Component: InventoryService (Knit Service)
@Path: ServerScriptService.OVHL.Modules.Inventory.InventoryService
@Purpose: Server-side inventory logic + 3-pilar security
@Stability: STABLE
--]]

local Knit = require(game.ReplicatedStorage.Packages.Knit)

local InventoryService = Knit.CreateService {
    Name = "InventoryService",
    Client = {}
}

-- FASE 1: KnitInit (Resolve dependencies)
function InventoryService:KnitInit()
    self.OVHL = require(game.ReplicatedStorage.OVHL.Core.OVHL)
    self.Logger = self.OVHL:GetSystem("SmartLogger")
    self.Config = self.OVHL:GetConfig("InventoryModule", nil, "Server")

    -- Get systems
    self.InputValidator = self.OVHL:GetSystem("InputValidator")
    self.RateLimiter = self.OVHL:GetSystem("RateLimiter")
    self.PermissionCore = self.OVHL:GetSystem("PermissionCore")
    self.DataManager = self.OVHL:GetSystem("DataManager")

    self.Logger:Info("SERVICE", "InventoryService initialized", {
        module = self.Config.ModuleName
    })
end

-- FASE 2: KnitStart (Start logic)
function InventoryService:KnitStart()
    self.Logger:Info("SERVICE", "InventoryService started")
end

-- ============= CLIENT METHOD =============

-- Entry point dari client
function InventoryService.Client:Equip(player, data)
    return self.Server:ProcessEquip(player, data)
end

-- ============= SECURITY PIPELINE =============

-- [1] Validasi input
-- [2] Rate limit check
-- [3] Permission check
-- [4] Execute logic

function InventoryService:ProcessEquip(player, data)
    local startTime = os.clock()

    -- 1. INPUT VALIDATION
    local valid, validationErr = self.InputValidator:Validate("EquipRequest", data)
    if not valid then
        self.Logger:Warn("SECURITY", "Validation failed", {
            player = player.Name,
            error = validationErr
        })
        return false, validationErr
    end

    -- 2. RATE LIMIT
    if not self.RateLimiter:Check(player, "Equip") then
        self.Logger:Warn("SECURITY", "Rate limit exceeded", {
            player = player.Name,
            action = "Equip"
        })
        return false, "Too many requests"
    end

    -- 3. PERMISSION
    local permNode = "InventoryModule.Equip"
    if not self.PermissionCore:Check(player, permNode) then
        self.Logger:Warn("SECURITY", "Permission denied", {
            player = player.Name,
            permission = permNode
        })
        return false, "No permission"
    end

    -- 4. EXECUTE BUSINESS LOGIC
    local success, result = self:_executeEquip(player, data.itemId, data.slotId)

    self.Logger:Performance("TIMING", "Equip processed", {
        duration = os.clock() - startTime,
        player = player.Name,
        success = success
    })

    return success, result
end

function InventoryService:_executeEquip(player, itemId, slotId)
    -- Actual logic here
    self.Logger:Debug("BUSINESS", "Equip item", {
        player = player.Name,
        itemId = itemId,
        slotId = slotId
    })

    -- Contoh: update player data via DataManager
    local playerData = self.DataManager:GetCachedData(player)
    if not playerData then
        return false, "Player data not found"
    end

    -- Logic untuk equip item
    playerData.equippedItems = playerData.equippedItems or {}
    playerData.equippedItems[slotId] = itemId

    return true, "Item equipped"
end

return InventoryService

--[[
@End: InventoryService.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: Game Team
--]]
```

### **E. InventoryController.lua** (Client Logic)\*\*

```lua
--[[
OVHL ENGINE V1.0.0
@Component: InventoryController (Knit Controller)
@Path: StarterPlayer.StarterPlayerScripts.OVHL.Modules.Inventory.InventoryController
@Purpose: Client-side inventory UI + networking
@Stability: STABLE
--]]

local Knit = require(game.ReplicatedStorage.Packages.Knit)

local InventoryController = Knit.CreateController { Name = "InventoryController" }

-- FASE 1: KnitInit (Get references)
function InventoryController:KnitInit()
    self.OVHL = require(game.ReplicatedStorage.OVHL.Core.OVHL)
    self.Logger = self.OVHL:GetSystem("SmartLogger")
    self.Config = self.OVHL:GetClientConfig("InventoryModule")

    self.UIEngine = self.OVHL:GetSystem("UIEngine")
    self.UIManager = self.OVHL:GetSystem("UIManager")
    self.AssetLoader = self.OVHL:GetSystem("AssetLoader")

    self.Service = Knit.GetService("InventoryService")

    self.Logger:Info("CONTROLLER", "InventoryController initialized")
end

-- FASE 2: KnitStart (Setup UI + input)
function InventoryController:KnitStart()
    self:SetupUI()
    self:SetupInput()
    self:SetupTopbar()

    self.Logger:Info("CONTROLLER", "InventoryController started")
end

function InventoryController:SetupUI()
    if not self.UIEngine then return end

    local success, mainScreen = pcall(function()
        return self.UIEngine:CreateScreen("MainUI", self.Config)
    end)

    if success and mainScreen then
        self._mainScreen = mainScreen
        if self.UIManager then
            self.UIManager:RegisterScreen("MainUI", mainScreen)
            self:_setupUIComponents(mainScreen)
        end
        self.Logger:Info("UI", "Inventory UI created")
    else
        self.Logger:Error("UI", "Failed to create UI", { error = tostring(mainScreen) })
    end
end

function InventoryController:_setupUIComponents(screen)
    if not screen or not self.UIManager then return end

    -- Find equip button
    local equipBtn = self.UIManager:FindComponent("MainUI", "EquipButton")
    if equipBtn then
        self.UIManager:BindEvent(equipBtn, "Activated", function()
            self:RequestEquipItem(123, 1)  -- Example item
        end)
    end
end

function InventoryController:SetupInput()
    if not self.AssetLoader or not self.Config or not self.Config.Input then return end

    local kb = self.Config.Input.Keybinds
    if kb then
        -- Toggle inventory dengan tombol I
        if kb.ToggleInventory then
            self.AssetLoader:RegisterKeybind(kb.ToggleInventory, function()
                self:ToggleInventory()
            end, { triggerOnPress = true })
        end
    end
end

function InventoryController:SetupTopbar()
    if self.UIManager then
        self.UIManager:SetupTopbar("InventoryModule", self.Config)
    end
end

function InventoryController:ToggleInventory()
    if self.UIManager then
        self.UIManager:ToggleScreen("MainUI")
    end
end

function InventoryController:RequestEquipItem(itemId, slotId)
    if not self.Service then return end

    -- Kirim request ke server (dengan data TABLE untuk validasi)
    self.Service:Equip({
        itemId = itemId,
        slotId = slotId
    }):andThen(function(success, result)
        if success then
            self.Logger:Info("ACTION", "Item equipped", { itemId = itemId })
        else
            self.Logger:Warn("ACTION", "Equip failed", { error = result })
        end
    end):catch(function(err)
        self.Logger:Error("ACTION", "Network error", { error = tostring(err) })
    end)
end

return InventoryController

--[[
@End: InventoryController.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: Game Team
--]]
```

---

## 3. POLA MODUL KOMPLEKS (SCALABLE PATTERN)

Jika modul lu **BESAR** (300+ lines per file), gunakan **Facade Pattern**:

```
Modules/Shop/
├── Shared/
│   └── SharedConfig.lua
├── Server/
│   ├── ShopService.lua          # Fasad (thin layer)
│   ├── ServerConfig.lua
│   └── Internal/
│       ├── PriceCalculator.lua
│       ├── PurchaseHandler.lua
│       └── InventoryUpdater.lua
└── Client/
    ├── ShopController.lua       # Fasad (thin layer)
    ├── ClientConfig.lua
    └── Views/
        ├── ShopDisplayView.lua
        ├── CartView.lua
        └── CheckoutView.lua
```

**Pattern:**

- Service/Controller = Fasad (keamanan + delegasi)
- Internal/ = Business logic murni
- Views/ = UI logic murni

**Benefit:**

- File per-file tetap < 300 lines (maintainable)
- Logic terpisah dari security (clean)
- UI terpisah dari networking (testable)

---

## 4. SECURITY CHECKLIST (MANDATORY)

Sebelum launch modul, ensure:

- ✅ **SharedConfig.lua** punya ValidationSchemas untuk SEMUA input
- ✅ **SharedConfig.lua** punya RateLimits untuk SEMUA action
- ✅ **SharedConfig.lua** punya Permissions untuk SEMUA action
- ✅ **Service.lua** validate input sebelum execute
- ✅ **Service.lua** check rate limit sebelum execute
- ✅ **Service.lua** check permission sebelum execute
- ✅ **ServerConfig.lua** ada (jangan expose secrets)
- ✅ **Test di studio:** Click tombol → validate pipeline → baru execute

---

## 5. FAQ (COMMON PATTERNS)

### **Q: Gimana kalau modul butuh **shared logic** (bukan config)?**

**A:** Buat folder `Shared/Internal/`:

```
Modules/Shop/Shared/Internal/
├── PriceConstants.lua          # Shared constants
└── ItemDatabase.lua            # Shared item data
```

Load dari client + server:

```lua
local ItemDB = require(script.Parent.Parent.Shared.Internal.ItemDatabase)
```

### **Q: Gimana kalau modul perlu **DataManager** access?**

**A:** Di service:

```lua
function ShopService:KnitInit()
    self.OVHL = require(...)
    self.DataManager = self.OVHL:GetSystem("DataManager")  -- ✅ OK
end

function ShopService:ProcessPurchase(player, itemId)
    local playerData = self.DataManager:GetCachedData(player)
    -- Gunakan playerData
end
```

### **Q: Gimana kalau **rate limit berbeda per rank**?**

**A:** Handle di service:

```lua
function ShopService:ProcessPurchase(player, itemId)
    local action = "Purchase"

    -- Custom rate limit check per rank
    local rank = self.PermissionCore:GetRank(player)
    if rank == "VIP" then
        action = "Purchase_VIP"  -- VIP rate limit lebih tinggi
    end

    if not self.RateLimiter:Check(player, action) then
        return false, "Rate limit exceeded"
    end

    -- Continue
end
```

### **Q: Gimana kalau **UI need realtime updates** (player buy item, inventory update)?**

**A:** Gunakan `NotificationService`:

```lua
function ShopService:ProcessPurchase(player, itemId)
    -- ... security checks ...

    -- Execute purchase
    local success = self:_executePurchase(player, itemId)

    if success then
        -- Notify client
        local NotifService = self.OVHL:GetSystem("NotificationService")
        NotifService:SendToPlayer(player, "Purchase successful!", "Success", 3)
    end

    return success
end
```

---

## 6. TESTING MODUL

Buat test file:

```lua
-- tests/Unit/ShopService.spec.lua
return function()
    local Shop = require(game.ServerScriptService.OVHL.Modules.Shop.ShopService)

    describe("ShopService", function()
        it("should validate input", function()
            -- Test malformed input
        end)

        it("should check rate limit", function()
            -- Test spam requests
        end)

        it("should execute purchase", function()
            -- Test successful purchase
        end)
    end)
end
```

---

## 7. DEPLOYMENT CHECKLIST

Sebelum push modul ke production:

- [ ] Semua 3 config files ada + lengkap
- [ ] Service punya semua security checks (3 pilar)
- [ ] Controller punya UI + input setup
- [ ] Topbar button works
- [ ] Test di studio: full workflow (UI → action → server → response)
- [ ] Data persists (rejoin game, data masih ada)
- [ ] No console errors
- [ ] Code headers/footers V1.0.0
- [ ] No placeholder / TODOs
- [ ] Related docs updated (atau PR untuk update docs)

---

> END OF ./docs/200_USER_GUIDES/201_CONTRIBUTING_MODULE.md
