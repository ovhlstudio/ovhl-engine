> START OF ./docs/100_ENGINE_GUIDES/104_ROADMAP_BUILD.md
>
> **OVHL ENGINE V3.1.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** ENGINE ENGINEERS
> **PURPOSE:** Menetapkan peta arsitektural dan urutan implementasi sistem "Build From Scratch".

---

# 🗺️ 104_ROADMAP_BUILD.MD (V3.1.0)

> **DESAIN:** Dirancang sebagai panduan "Build From Scratch" (Mulai dari Awal).
> **CATATAN:** Status progres (Selesai, Gagal) dilacak secara terpisah di `300_LOGS/`.

---

## 🎯 ARSITEKTUR OVERVIEW

Roadmap ini dibagi menjadi beberapa fase implementasi yang logis. Setiap fase membangun di atas fondasi fase sebelumnya dan memiliki kriteria sukses yang jelas.

---

## 📊 URUTAN IMPLEMENTASI (V3.1.0)

### Phase 0: Persiapan & Scaffolding (Preparation)

Fase ini adalah tentang menyiapkan lingkungan, tools, dan struktur folder. Belum ada coding engine.

- **Tugas Implementasi:**

  1.  Siapkan Tools: Instal VS Code, Rojo, dan Wally.
  2.  Inisialisasi Proyek: Buat `default.project.json` (Rojo) dan `wally.toml` (Wally).
  3.  Instalasi Dependensi: Jalankan `wally install` untuk (minimal) `knit`, `fusion`, dan `testez`.
  4.  Buat Scaffolding: Buat seluruh struktur direktori kosong (semua folder) seperti yang didefinisikan dalam `101_GENESIS_ARCHITECTURE.md`.
  5.  Buat file-file _entrypoint_ kosong: `ServerRuntime.server.lua` dan `ClientRuntime.client.lua`.

- **Kriteria Sukses (Teknis):**

  1.  Folder `Packages/` (atau `lib/`) berhasil dibuat dan berisi `Knit`, `Fusion`, dll.
  2.  Menjalankan `rojo serve` berhasil melakukan sinkronisasi tanpa error.

- **Target Play Test (Validasi Scaffold):**
  1.  Buka tempat Roblox.
  2.  Verifikasi bahwa `ReplicatedStorage`, `ServerScriptService`, dan `StarterPlayerScripts` memiliki struktur folder `OVHL/` yang benar sesuai SSoT `101_GENESIS_ARCHITECTURE.md`.

---

### Phase 1: Fondasi Inti (Core Foundation)

Fase ini adalah tentang mengisi _scaffold_ dengan kode inti agar engine bisa "boot".

- **Tugas Implementasi:**

  1.  Implementasi `OVHL.lua`: Buat API Gateway (fungsi `GetSystem`, `GetConfig`, dll).
  2.  Implementasi `ConfigLoader.lua`: Kode untuk resolusi 3-Config (Shared, Server, Client).
  3.  Implementasi `SmartLogger.lua` & `LoggerConfig.lua`: Sistem logging 4-mode (Lihat `211_LOGGER.md`).
  4.  Implementasi `SystemRegistry.lua`: Logika _Topological Sort_ (Lihat `102_CORE_MECHANICS.md`).
  5.  Implementasi `Bootstrap.lua`: Sistem _discovery_ (Scan folder `Systems/`), load order, dan inisialisasi `SystemRegistry`.
  6.  Implementasi `Kernel.lua`: Sistem _discovery_ modul (Scan folder `Modules/`).
  7.  Update `ServerRuntime` & `ClientRuntime` untuk memanggil `Bootstrap:Initialize()` dan `Kernel:ScanModules()`.

- **Kriteria Sukses (Teknis):**

  1.  `Bootstrap:Initialize()` berhasil memuat semua sistem di `Systems/Foundation/`.
  2.  `OVHL:GetSystem("SmartLogger")` mengembalikan instance logger yang valid.
  3.  `OVHL:GetConfig("MinimalModule")` (meskipun modulnya masih kosong) berhasil menggabungkan config.

- **Target Play Test (Boot Engine):**
  1.  Jalankan Play Test di Studio.
  2.  Periksa Output konsol.
  3.  **Hasil:** Harus melihat log "🚀 SERVER - Engine started" dan "🎮 CLIENT - Engine started" dari `SmartLogger`. Tidak boleh ada error "nil value" saat boot.

---

### Phase 2: Keamanan & UI Dasar (Security & UI)

Fase ini membangun sistem pendukung utama yang dibutuhkan oleh semua modul gameplay.

- **Tugas Implementasi:**

  1.  **Security Layer:** Implementasi kode untuk `InputValidator.lua`, `RateLimiter.lua`, `PermissionCore.lua`.
  2.  **Networking Layer:** Implementasi kode untuk `NetworkingRouter.lua`, `NetworkSecurity.lua`, `RemoteBuilder.lua`.
  3.  **UI Layer:** Implementasi kode untuk `UIEngine.lua` (logika Fusion/Native), `UIManager.lua` (logika Topbar+), dan `AssetLoader.lua`.
  4.  **Minimal Module:** Implementasi `MinimalService.lua` dan `MinimalController.lua` (sesuai `201_CONTRIBUTING_MODULE.md`) sebagai _test case_ untuk sistem-sistem ini.

- **Kriteria Sukses (Teknis):**

  1.  `MinimalService` dapat memanggil `self.OVHL:GetSystem("InputValidator")`.
  2.  `MinimalController` dapat memanggil `self.OVHL:GetSystem("UIEngine")`.
  3.  `UIManager` berhasil membuat tombol di Topbar+.

