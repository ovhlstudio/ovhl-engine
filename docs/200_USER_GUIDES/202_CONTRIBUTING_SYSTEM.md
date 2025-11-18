> START OF ./docs/200_USER_GUIDES/202_CONTRIBUTING_SYSTEM.md
>
> **OVHL ENGINE V3.4.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** ENGINE ENGINEERS, CORE DEVELOPERS
> **PURPOSE:** Panduan teknis untuk menambahkan **Sistem Engine** baru (misal: DataManager, SoundManager) ke dalam OVHL Core, sesuai Lifecycle V3.4.0.

---

# 🛠️ 202_CONTRIBUTING_SYSTEM.MD (V3.4.0)

> **REFERENSI:** Dokumen ini telah diperbarui untuk mencerminkan **Lifecycle 4-Fase (ADR-004)**.

---

## 1. ⚠️ ATURAN EMAS (FILOSOFI)

Pahami perbedaan fundamental ini:

1.  **Knit Service (`Modules/`) = Logika Gameplay.**

    - Tujuannya adalah _fitur_ (Inventory, Shop, Quest).
    - Dipindai oleh `Kernel.lua`.

2.  **OVHL System (`Systems/`) = Utilitas/Teknologi.**
    - Tujuannya adalah _kemampuan_ (Logger, Validator, DataManager).
    - Dipindai oleh `Bootstrap.lua`.

**JANGAN TERTUKAR!**

---

## 2. LANGKAH IMPLEMENTASI (Contoh: `DataManager`)

Sistem OVHL bersifat **Auto-Discovery** (via `*Manifest.lua`).

### Langkah 1: Tentukan Kategori

Pilih folder di `src/ReplicatedStorage/OVHL/Systems/`:

- `Foundation/`: Sangat dasar (Logger, Config).
- `Security/`: Keamanan (Validator, RateLimiter).
- `UI/`: Teknologi UI (UIEngine).
- `Networking/`: Transport layer (Router).
- `Adapters/`: Jembatan ke API pihak ketiga.
- `Advanced/`: Fitur kompleks lain (Target: `DataManager`, `StateManager`).

### Langkah 2: Template System

Buat `ModuleScript` baru (misal: `DataManager.lua`) menggunakan template V3.4.0.

```lua
--[[
OVHL ENGINE V3.4.0
@Component: MyNewSystem (Core System)
@Path: ReplicatedStorage.OVHL.Systems.Advanced.MyNewSystem
@Purpose: Templat untuk sistem baru.
--]]

local MySystem = {}
MySystem.__index = MySystem

function MySystem.new()
    local self = setmetatable({}, MySystem)
    self._logger = nil
    self._connections = {} -- Wajib: untuk Disconnect
    self._isRunning = false -- Wajib: untuk task.spawn cleanup
    return self
end

-- [...] (LANJUTKAN DENGAN IMPLEMENTASI FUNGSI 4-FASE DI BAWAH)

return MySystem

--[[
@End: MyNewSystem.lua
@Version: 3.4.0
@See: docs/200_USER_GUIDES/202_CONTRIBUTING_SYSTEM.md
--]]
```

### Langkah 3: Daftarkan Dependensi (KRITIS!)

Buat file `MyNewSystemManifest.lua` di sebelah `MyNewSystem.lua` untuk deklarasi dependensi dan konteks.

```lua
-- MyNewSystemManifest.lua
return {
	name = "MyNewSystem",
	dependencies = { "SmartLogger", "DependencyLain" },
	context = "Shared" -- Server, Client, atau Shared
}
```

---

## 3. MANDATORY FUNCTIONS (V3.4.0 Lifecycle)

Semua Sistem harus mendefinisikan fungsi-fungsi berikut untuk berinteraksi dengan **SystemRegistry**.

### A. System:Initialize(logger) (Fase 1: Konstruksi)

Ini adalah fase pertama dari bootup. Sistem Anda hanya boleh menerima referensi logger dan menyiapkan variabel lokal.

**MANDAT TUGAS:**

1.  Simpan logger: `self._logger = logger`.
2.  Siapkan variabel.

**MANDAT LARANGAN:**

1.  **DILARANG KERAS** memanggil `OVHL:GetSystem()`.
2.  **DILARANG KERAS** menghubungkan event (misalnya `game.Players.PlayerAdded:Connect()`).
3.  **DILARANG KERAS** memulai _loop_ `task.spawn()` atau tugas asinkron lainnya.

### B. System:Start() (Fase 3: Aktivasi)

Ini adalah fase aktivasi. Semua dependensi sistem dijamin sudah terdaftar di `OVHL` (melalui Fase 2).

**MANDAT TUGAS:**

1.  **Resolusi Dependensi:** Panggil `OVHL:GetSystem("Dependency")`.
2.  **Koneksi Event:** Hubungkan semua _event_ (misalnya `Players.PlayerAdded:Connect()`). Simpan koneksi di `self._connections`.
3.  **Mulai Task:** Jalankan _loop_ atau tugas background. Gunakan _flag_ `self._isRunning`.

```lua
function MySystem:Start()
    local OVHL = require(script.Parent.Parent.Parent.Core.OVHL)
    self._dataManager = OVHL:GetSystem("DataManager") -- AMAN di Fase 3

    self._isRunning = true
    self:_startCleanupTask() -- task.spawn(while self._isRunning do...

    self.Connections.PlayerAdded = Players.PlayerAdded:Connect(self.OnPlayerAdded)
end
```

### C. System:Destroy() (Fase 4: Cleanup/Shutdown)

**Fungsi ini WAJIB diimplementasikan** jika sistem Anda menggunakan `Connect()` atau `task.spawn()`. Dipanggil oleh `SystemRegistry` saat `game:BindToClose()`.

**MANDAT TUGAS:**

1.  **Stop Tasks:** Gunakan _flag_ `self._isRunning = false` untuk menghentikan semua `task.spawn()` _loop_ Anda.
2.  **Final Save:** Jika Anda adalah _Data Manager_, pastikan semua data tersimpan.
3.  **Disconnect:** Putuskan semua koneksi event yang tersimpan di `self._connections`.

```lua
-- Contoh wajib untuk PlayerManager atau RateLimiter:
function MySystem:Destroy()
    self._logger:Info("SYSTEM", "Menjalankan Fase 4: Cleanup.")

    -- 1. Hentikan loop task.spawn
    self._isRunning = false

    -- 2. Disconnect semua koneksi event
    for name, conn in pairs(self._connections) do
        conn:Disconnect()
        self._connections[name] = nil
    end
end
```

---

## 4. INTEGRASI DENGAN KNIT SERVICE

Cara **Modul Gameplay (Knit)** menggunakan **Sistem Engine (OVHL)** yang baru Anda buat.

```lua
-- Di dalam InventoryService.lua
function InventoryService:KnitInit()
    -- 1. Dapatkan API Gateway
    self.OVHL = require(game.ReplicatedStorage.OVHL.Core.OVHL)

    -- 2. Panggil Sistem (Bukan Service)
    -- Knit Init aman karena OVHL sudah stabil sejak Fase 2.
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
