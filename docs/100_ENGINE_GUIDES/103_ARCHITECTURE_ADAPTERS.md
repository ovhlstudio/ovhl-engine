> START OF ./docs/100_ENGINE_GUIDES/103_ARCHITECTURE_ADAPTERS.md
>
> **OVHL ENGINE V3.1.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** ENGINE ENGINEERS
> **PURPOSE:** Mendefinisikan arsitektur "Pola Adapter" untuk integrasi pihak ketiga (HD Admin, TopbarPlus) secara Config-Driven.

---

# 🔌 103_ARCHITECTURE_ADAPTERS.MD

---

## 1. FILOSOFI & PRINSIP

Arsitektur V3.1.0 kita (SSoT) mewajibkan **Hukum #4: Config-Driven** dan **Hukum #2: Separation of Concerns**.

Implementasi kita saat ini di `snapshot-20251118_071230.md` **melanggar** prinsip ini:

1.  `UIManager.lua` secara _hardcoded_ bergantung pada TopbarPlus.
2.  `PermissionCore.lua` secara _hardcoded_ menggunakan _fallback_ internal, bukan HD Admin.

Dokumen ini mendefinisikan **Pola Adapter** sebagai solusi standar V3.1.0 untuk memperbaiki ini.

---

## 2. ARSITEKTUR POLA ADAPTER

Arsitektur ini terdiri dari 4 komponen:

1.  **Interface (Kontrak):** Sebuah tabel Lua sederhana yang mendefinisikan fungsi-fungsi _wajib_ yang harus dimiliki oleh semua adapter dalam kategori yang sama.
2.  **Adapter (Implementasi):** _ModuleScript_ yang mengimplementasikan _Interface_ dan menjembatani (bridge) ke API pihak ketiga (misal: API TopbarPlus atau HD Admin).
3.  **Konfigurasi (Selektor):** Sebuah entri di `EngineConfig.lua` yang memberi tahu engine _adapter mana_ yang harus dimuat.
4.  **Sistem Inti (Loader):** Sistem OVHL (misal: `UIManager` atau `PermissionCore`) yang membaca _Konfigurasi_ untuk memuat _Adapter_ yang benar, lalu memanggil _Interface_-nya.

---

## 3. CONTOH KASUS 1: PERMISSION SYSTEM (HD Admin)

Saat ini `PermissionCore.lua` adalah _monolit_. Kita akan memecahnya.

### Langkah 1: Buat Folder Adapter

Buat folder baru: `src/ReplicatedStorage/OVHL/Systems/Adapters/Permission/` (Sesuai SSoT `101_GENESIS_ARCHITECTURE.md`).

### Langkah 2: Definisikan Interface

(Ini hanya konseptual). _Interface_ `IPermissionAdapter` harus memiliki:

- `Adapter:GetRank(player)` -> `number`
- `Adapter:CheckPermission(player, node)` -> `boolean`

### Langkah 3: Buat Adapters

**Adapter 1 (Fallback Internal):**
File: `Systems/Adapters/Permission/InternalAdapter.lua`

```lua
--[[
OVHL ENGINE V3.1.0
@Component: InternalAdapter (Permission)
@Path: ReplicatedStorage.OVHL.Systems.Adapters.Permission.InternalAdapter
@Purpose: Implementasi fallback PermissionCore. Kode ini diambil dari PermissionCore.lua (V3.0.0).
--]]

-- Ini adalah kode LAMA kita dari PermissionCore.lua
local InternalAdapter = {}
InternalAdapter.__index = InternalAdapter

local RANKS = { Owner = 5, NonAdmin = 0 } -- Fallback ranks

function InternalAdapter.new()
    return setmetatable({}, InternalAdapter)
end

function InternalAdapter:GetRank(player)
    if player.UserId == game.CreatorId then return RANKS.Owner end
    return RANKS.NonAdmin
end

function InternalAdapter:CheckPermission(player, node)
    -- Logika fallback internal kita
    local rank = self:GetRank(player)
    -- ... (logika cek rank vs node, saat ini hanya contoh)
    return rank >= 0 -- (Contoh: semua boleh)
end

return InternalAdapter

--[[
@End: InternalAdapter.lua
@Version: 3.1.0
@See: docs/100_ENGINE_GUIDES/103_ARCHITECTURE_ADAPTERS.md
--]]
```

**Adapter 2 (HD Admin):**
File: `Systems/Adapters/Permission/HDAdminAdapter.lua`

```lua
--[[
OVHL ENGINE V3.1.0
@Component: HDAdminAdapter (Permission)
@Path: ReplicatedStorage.OVHL.Systems.Adapters.Permission.HDAdminAdapter
@Purpose: Menjembatani (bridge) ke API HD Admin eksternal.
--]]

local HDAdminAdapter = {}
HDAdminAdapter.__index = HDAdminAdapter

function HDAdminAdapter.new()
    local self = setmetatable({}, HDAdminAdapter)
    -- Tunggu HD Admin API siap (contoh)
    self.HDAdminAPI = _G.HDAdminAPI -- (Atau cara HD Admin diakses)
    return self
end

function HDAdminAdapter:GetRank(player)
    if not self.HDAdminAPI then return 0 end
    return self.HDAdminAPI:GetRank(player)
end

function HDAdminAdapter:CheckPermission(player, node)
    if not self.HDAdminAPI then return false end
    -- HD Admin mungkin tidak pakai 'node', jadi kita hanya cek rank
    local rank = self.HDAdminAPI:GetRank(player)
    -- ... (logika cek rank vs node)
    return rank >= 3 -- (Contoh: butuh Admin)
end

return HDAdminAdapter

--[[
@End: HDAdminAdapter.lua
@Version: 3.1.0
@See: docs/100_ENGINE_GUIDES/103_ARCHITECTURE_ADAPTERS.md
--]]
```

