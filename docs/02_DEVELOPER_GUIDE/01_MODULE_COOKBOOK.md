# 🍳 OVHL MODULE COOKBOOK

> **STATUS:** ACTIVE GUIDE
> **TARGET:** Gameplay Programmers
> **TUJUAN:** Template standar untuk membuat fitur game (Inventory, Shop, Data, dll).

---

## 1. PERSIAPAN

Copy folder `MinimalModule` dan rename sesuai fitur baru lu (misal: `Inventory`).
Pastikan strukturnya tetap:

```text
Modules/Inventory/
├── Server/InventoryService.lua      (Server Logic)
├── Client/InventoryController.lua   (Client Logic & UI)
└── Shared/SharedConfig.lua          (Config & Schema)
```

---

## 2. CONTOH LENGKAP: INVENTORY MODULE

### A. Shared Config (`Shared/SharedConfig.lua`)

Definisikan aturan data dan permission di sini.

```lua
return {
    Security = {
        -- SCHEMA: Bentuk data yang valid dari Client
        ValidationSchemas = {
            EquipRequest = {
                type = "table",
                fields = {
                    itemId = { type = "string", min = 1 },
                    slotId = { type = "number", min = 1, max = 10 }
                }
            }
        },
        -- RATE LIMIT: Cegah spam click
        RateLimits = {
            Equip = { max = 2, window = 1 } -- Max 2x per detik
        }
    },

    -- PERMISSION: Siapa yang boleh akses?
    Permissions = {
        EquipItem = { Rank = "NonAdmin" } -- Semua player (0)
    }
}
```

### B. Server Service (`Server/InventoryService.lua`)

Logika utama dengan tembok keamanan berlapis.

```lua
local Knit = require(game.ReplicatedStorage.Packages.Knit)
local InventoryService = Knit.CreateService { Name = "InventoryService", Client = {} }

function InventoryService:KnitInit()
    self.OVHL = require(game.ReplicatedStorage.OVHL.Core.OVHL)
    self.InputValidator = self.OVHL:GetSystem("InputValidator")
    self.RateLimiter = self.OVHL:GetSystem("RateLimiter")
    self.Permission = self.OVHL:GetSystem("PermissionCore")
    self.Logger = self.OVHL:GetSystem("SmartLogger")
end

-- Client Method (Jembatan)
function InventoryService.Client:Equip(player, data)
    return self.Server:ProcessEquip(player, data)
end

-- Server Method (Secure Logic)
function InventoryService:ProcessEquip(player, data)
    -- 1. VALIDASI INPUT (Schema Check)
    local valid, err = self.InputValidator:Validate("EquipRequest", data)
    if not valid then
        self.Logger:Warn("SECURITY", "Bad Input", {player=player.Name, err=err})
        return false
    end

    -- 2. CEK RATE LIMIT (Spam Check)
    if not self.RateLimiter:Check(player, "Equip") then return false end

    -- 3. CEK PERMISSION (Rank Check)
    if not self.Permission:Check(player, "InventoryModule.EquipItem") then return false end

    -- 4. GAMEPLAY LOGIC
    self.Logger:Info("GAME", "Item Equipped", {player=player.Name, item=data.itemId})
    return true
end

return InventoryService
```

### C. Client Controller (`Client/InventoryController.lua`)

Logika UI dan Input.

```lua
local Knit = require(game.ReplicatedStorage.Packages.Knit)
local InventoryController = Knit.CreateController { Name = "InventoryController" }

function InventoryController:KnitStart()
    self.Service = Knit.GetService("InventoryService")
    self.UIEngine = require(game.ReplicatedStorage.OVHL.Core.OVHL):GetSystem("UIEngine")

    -- Buka UI saat start
    self:SetupUI()
end

function InventoryController:SetupUI()
    -- Create UI via Fusion Engine
    self.UIEngine:CreateScreen("InventoryUI", self.Config)
end

function InventoryController:RequestEquip(id)
    -- Kirim data sebagai TABLE (Sesuai Schema)
    self.Service:Equip({
        itemId = id,
        slotId = 1
    })
end

return InventoryController
```
