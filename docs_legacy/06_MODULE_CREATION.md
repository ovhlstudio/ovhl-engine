# 📦 MODULE CREATION GUIDE

> **Target Audience:** Gameplay Programmers
> **Goal:** Membuat fitur game (Inventory, Shop, dll) menggunakan standar OVHL.

---

## ⚠️ THE 10 COMMANDMENTS (INGAT INI!)

1.  **Zero Core Mod:** Jangan sentuh folder `Core`! Buat logic di `Modules/`.
2.  **Config-Driven:** Jangan hardcode angka/string. Taruh di `SharedConfig.lua`.
3.  **Self-Contained:** Modul harus mandiri.
4.  **Server Authority:** **NEVER TRUST CLIENT**. Selalu validasi di Server.
5.  **Standard Lifecycle:** Gunakan `KnitInit` dan `KnitStart`.
6.  **Naming:** `NamaService.lua`, `NamaController.lua`. Jangan `Service.lua` doang.
7.  **No Relative Paths:** Gunakan `game:GetService(...)`.
8.  **Flat Structure:** Ikuti struktur folder OVHL.
9.  **300 Line Limit:** Pecah file jika terlalu panjang.
10. **Secure:** Validasi semua input dari Client.

---

## 1. STRUKTUR MODUL BARU

Copy folder `MinimalModule` dan rename sesuai fitur (misal `Inventory`).

```
Inventory/
├── Server/
│   ├── InventoryService.lua      (Logika Server)
│   └── ServerConfig.lua          (Config Rahasia/Server Only)
├── Client/
│   ├── InventoryController.lua   (Logika Client & UI)
│   └── ClientConfig.lua          (Config Client Only)
└── Shared/
    └── SharedConfig.lua          (Config Umum & Schema)
```

---

## 2. LANGKAH PEMBUATAN

### Step A: Definisi Config & Schema (SharedConfig.lua)

Tentukan data apa yang boleh dikirim Client.

```lua
Security = {
    ValidationSchemas = {
        -- Client cuma boleh kirim data format ini:
        EquipItem = {
            type = "table",
            fields = {
                itemId = { type = "string" },
                slot = { type = "number", min = 1, max = 10 }
            }
        }
    }
}
```

### Step B: Server Logic (Service)

Gunakan **OVHL Security Layer** di sini.

```lua
function InventoryService.Client:EquipItem(player, data)
    -- 1. VALIDASI INPUT (Wajib!)
    local valid, err = self.InputValidator:Validate("EquipItem", data)
    if not valid then return false, err end

    -- 2. CEK RATE LIMIT (Biar gak spam)
    if not self.RateLimiter:Check(player, "Equip") then return false, "Spam detected" end

    -- 3. CEK PERMISSION
    if not self.PermissionCore:Check(player, "Inventory.Equip") then return false, "No Access" end

    -- 4. PROSES LOGIC
    self.Logger:Info("GAME", "Player equip item", {item = data.itemId})
    return true
end
```

### Step C: Client Logic (Controller)

Kirim data sesuai Schema (Table).

```lua
function InventoryController:Equip(id)
    -- Kirim data sebagai TABLE (Sesuai Schema)
    self.Service:EquipItem({
        itemId = id,
        slot = 1
    })
end
```

---

## ❓ FAQ: "Fitur yang gue butuh gak ada!"

**Q: Gue butuh sistem DataStore canggih, tapi di API Reference gak ada.**
**A:** Jangan paksakan logic DataStore di dalam Module.

1.  Baca `04_ENGINE_DEVELOPMENT.md`.
2.  Buat System baru di `src/OVHL/Systems/Advanced/DataManager.lua`.
3.  Baru panggil sistem itu di Module lu via `OVHL:GetSystem("DataManager")`.

**Q: UI gue kompleks banget, Fusion biasa ribet.**
**A:** Pecah UI lu jadi komponen-komponen kecil di folder `Client/Components`. Tetap gunakan `UIEngine` untuk mounting-nya.
