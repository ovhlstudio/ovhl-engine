# 📑 OVHL ENGINE V2.0 - TECHNICAL SPECIFICATION DOCUMENT

Project: OVHL Engine (Roblox)

Version Target: 2.0.0 (Architecture Overhaul)

Date: 19 November 2025

Author: Gemini (AI Assistant) under supervision of Principal Dev.

---

## 1\. LATAR BELAKANG & DIAGNOSA MASALAH (ROOT CAUSE ANALYSIS)

Sebelum membangun ulang, kita harus paham betul kenapa V1.x gagal. Kegagalan V1.x bukan sekadar "bug", tapi cacat desain fundamental.

### 1.1. Isu "Data Poisoning" (ConfigLoader)

- **Gejala:** Modul B (`PrototypeShop`) memuat konfigurasi milik Modul A (`MinimalModule`), menyebabkan tombol Topbar ganda atau salah label.

- **Penyebab Teknis:** Algoritma `MergeDeep` pada `ConfigLoader` melakukan _Shallow Copy_ pada table. Saat Modul A dimuat, ia secara tidak sengaja memodifikasi table `EngineConfig` di memori global. Modul B kemudian membaca `EngineConfig` yang sudah "teracuni" data Modul A.

- **Solusi V2:** Implementasi **Recursive Deep Copy** yang memutus referensi memori antar config modul.

### 1.2. Isu "Event Leakage" (UIManager & Topbar)

- **Gejala:** Menekan tombol Modul A memicu event/fungsi milik Modul B.

- **Penyebab Teknis:** Penggunaan _Closure Callback_ (mengoper fungsi anonim ke dalam `SetupTopbar`). Karena inisialisasi cepat, referensi fungsi bisa tertukar atau instance tombol di-recycle secara tidak aman oleh library eksternal (`TopbarPlus`).

- **Solusi V2:** **Centralized Event Bus**. Adapter hanya mengirim sinyal ID (String) ke `UIManager`. Controller mendengarkan event bus tersebut. Tidak ada fungsi yang disuntikkan ke Adapter.

### 1.3. Isu "Spaghetti Code" (Monolith Structure)

- **Gejala:** Logic UI, Logic Bisnis, dan Data Config bercampur dalam satu file Controller. Sulit di-maintenance dan di-scale.

- **Solusi V2:** Penerapan pola **MVCS (Model-View-Controller-Service)** dengan pemisahan folder fisik yang ketat.

---

## 2\. ARSITEKTUR INTI (THE HOLY TRINITY)

Definisi peran absolut untuk mencegah tumpang tindih tanggung jawab.

| **Komponen** | **Analogi Tubuh**    | **Tugas & Tanggung Jawab Absolut**                                                 | **Larangan Keras**                                      |
| ------------ | -------------------- | ---------------------------------------------------------------------------------- | ------------------------------------------------------- |
| **KNIT**     | **Sistem Saraf**     | Mengelola siklus hidup (`Init`, `Start`) dan Jaringan (Client-Server Comm).        | Dilarang menyentuh properti UI secara langsung.         |
| ---          | ---                  | ---                                                                                | ---                                                     |
| **FUSION**   | **Wajah & Ekspresi** | Mengelola **Reactive State** dan konstruksi Visual UI.                             | Dilarang mengandung logic bisnis (misal: hitung harga). |
| **OVHL**     | **Otak & Hukum**     | Orchestrator. Membaca Config, menegakkan Permission, Security, dan memanggil View. | Dilarang di-bypass. Semua modul wajib lewat OVHL.       |

---

## 3\. STRUKTUR FOLDER & STANDARISASI (MVCS PATTERN)

Setiap modul (baik Simple maupun Complex) **WAJIB** mematuhi struktur folder berikut. Tidak ada pengecualian.

### Struktur Direktori Modul (`src/.../Modules/NamaModul/`)

Plaintext

```
📂 NamaModul
   ├── 📂 Shared
   │    └── 🌙 SharedConfig.lua       [DATA] Single Source of Truth. Definisi Text, Icon, Rule.
   │
   ├── 📂 Server
   │    ├── 🌙 [Name]Service.lua      [FASAD] Gerbang keamanan. Validasi Input & Permission Server.
   │    ├── 🌙 ServerConfig.lua       [DATA] Kunci rahasia / Config sisi server.
   │    └── 📂 Internal               [LOGIC] (Optional) Logic murni (Math, Algoritma Inventory).
   │
   └── 📂 Client
        ├── 🌙 [Name]Controller.lua   [FASAD] Pengendali alur. Dengar Event -> Panggil Service -> Update View.
        ├── 🌙 ClientConfig.lua       [STATE] Container untuk Fusion State (Reactive Config).
        └── 📂 Views                  [VIEW] Folder khusus UI.
             ├── 🌙 Interface.lua     [MANAGER] Penentu jalur: Apakah load Native atau Fusion?
             ├── 🌙 FusionView.lua    [CODE] Konstruksi UI menggunakan Fusion.
             └── 🌙 NativeScanner.lua [FINDER] Logic pencari ScreenGui (jika mode Native).

```