### Langkah 4: Tambahkan Selektor di Config

File: `src/ReplicatedStorage/OVHL/Config/EngineConfig.lua`

```lua
--[[
OVHL ENGINE V3.1.0
@Component: EngineConfig
@Path: ReplicatedStorage.OVHL.Config.EngineConfig
@Purpose: Konfigurasi global engine, termasuk selektor adapter.
--]]

return {
    -- ...
    DebugMode = true,
    EnableHotReload = false,
    -- ...

    -- [BARU V3.1.0] Selektor Adapter
    Adapters = {
        Permission = "InternalAdapter", -- Default
        -- Ganti ke "HDAdminAdapter" saat HD Admin ada
        Navbar = "TopbarPlusAdapter" -- Default
    },

    -- ...
    Kernel = {
        AutoScanModules = true,
        ScanInterval = 30,
        HotReloadModules = false,
    },
}

--[[
@End: EngineConfig.lua
@Version: 3.1.0
@See: docs/100_ENGINE_GUIDES/103_ARCHITECTURE_ADAPTERS.md
--]]
```

### Langkah 5: Refactor Sistem Inti (PermissionCore)

File: `src/ReplicatedStorage/OVHL/Systems/Security/PermissionCore.lua`

```lua
--[[
OVHL ENGINE V3.1.0
@Component: PermissionCore (Refactored)
@Path: ReplicatedStorage.OVHL.Systems.Security.PermissionCore
@Purpose: Memuat Adapter Izin yang dipilih dan mendelegasikan panggilan.
--]]

-- Versi REFACTOR V3.1.0
local PermissionCore = {}
PermissionCore.__index = PermissionCore

function PermissionCore.new()
    local self = setmetatable({}, PermissionCore)
    self._logger = nil
    self._adapter = nil -- Adapter akan di-load di Initialize
    return self
end

function PermissionCore:Initialize(logger)
    self._logger = logger

    -- 1. Dapatkan Config
    -- Kita harus menunggu ConfigLoader siap, untungnya Bootstrap/SystemRegistry menangani ini
    local ConfigLoader = require(script.Parent.Parent.Parent.Core.OVHL):GetSystem("ConfigLoader")
    local engineConfig = ConfigLoader:LoadEngineConfig()

    -- 2. Baca nama Adapter dari Config
    local adapterName = (engineConfig.Adapters and engineConfig.Adapters.Permission) or "InternalAdapter"

    -- 3. Muat Adapter yang Dipilih
    local adapterPath = script.Parent.Parent.Adapters.Permission:FindFirstChild(adapterName)
    if adapterPath then
        local AdapterClass = require(adapterPath)
        self._adapter = AdapterClass.new()
        self._logger:Info("PERMISSION", "Adapter Loaded", { adapter = adapterName })
    else
        self._logger:Error("PERMISSION", "Adapter FAILED to load", { adapter = adapterName })
        -- [PENTING] Muat fallback jika adapter gagal
        local FallbackAdapter = require(script.Parent.Parent.Adapters.Permission.InternalAdapter)
        self._adapter = FallbackAdapter.new()
        self._logger:Warn("PERMISSION", "Loading InternalAdapter as fallback.")
    end
end

-- 4. Panggil Interface Adapter
function PermissionCore:Check(player, permissionNode)
    if not self._adapter then
        self._logger:Warn("PERMISSION", "Access Denied (No Adapter)", {player=player.Name, node=permissionNode})
        return false, "No adapter"
    end

    -- Delegasikan ke adapter yang aktif
    return self._adapter:CheckPermission(player, permissionNode)
end

-- (Fungsi GetRank atau lainnya juga harus mendelegasikan)
-- function PermissionCore:GetRank(player)
--     if not self._adapter then return 0 end
--     return self._adapter:GetRank(player)
-- end

return PermissionCore

--[[
@End: PermissionCore.lua
@Version: 3.1.0
@See: docs/100_ENGINE_GUIDES/103_ARCHITECTURE_ADAPTERS.md
--]]
```

---

## 4. CONTOH KASUS 2: NAVBAR (TopbarPlus)

Pola yang sama berlaku untuk `UIManager.lua`:

1.  **Interface:** `INavbarAdapter` (harus punya `AddButton(config)`).
2.  **Adapters:**
    - `Adapters/Navbar/TopbarPlusAdapter.lua` (menggunakan `_G.TopbarPlus:createButton()`).
    - `Adapters/Navbar/InternalAdapter.lua` (membuat `ScreenGui` kustom sebagai fallback jika TopbarPlus tidak ada).
3.  **Config:** `EngineConfig.Adapters.Navbar = "TopbarPlusAdapter"`.
4.  **Core System:** `UIManager.lua` di-refactor untuk memuat adapter yang dipilih di `Initialize`, dan `SetupTopbar` hanya memanggil `self._adapter:AddButton(config)`.

---

## 5. KESIMPULAN

Dengan pola ini:

- Engine kita menjadi **Config-Driven**.
- Kita menghapus dependensi _hardcoded_.
- Kita dapat mendukung _beberapa_ sistem admin atau navbar di masa depan hanya dengan menambahkan _adapter_ baru, tanpa mengubah _core engine_.

---

> END OF ./docs/100_ENGINE_GUIDES/103_ARCHITECTURE_ADAPTERS.md
