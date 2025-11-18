> START OF ./docs/200_USER_GUIDES/201_CONTRIBUTING_MODULE.md
>
> **OVHL ENGINE V3.1.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** GAMEPLAY PROGRAMMERS, USERS
> **PURPOSE:** "Cookbook" dan "Golden Standard" untuk membuat **Modul Gameplay** baru (misal: Shop, Inventory) menggunakan Knit.

---

# 🍳 201_CONTRIBUTING_MODULE.MD

> **REFERENSI:** Dokumen ini di-bootstrap dari `01_MODULE_COOKBOOK.md` dan `06_MODULE_CREATION.md`.

---

## 1. PERSIAPAN

Copy folder `MinimalModule` dan rename sesuai fitur baru lu (misal: `Inventory`).
Struktur ini (Pola Minimal) sudah benar dan mencerminkan SSoT 3-Config:

```text
Modules/Inventory/
├── Server/
│   ├── InventoryService.lua      (Server Logic)
│   └── ServerConfig.lua          (Config Rahasia)
├── Client/
│   ├── InventoryController.lua   (Client Logic & UI)
│   └── ClientConfig.lua          (Config Preferensi)
└── Shared/
    └── SharedConfig.lua          (Config Kontrak)
```

---

## 2. CONTOH LENGKAP: INVENTORY MODULE (POLA MINIMAL)

### A. Shared Config (`Shared/SharedConfig.lua`)

Definisikan aturan data dan permission di sini.

```lua
--[[
OVHL ENGINE V3.1.0
@Component: Inventory (Shared Config)
@Path: ReplicatedStorage.OVHL.Shared.Modules.Inventory.SharedConfig
@Purpose: Kontrak data, schema validasi, dan izin dasar.
--]]

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

--[[
@End: SharedConfig.lua
@Version: 3.1.0
@See: docs/200_USER_GUIDES/201_CONTRIBUTING_MODULE.md
--]]
```

### B. Server Service (`Server/InventoryService.lua`)

Logika utama dengan tembok keamanan berlapis.

```lua
--[[
OVHL ENGINE V3.1.0
@Component: InventoryService (Minimal)
@Path: ServerScriptService.OVHL.Modules.Inventory.InventoryService.lua
@Purpose: Menerima request dari Client dan menerapkan 3 pilar keamanan.
--]]

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

--[[
@End: InventoryService.lua
@Version: 3.1.0
@See: docs/200_USER_GUIDES/201_CONTRIBUTING_MODULE.md
--]]
```

### C. Client Controller (`Client/InventoryController.lua`)

Logika UI dan Input.

```lua
--[[
OVHL ENGINE V3.1.0
@Component: InventoryController (Minimal)
@Path: StarterPlayer.StarterPlayerScripts.OVHL.Modules.Inventory.InventoryController.lua
@Purpose: Mengelola UI dan mengirim request ke Server Service.
--]]

local Knit = require(game.ReplicatedStorage.Packages.Knit)
local InventoryController = Knit.CreateController { Name = "InventoryController" }

function InventoryController:KnitInit()
    self.OVHL = require(game.ReplicatedStorage.OVHL.Core.OVHL)
    self.Logger = self.OVHL:GetSystem("SmartLogger")
    self.UIEngine = self.OVHL:GetSystem("UIEngine")
    self.Config = self.OVHL:GetClientConfig("Inventory")
    self.Service = Knit.GetService("InventoryService")
end

function InventoryController:KnitStart()
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

--[[
@End: InventoryController.lua
@Version: 3.1.0
@See: docs/200_USER_GUIDES/201_CONTRIBUTING_MODULE.md
--]]
```

---

## 3. POLA MODUL KOMPLEKS (SCALABLE PATTERN)

