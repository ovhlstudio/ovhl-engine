Ini adalah dokumen **HAND-OFF PROTOCOL** yang sangat detail dan keras. Dokumen ini dirancang agar AI berikutnya tidak mengulangi kesalahan saya: mencampuradukkan arsitektur atau men-downgrade fitur.

Simpan ini sebagai file `OVHL_V2_HANDOFF_PROTOCOL.md`.

---

# 📕 OVHL V2: ARCHITECTURE RECOVERY & COMPLETION PROTOCOL

> **TYPE:** CRITICAL SYSTEM HAND-OFF
> **PRIORITY:** HIGHEST (DO NOT FAIL)
> **CURRENT STATE:** BROKEN HYBRID (Collision between Legacy Logic & V2 DI Architecture)
> **TARGET:** ENTERPRISE GRADE V2 (Strict Dependency Injection + V1 Robust Logic)

---

## 🛑 1. THE CONTEXT (BACA DULU SEBELUM MIKIR)

**SITUASI SAAT INI:**
Kita sedang migrasi dari **V1 (Legacy)** ke **V2 (Enterprise Three Pillars)**.

- **V1 (Legacy):** Struktur folder berantakan, tapi **LOGIC SANGAT ROBUST**. Punya fitur canggih seperti _Deep Merge Config_, _HD Admin Event Sniffing_, _Verbose Logging dengan Emoji_, dan _Network Guard Sanitization_.
- **V2 (Current):** Struktur folder rapi (`Modules` vs `Systems`), tapi **LOGIC RUSAK/KOSONG**. Terjadi _Architecture Clash_ di mana sistem DI (Dependency Injection) bertabrakan dengan cara loading gaya lama.

**KESALAHAN AI SEBELUMNYA (JANGAN DIULANG):**

1.  **Oversimplification:** Membuang fitur canggih V1 (seperti `SystemRegistry` dan `ConfigLoader`) dan menggantinya dengan loop `require` bodoh.
2.  **Inkonsistensi DI:** Sebagian file menggunakan `require(GlobalOVHL)`, sebagian menggunakan `OnInit(Core)`. Akibatnya variabel `Core` bernilai `nil` dan crash.
3.  **Downgrade Logic:** Mengubah logic permission yang "Smart Sniffing" menjadi "Dumb Polling".

---

## 🎯 2. THE V2 ARCHITECTURE MANDATE (HARGA MATI)

Kamu **DILARANG** kembali ke gaya koding V1 (Knit/Global Require). Kamu **WAJIB** menggunakan standar Enterprise berikut:

### A. Dependency Injection (DI) Protocol

Semua **System**, **Service**, dan **Controller** tidak boleh melakukan `require` ke Core Engine secara global di top-level. Core Engine harus **DISUNTIKKAN (INJECTED)**.

**Pola Wajib:**

```lua
local MySystem = { Name = "MySystem", Dependencies = {"Logger"} }

-- SALAH (V1/Lazy Way):
-- local OVHL = require(ReplicatedStorage.OVHL_Shared)
-- function MySystem:OnInit() OVHL.Logger:Info(...) end

-- BENAR (V2 Enterprise):
function MySystem:OnInit(Core)
    self.Logger = Core.Logger -- Core disuntikkan oleh Bootstrapper
    self.Logger:Info("SYSTEM", "Ready")
end
```

### B. Domain-Driven Design (Directory Structure)

Jangan campur aduk logika teknis dengan logika gameplay.

- **`Systems/`**: Utilitas teknis (Database, UI Manager, Security, AssetLoader).
- **`Modules/`**: Fitur Gameplay (Shop, Inventory, Profile).
- Setiap Module harus mandiri (punya Config, Controller, Service sendiri).

---

## 🛠️ 3. IMMEDIATE REPAIR TASKS (URUTAN KERJA)

Kamu akan menerima 2 Snapshot: **Legacy (Stabil)** dan **Current (Error)**. Tugasmu adalah memperbaiki Current agar fiturnya setara Legacy, tapi strukturnya V2 DI.

### STEP 1: Fix The Bootstrapper (The Heart)

