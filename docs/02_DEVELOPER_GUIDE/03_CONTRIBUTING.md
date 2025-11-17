# 🤝 CONTRIBUTING: ADDING NEW SYSTEMS

> **TUJUAN:** Panduan jika ingin menambah SYSTEM internal baru ke dalam engine (Bukan Modul Game).

---

## CARA MENAMBAH SYSTEM BARU

Jika kamu butuh sistem global baru (misal: `SoundManager` atau `DataManager`):

### 1. Buat File

Lokasi: `src/ReplicatedStorage/OVHL/Systems/Advanced/SoundManager.lua`.

### 2. Struktur Wajib

```lua
local SoundManager = {}
SoundManager.__index = SoundManager

function SoundManager.new() return setmetatable({}, SoundManager) end

-- [WAJIB] Method ini akan dipanggil otomatis oleh Bootstrap
function SoundManager:Initialize(logger)
    self._logger = logger
    self._logger:Info("SOUND", "Sound Manager Ready")
end

return SoundManager
```

### 3. Daftarkan Dependensi (CRITICAL!)

Sistem baru tidak akan tahu urutan load-nya kecuali diberi tahu.
Buka `src/ReplicatedStorage/OVHL/Core/Bootstrap.lua` dan edit tabel `systemDependencies`:

```lua
-- Di dalam Bootstrap.lua
local systemDependencies = {
    -- ... sistem lain ...

    -- Tambahkan sistem barumu di sini:
    SoundManager = {"SmartLogger", "ConfigLoader"}
    -- Artinya: SoundManager baru akan start SETELAH Logger & Config siap.
}
```

### 4. Selesai!

Bootstrap akan otomatis melakukan:

1.  Scan file `SoundManager.lua`.
2.  Cek dependency.
3.  Load dan Initialize.
4.  Daftarkan ke `OVHL:GetSystem("SoundManager")`.
