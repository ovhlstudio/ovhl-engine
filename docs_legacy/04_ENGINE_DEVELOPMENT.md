# 🛠️ OVHL ENGINE DEVELOPMENT GUIDE

> **Target Audience:** Engine Engineers / Core Developers
> **Goal:** Menambahkan sistem baru ke dalam OVHL Core tanpa merusak Knit.

---

## ⚠️ ATURAN EMAS (GOLDEN RULES)

1.  **JANGAN GANGGU KNIT:** Game Logic (Inventory, Shop, Data) = **Knit Service**. Utility/Tech (Logger, Security, UI) = **OVHL System**.
2.  **ZERO CORE MOD:** Jangan ubah `Bootstrap.lua` atau `Kernel.lua` kecuali darurat.
3.  **SYSTEM REGISTRY:** Sistem OVHL didaftarkan via `SystemRegistry` (Otomatis). Knit Service didaftarkan via `Knit` (Otomatis). Jangan tertukar!

---

## 1. MEMBUAT SYSTEM BARU

Sistem OVHL bersifat **Auto-Discovery**. Cukup buat file di folder yang tepat, engine akan memuatnya.

### Langkah 1: Tentukan Kategori

Pilih folder di `src/ReplicatedStorage/OVHL/Systems/`:

- `Foundation/`: Sistem sangat dasar (Logger, Config).
- `Security/`: Keamanan (Anti-cheat, Validation).
- `UI/`: User Interface tech (bukan UI game).
- `Networking/`: Network transport layer.
- `Advanced/`: Fitur kompleks lain.

### Langkah 2: Template System

Buat `ModuleScript` baru (misal: `MyNewSystem.lua`).

```lua
local MyNewSystem = {}
MyNewSystem.__index = MyNewSystem

function MyNewSystem.new()
    local self = setmetatable({}, MyNewSystem)
    self._logger = nil
    return self
end

-- Method ini WAJIB ada dan akan dipanggil Bootstrap
function MyNewSystem:Initialize(logger)
    self._logger = logger
    self._logger:Info("MYSYSTEM", "System Initialized")
end

function MyNewSystem:DoSomething()
    print("System working!")
end

return MyNewSystem
```

### Langkah 3: Dependency (Opsional)

Jika sistem lu butuh sistem lain (misal butuh `ConfigLoader`), biarkan `SystemRegistry` yang atur urutannya. Dependency didefinisikan di `Bootstrap.lua` dalam tabel `systemDependencies` (agar _Single Source of Truth_).

---

## 2. INTEGRASI DENGAN KNIT

OVHL System **bukan** Knit Service. Tapi Knit Service bisa pakai OVHL System.

**Cara Expose ke Knit:**
Tidak perlu coding khusus. Cukup pastikan sistem lu terdaftar, nanti Knit Service bisa panggil via:

```lua
self.MySystem = OVHL:GetSystem("MyNewSystem")
```