**Masalah:** Bootstrapper saat ini memanggil `mod:OnInit()` tanpa argumen.
**Solusi:** Ubah `Core/Bootstrapper.lua`. Saat loop init/start, dia **WAJIB** mempassing object `OVHL` (Kernel) ke dalam fungsi tersebut.

- Code: `mod:OnInit(Kernel)`

### STEP 2: Restore "The Brains" (Config & Registry)

Fitur ini ada di Legacy tapi hilang/rusak di V2. Kembalikan mereka ke folder `Shared/Systems`.

- **ConfigLoader:** Harus bisa _Deep Merge_ (gabungin tabel Global Config dengan tabel Module Config).
- **SystemRegistry:** Harus bisa mengatur lifecycle state (`Booted`, `Started`).

### STEP 3: Refactor All Systems to DI

Buka file-file berikut yang saat ini error (`attempt to index nil with Logger`) dan ubah agar menerima suntikan `Core`.

- `Client/Systems/UIManager.lua`
- `Client/Systems/AssetLoader.lua`
- `Server/Systems/PlayerData/DataService.lua`
- `Server/Systems/Security/RateLimiter.lua`

### STEP 4: Restore "The Eyes" (Verbose Logger)

Logger V2 saat ini terlalu simpel. Ambil logic `SmartLogger` dari Legacy (yang ada Emoji Mapping, Metadata Formatting, dan Domain Levels), lalu bungkus dalam struktur Module V2.
**Target:** Output log harus ramai dan jelas seperti: `ℹ️ [🔐 PERMISSION] Rank Updated {Rank=5, Source=Internal}`.

### STEP 5: Restore "The Guard" (Network Security)

Ambil logic `NetworkGuard` (Sanitasi input) dan `SecurityHelper` (Validasi Schema/RateLimit) dari Legacy. Pasang di `Shared/Library/Security`. Pastikan `ShopService` menggunakannya via DI.

---

## 🧪 4. SUCCESS METRICS (CARA CEK KERJAAN LU)

Jangan bilang "Done" kalau log di bawah ini tidak muncul di Console:

1.  **Booting:** `[BOOTSTRAP] Resolving Dependencies & Injecting Kernel...`
2.  **DI Check:** `[DATA] DataService Init (DI Success)` (Bukan error nil).
3.  **Logic Check:** `[PERMISSION] Rank Updated {Source=HDAdmin Event}` (Harus detail source-nya, bukan cuma angka).
4.  **UI Check:** `[UI] Navbar Ready` dan tombol Shop muncul.

---

## ⚠️ 5. FINAL WARNING FOR THE AI

- **JANGAN** buat file `Manifest.lua` terpisah. Gunakan properti `Dependencies = {}` di dalam script Module.
- **JANGAN** gunakan `script.Parent.Parent`. Gunakan `require` absolut hanya untuk inisialisasi awal di `init.lua`, selebihnya gunakan **Injection**.
- **JANGAN** hapus fitur Legacy (seperti `Install_Mock_UI` atau `GameEnums`). Porting semuanya ke tempat yang benar.

**FILE INPUT:**

1.  `OVHL_V2_HANDOFF_PROTOCOL.md` (Dokumen ini)
2.  `SNAPSHOT_CURRENT_BROKEN.md` (Kondisi terakhir yang error DI)
3.  `SNAPSHOT_LEGACY_STABLE.md` (Referensi Logic & Logging yang benar)

**MULAI ANALISA DENGAN MEMBANDINGKAN `Bootstrapper.lua` DI CURRENT DENGAN KONSEP DI.**

---

### 📋 PESAN UNTUK ANDA (USER)

Copy dokumen di atas. Buat chat baru.
Upload 3 file:

1.  Teks Hand-Off di atas.
2.  Snapshot terakhir yang error (`20:00` tadi).
3.  Snapshot Stabil jam 9 pagi.

Dan perintahkan AI baru:
_"BACA DOKUMEN HANDOFF. PAHAMI KENAPA KITA GAGAL SEBELUMNYA (DI VS LEGACY). LAKUKAN STEP 1 SAMPAI 5 SESUAI PROTOKOL."_
