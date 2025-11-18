> START OF ./docs/200_USER_GUIDES/202_CONTRIBUTING_SYSTEM.md
>
> **OVHL ENGINE V3.1.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** ENGINE ENGINEERS, CORE DEVELOPERS
> **PURPOSE:** Panduan teknis untuk menambahkan **Sistem Engine** baru (misal: DataManager, SoundManager) ke dalam OVHL Core.

---

# 🛠️ 202_CONTRIBUTING_SYSTEM.MD

> **REFERENSI:** Dokumen ini menggabungkan dan menggantikan `01a_ARCHITECTURE_SYSTEMS.md` dan `03_CONTRIBUTING.md`.

---

## 1. ⚠️ ATURAN EMAS (FILOSOFI)

Sebelum membuat file, pahami perbedaan fundamental ini:

1.  **Knit Service (`Modules/`) = Logika Gameplay.**

    - Tujuannya adalah _fitur_ (Inventory, Shop, Quest).
    - Dibuat oleh _Gameplay Programmers_.
    - Menggunakan `Knit.CreateService`.
    - Dipindai oleh `Kernel.lua`.

2.  **OVHL System (`Systems/`) = Utilitas/Teknologi.**
    - Tujuannya adalah _kemampuan_ (Logger, Validator, DataManager).
    - Dibuat oleh _Engine Engineers_.
    - Menggunakan pola Class `ModuleScript.new()`.
    - Dipindai oleh `Bootstrap.lua`.

**JANGAN TERTUKAR!**

---

## 2. LANGKAH IMPLEMENTASI (Contoh: `DataManager`)

Sistem OVHL bersifat **Auto-Discovery**. Cukup buat file di folder yang tepat dan daftarkan dependensinya.

### Langkah 1: Tentukan Kategori

Pilih folder di `src/ReplicatedStorage/OVHL/Systems/`:

- `Foundation/`: Sangat dasar (Logger, Config).
- `Security/`: Keamanan (Validator, RateLimiter).
- `UI/`: Teknologi UI (UIEngine).
- `Networking/`: Transport layer (Router).
- `Adapters/`: Jembatan ke API pihak ketiga.
- `Advanced/`: Fitur kompleks lain (Target: `DataManager`, `StateManager`).

### Langkah 2: Template System

Buat `ModuleScript` baru (misal: `DataManager.lua`) menggunakan template V3.1.0.

```lua
--[[
OVHL ENGINE V3.1.0
@Component: DataManager (Core System)
@Path: ReplicatedStorage.OVHL.Systems.Advanced.DataManager
@Purpose: Menyediakan API DataStore terpusat untuk semua Modul Gameplay.
--]]

local DataManager = {}
DataManager.__index = DataManager

function DataManager.new()
    local self = setmetatable({}, DataManager)
    self._logger = nil
    return self
end

-- [WAJIB] Method ini akan dipanggil otomatis oleh Bootstrap
function DataManager:Initialize(logger)
    self._logger = logger
    self._logger:Info("DATAMANAGER", "Data Manager Ready")
end

function DataManager:LoadData(player)
    -- Logika DataStore Anda di sini
    self._logger:Debug("DATAMANAGER", "Loading data...", {player = player.Name})
    print("Data loaded!")
end

return DataManager

--[[
@End: DataManager.lua
@Version: 3.1.0
@See: docs/200_USER_GUIDES/202_CONTRIBUTING_SYSTEM.md
--]]
```

### Langkah 3: Daftarkan Dependensi (KRITIS!)

Sistem baru tidak akan tahu urutan load-nya kecuali diberi tahu.
Buka `src/ReplicatedStorage/OVHL/Core/Bootstrap.lua` dan edit tabel `systemDependencies`:

```lua
-- Di dalam Bootstrap.lua
local systemDependencies = {
    ConfigLoader = {}, -- [CONTOH] Tidak ada dependensi
    SmartLogger = {"ConfigLoader"}, -- [CONTOH] Butuh ConfigLoader
    InputValidator = {"SmartLogger"}, -- [CONTOH] Butuh SmartLogger

    -- [BARU] Tambahkan sistem barumu di sini:
    DataManager = {"SmartLogger", "ConfigLoader"}
    -- Artinya: DataManager baru akan start SETELAH Logger & Config siap.
}
```

### Langkah 4: Selesai!

Bootstrap sekarang akan otomatis:

1.  Scan file `DataManager.lua`.
2.  Cek dependency-nya (`SmartLogger`, `ConfigLoader`).
3.  Load dan Initialize `DataManager` pada urutan yang benar.
4.  Mendaftarkannya sehingga bisa diakses via `OVHL:GetSystem("DataManager")`.

---

## 3. INTEGRASI DENGAN KNIT SERVICE

Cara **Modul Gameplay (Knit)** menggunakan **Sistem Engine (OVHL)** yang baru Anda buat.

```lua
-- Di dalam InventoryService.lua
function InventoryService:KnitInit()
    -- 1. Dapatkan API Gateway
    self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)

    -- 2. Panggil Sistem (Bukan Service)
    self.DataManager = self.OVHL:GetSystem("DataManager")
end

function InventoryService:LoadInventory(player)
    -- 3. Gunakan Sistem
    local data = self.DataManager:LoadData(player)
    -- ...
end
```

---

> END OF ./docs/200_USER_GUIDES/202_CONTRIBUTING_SYSTEM.md