- **Target Play Test (Validasi Modul):**
  1.  Jalankan Play Test.
  2.  **Hasil 1 (UI):** Tombol Topbar+ untuk `MinimalModule` harus muncul. Mengkliknya harus memunculkan UI Fusion dasar.
  3.  **Hasil 2 (Security):** Memanggil remote dari client (misal: tombol "Test Action" di UI) harus berhasil divalidasi oleh 3 pilar (Validator, RateLimiter, PermissionCore) di `MinimalService`. Konsol server harus menunjukkan log "GAME" atau "SECURITY".

---

### Phase 3: Sistem Kritis (Persistence & UX)

Fase ini mengimplementasikan sistem di `Systems/Advanced/` yang dibutuhkan untuk persistensi data dan UX.

- **Tugas Implementasi:**

  1.  **`DataManager` (System):** Buat sistem di `Systems/Advanced/` untuk save/load data (logika DataStore, Serialisasi, Versi). (Lihat `202_CONTRIBUTING_SYSTEM.md`).
  2.  **`PlayerManager` (System):** Buat sistem di `Systems/Advanced/` untuk mendeteksi `PlayerAdded`/`PlayerRemoving` dan memanggil `DataManager:Load/Save`.
  3.  **`NotificationService` (System):** Buat sistem di `Systems/Advanced/` untuk mengelola antrian notifikasi (Toast, Popup) untuk UX & Debugging.
  4.  **`StateManager` (System):** (Opsional) Implementasi sistem state management (Rodux/Redux pattern) di `Systems/Advanced/`.

- **Kriteria Sukses (Teknis):**

  1.  `DataManager` dapat `SetAsync` dan `GetAsync` dari DataStore.
  2.  `PlayerManager` berhasil terhubung ke `Players.PlayerAdded` dan `Players.PlayerRemoving`.
  3.  Sistem lain dapat memanggil `OVHL:GetSystem("NotificationService"):SendToPlayer(player, "Data Loaded")`.

- **Target Play Test (Validasi Data):**
  1.  Aktifkan Studio Access ke API Services (untuk DataStore).
  2.  Join Play Test. **Hasil 1:** Harus menerima notifikasi UI "Data Loaded" (dari `NotificationService`).
  3.  Lakukan aksi (misal: dapat uang) dan tinggalkan Play Test.
  4.  Join kembali Play Test. **Hasil 2:** Uang Anda harus tetap sama (data berhasil di-load ulang oleh `DataManager`).

---

### Phase 4: Modul Gameplay Inti (Knit Services)

Fase ini adalah implementasi **Modul Game (Knit Services)** yang _menggunakan_ sistem dari Fase 1, 2, dan 3.

- **Tugas Implementasi:**

  1.  Buat `EconomyService` (Modul Knit) menggunakan `201_CONTRIBUTING_MODULE.md`. (Membutuhkan `DataManager`).
  2.  Buat `InventoryService` (Modul Knit) menggunakan pola Modul Kompleks (dari `201_CONTRIBUTING_MODULE.md`). (Membutuhkan `DataManager`).
  3.  Buat `QuestService` (Modul Knit). (Membutuhkan `DataManager` dan `Knit.Signal`).

- **Kriteria Sukses (Teknis):**

  1.  `EconomyService` dapat menambah dan mengurangi mata uang yang disimpan oleh `DataManager`.
  2.  `InventoryService` dapat menambahkan item ke tabel data yang dikelola `DataManager`.
  3.  `QuestService` dapat berkomunikasi dengan `InventoryService` (misal: `Knit.GetService("InventoryService")`).

- **Target Play Test (Validasi Gameplay Loop):**
  1.  Jalankan Play Test.
  2.  **Hasil:** Lakukan skenario E2E (End-to-End):
      - Terima quest dari `QuestService`.
      - Bunuh 1 NPC (dapat uang via `EconomyService`).
      - Beli item quest (panggil `InventoryService`).
      - Serahkan quest (panggil `QuestService`).
      - Semua data (uang, item, progres quest) harus tetap ada setelah _rejoin_.

---

### Phase 5: Fitur Tambahan & Polish

Fase ini mencakup sistem pendukung dan modul untuk _quality-of-life_ dan _analytics_.

- **Tugas Implementasi:**

  1.  `LocalizationService` (Sistem): Implementasi sistem translasi I18n.
  2.  `AnalyticsService` (Sistem): Implementasi tracking event & telemetri.
  3.  `DevelopmentTools` (Modul): Buat Modul Knit untuk Debug UI dan dev console.
  4.  `Testing Framework`: Selesaikan semua _unit test_ untuk semua sistem.
  5.  `Adapter Integration`: Implementasi Penuh `103_ARCHITECTURE_ADAPTERS.md` (Integrasi HD Admin, dll).

- **Kriteria Sukses (Teknis):**

  1.  Semua teks UI diambil dari `LocalizationService`.
  2.  Setiap pembelian (`EconomyService`) mengirimkan event ke `AnalyticsService`.
  3.  Semua tes di `tests/` lolos.

- **Target Play Test (Validasi Polish):**
  1.  Ganti bahasa di UI (via `LocalizationService`).
  2.  Buka Debug UI (via `DevelopmentTools`).
  3.  **Hasil:** Game siap untuk rilis Beta.

---

> END OF ./docs/100_ENGINE_GUIDES/104_ROADMAP_BUILD.md