### Standar File Config (`SharedConfig.lua`)

Config adalah "Gerbang Utama". UI Manager dan Logic bekerja berdasarkan apa yang tertulis di sini.

Lua

```
return {
    Identity = { Name = "Shop", Version = "2.0" },
    UI = {
        Mode = "AUTO", -- "NATIVE" | "FUSION" | "AUTO"
        TargetScreen = "ShopGUI", -- Wajib jika Native
        Components = { -- Mapping untuk Scanner
            BuyBtn = "Button_Buy",
            Title  = "Label_Title"
        }
    },
    Topbar = {
        Type = "Toggle", -- "Toggle" | "Dropdown"
        Text = "SHOP",
        Icon = "rbxassetid://...",
        Permission = "NonAdmin" -- Rank string/id
    },
    Security = { ... } -- Schema & RateLimit
}

```

---

## 4\. SISTEM PENDUKUNG BARU (INFRASTRUCTURE V2)

Untuk mendukung arsitektur di atas, Core System harus diperbarui:

1.  **`ComponentScanner` (New Service):**

    - **Fungsi:** Melakukan pencarian rekursif (`FindFirstChild(..., true)`) pada `PlayerGui`.

    - **Tujuan:** Memungkinkan arsitektur "No Hardcode Path". Artist bebas memindah tombol asalkan namanya tetap.

2.  **`UIManager` (Refactor):**

    - **Fungsi:** Menjadi **Event Dispatcher**. Menerima klik dari Adapter, mem-broadcast sinyal `OnTopbarClick(id)`.

    - **Tujuan:** Memutus ketergantungan langsung (closure) antara Adapter dan Controller.

3.  **`ConfigLoader` (Refactor):**

    - **Fungsi:** Implementasi algoritma **Deep Copy** saat melakukan merge layer config (Engine -> Shared -> Context).

    - **Tujuan:** Mencegah _Data Poisoning_.

---

## 5\. PROTOKOL CADANGAN (BACKUP PROTOCOL)

Setiap eksekusi perubahan file oleh Script harus mematuhi protokol backup ketat.

- **Lokasi Backup:** `./lokal/backup/[FOLDER_SESI_TIMESTAMP]/`

- **Format Timestamp:** `YYYYMMDD_HHMMSS` (Contoh: `20251119_083000`)

- **Aturan:**

  1.  Sebelum file di-overwrite, file asli **WAJIB** disalin ke folder backup dengan menjaga struktur path aslinya.

  2.  Script harus membuat folder sesi di awal eksekusi.

  3.  Log terminal harus mencantumkan lokasi backup.

Contoh Path:

./lokal/backup/20251119_083000/src/ReplicatedStorage/OVHL/Config/EngineConfig.lua

---

## 6\. ATURAN MAIN AI & DEV (RULES OF ENGAGEMENT)

1.  **No Assumption:** AI dilarang menebak nama folder atau file. Wajib merujuk pada snapshot terakhir.

2.  **Atomic Scripting:** Bash script harus bersifat atomik. Gunakan `set -e`. Jika satu langkah gagal, seluruh proses berhenti.

3.  **Verification Step:** Di akhir script, lakukan pengecekan (`ls -l` atau `grep`) untuk memastikan file target benar-benar terisi konten baru.

4.  **Clean Slate (Khusus Sesi Ini):** Karena arsitektur berubah total, modul lama (`MinimalModule`, `PrototypeShop`) yang menggunakan pola V1 akan **DIHAPUS** dan digantikan dengan struktur V2.

---

## 7\. RENCANA EKSEKUSI (ACTION PLAN)

Jika dokumen ini disetujui, langkah eksekusi dibagi menjadi fase berikut:

- **FASE 1: PREPARATION & BACKUP**

  - Membuat folder backup sesi.

  - Mengamankan file existing.

- **FASE 2: CORE INFRASTRUCTURE**

  - Inject `ComponentScanner`.

  - Update `UIManager` (Event Driven).

  - Fix `ConfigLoader` (Deep Merge).

  - Update `TopbarPlusAdapter` (Dumb Terminal).

- **FASE 3: MODULE IMPLEMENTATION (V2 STRUCTURE)**

  - Rebuild `MinimalModule` (Fusion View).

  - Rebuild `PrototypeShop` (Native View + Scanner).

- **FASE 4: VERIFICATION**

  - Play Test & Check Logs (SmartLogger).