`MinimalModule` bagus untuk fitur sederhana. Tapi bagaimana jika `InventoryService` Anda perlu mengurus _Equip_, _Trade_, _Drop_, dan _Stacking_? File Anda akan melebihi "300 Line Limit" (Hukum #9 di `101_GENESIS_ARCHITECTURE.md`).

Untuk ini, kita gunakan **Pola Fasad (Facade Pattern)**.

### A. Struktur Folder Modul Kompleks

Struktur ini **mempertahankan** pola 3-Config SSoT V3.1.0.

```text
Modules/Inventory/
├── Server/
│   ├── InventoryService.lua      # Fasad Keamanan (Knit Service)
│   ├── ServerConfig.lua          # [WAJIB] Config Rahasia (API Keys, dll)
│   └── Internal/                 # Folder Logika Bisnis
│       ├── EquipHandler.lua      # Modul logic equip
│       ├── TradeManager.lua      # Modul logic trade
│       └── ItemDataManager.lua   # Modul logic stacking, moving
│
├── Client/
│   ├── InventoryController.lua   # Fasad UI (Knit Controller)
│   ├── ClientConfig.lua          # [WAJIB] Config Preferensi (Keybinds, dll)
│   └── Views/                    # Folder Logika UI
│       ├── BackpackView.lua      # Modul logic untuk render backpack
│       └── EquipmentView.lua     # Modul logic untuk UI equip
│
└── Shared/
    └── SharedConfig.lua          # [WAJIB] Config Kontrak (Schema, Izin)
```

### B. Server Service (Fasad)

`InventoryService.lua` sekarang menjadi sangat tipis. Tugasnya hanya **Validasi** dan **Delegasi**.

```lua
--[[
OVHL ENGINE V3.1.0
@Component: InventoryService (Complex Facade)
@Path: ServerScriptService.OVHL.Modules.Inventory.InventoryService.lua
@Purpose: Fasad Keamanan. Memvalidasi input lalu mendelegasikannya ke Handler Internal.
--]]

local Knit = require(game.ReplicatedStorage.Packages.Knit)
local InventoryService = Knit.CreateService { Name = "InventoryService", Client = {} }

function InventoryService:KnitInit()
    self.OVHL = require(game.ReplicatedStorage.OVHL.Core.OVHL)
    self.Logger = self.OVHL:GetSystem("SmartLogger")
    self.Config = self.OVHL:GetConfig("Inventory")

    -- Sistem Keamanan
    self.InputValidator = self.OVHL:GetSystem("InputValidator")
    self.RateLimiter = self.OVHL:GetSystem("RateLimiter")
    self.Permission = self.OVHL:GetSystem("PermissionCore")

    -- Load modul logika internal kita
    self.EquipHandler = require(script.Parent.Internal.EquipHandler)
    self.EquipHandler:Init(self.Logger, self.Config) -- Beri dependensi
end

-- Client Method (Fasad)
function InventoryService.Client:Equip(player, data)
    -- 1. VALIDASI INPUT (Schema: "EquipRequest")
    local valid, err = self.InputValidator:Validate("EquipRequest", data)
    if not valid then return false, err end

    -- 2. CEK RATE LIMIT (Action: "Equip")
    if not self.RateLimiter:Check(player, "Equip") then return false, "Spam" end

    -- 3. CEK PERMISSION (Node: "Inventory.EquipItem")
    if not self.Permission:Check(player, "InventoryModule.EquipItem") then return false, "No Access" end

    -- 4. DELEGASI LOGIKA
    return self.EquipHandler:Process(player, data.itemId, data.slotId)
end

return InventoryService

--[[
@End: InventoryService.lua
@Version: 3.1.0
@See: docs/200_USER_GUIDES/201_CONTRIBUTING_MODULE.md
--]]
```

### C. Server Logic (Internal)

File `Internal/EquipHandler.lua` berisi logika "kotor"-nya.

```lua
--[[
OVHL ENGINE V3.1.0
@Component: EquipHandler (Internal Logic)
@Path: ServerScriptService.OVHL.Modules.Inventory.Internal.EquipHandler.lua
@Purpose: Berisi logika bisnis murni untuk equip. Dipanggil oleh Fasad.
--]]

local EquipHandler = {}

function EquipHandler:Init(logger, config)
    self.Logger = logger
    self.Config = config -- Menerima config gabungan

    -- Kita bisa akses config rahasia server di sini
    self.SomeSecretValue = self.Config.API.APIKey -- (Contoh dari ServerConfig.lua)
end

function EquipHandler:Process(player, itemId, slotId)
    -- Di sinilah 300 baris logika equip Anda berada.
    self.Logger:Info("EQUIP", "Equip logic processed", {player = player.Name, item = itemId})
    -- ...
    return true
end

return EquipHandler

--[[
@End: EquipHandler.lua
@Version: 3.1.0
@See: docs/200_USER_GUIDES/201_CONTRIBUTING_MODULE.md
--]]
```

### D. Client Controller (Fasad)

`InventoryController.lua` juga hanya bertugas sebagai jembatan dan _state manager_.

```lua
--[[
OVHL ENGINE V3.1.0
@Component: InventoryController (Complex Facade)
@Path: StarterPlayer.StarterPlayerScripts.OVHL.Modules.Inventory.InventoryController.lua
@Purpose: Fasad UI. Mendelegasikan rendering ke Views.
--]]

local Knit = require(game.ReplicatedStorage.Packages.Knit)
local InventoryController = Knit.CreateController { Name = "InventoryController" }

function InventoryController:KnitInit()
    self.OVHL = require(game.ReplicatedStorage.OVHL.Core.OVHL)
    self.Logger = self.OVHL:GetSystem("SmartLogger")
    self.UIEngine = self.OVHL:GetSystem("UIEngine")
    self.Config = self.OVHL:GetClientConfig("Inventory")
    self.Service = Knit.GetService("InventoryService")
end

function InventoryController:KnitStart()
    -- Load modul logika view kita
    self.BackpackView = require(script.Parent.Views.BackpackView)
    self.BackpackView:Init(self.UIEngine, self.Service, self.Config)

    self:SetupUI()
end

function InventoryController:SetupUI()
    -- Mount UI utama
    local mainUI = self.UIEngine:CreateScreen("InventoryUI", self.Config)

    -- Delegasi render/binding ke View
    self.BackpackView:Mount(mainUI)
end

return InventoryController

--[[
@End: InventoryController.lua
@Version: 3.1.0
@See: docs/200_USER_GUIDES/201_CONTRIBUTING_MODULE.md
--]]
```

---

## 4. ❓ FAQ (PENTING!)

> **Sumber:** Diselamatkan dari `06_MODULE_CREATION.md` (Legacy)

**Q: Gue butuh sistem DataStore canggih, tapi di API Reference gak ada.**
**A:** Jangan paksakan logic DataStore di dalam Module (Service) lu. Itu melanggar prinsip _Separation of Concerns_.

1.  Baca `202_CONTRIBUTING_SYSTEM.md` untuk memahami bedanya **System** vs **Service**.
2.  Buat **System** baru di `src/ReplicatedStorage/OVHL/Systems/Advanced/DataManager.lua`. (Ini adalah item di Roadmap Phase 3 kita).
3.  Baru panggil sistem itu di `InventoryService` lu via `self.OVHL:GetSystem("DataManager")`.

**Q: UI gue kompleks banget, `UIEngine:CreateScreen` doang gak cukup.**
**A:** Gunakan **Pola Modul Kompleks (Section 3)** di atas. Pecah UI lu jadi `Views/` (misal: `BackpackView.lua`, `EquipmentView.lua`). `UIEngine` me-mount _container_ utamanya, lalu `Views` Anda yang mengurus binding dan rendering di dalamnya.

---

> END OF ./docs/200_USER_GUIDES/201_CONTRIBUTING_MODULE.md
