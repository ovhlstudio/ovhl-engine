# 📚 CATATAN SERAH TERIMA (HAND-OFF) ARSITEK

**UNTUK DIBACA OLEH AI/DEVELOPER BERIKUTNYA:**

_Engine_ ini sedang dalam proses transisi arsitektur besar (dari V3.1.0 ke V3.3.0). Transisi ini **GAGAL** di tengah jalan, menyebabkan _engine_ berada dalam kondisi **STUCK** dan **TIDAK STABIL**.

Log _crash_ terbaru (`11:27:39.023`) adalah buktinya.

Tugas Anda adalah menyelesaikan refaktor yang gagal ini.

---

## 📈 301_DEV_LOG (Status Proyek Saat Ini)

**TANGGAL:** 2025-11-18, 11:29 **KONTEKS:** Kegagalan Kritis Selama Refactor Arsitektur Booting (V3.1.0 -> V3.3.0) **STATUS:** 🔴 **STUCK (KRITIS)**

**TUJUAN (YANG GAGAL):** Meng-upgrade _boot system_ dari V3.1.0 (Manual `Bootstrap.lua`) ke V3.2.2 (_Sibling Manifest_ `*Manifest.lua`) dan mengimplementasikan Sistem Phase 3 (`DataManager`, `PlayerManager`).

**MASALAH (Problem):** _Engine_ **CRASH** saat _runtime_ (saat pemain bergabung).

**MASALAH (Root Cause):** **RACE CONDITION.**

1.  Arsitektur `SystemRegistry` V3.2.2 memanggil `:Initialize()` secara berurutan.

2.  `PlayerManager:Initialize()` (dari _patch_ V3.2.6) segera menjalankan _looping_ untuk _Studio testing_ (baris 52) dan menghubungkan _event_ `Players.PlayerAdded`.

3.  Tindakan ini memicu `_onPlayerAdded`, yang memanggil `_dataManager:LoadData()`.

4.  Semua ini terjadi **SEBELUM** `DataManager:Initialize()` (yang dipanggil _sebelumnya_ oleh `SystemRegistry`) selesai terhubung ke DataStore.

5.  Hasilnya adalah log `[DATAMANAGER] LoadData called before Initialize!`, yang menyebabkan _crash_ `nil` atau data gagal di-load.

**MASALAH (Solusi Gagal):** _Patch_ V3.2.6 (dari Claude) mencoba memperbaiki ini dengan `task.wait(0.1)`. Ini adalah **HACK** non-deterministik dan **TIDAK BISA DITERIMA** (sesuai **Mandat Anti-Hack #5**).

**PELAJARAN (UNTUK AI/DEV BERIKUTNYA):**

1.  **TUGAS ANDA:** Anda harus mengimplementasikan **ADR-003 (Two-Phase Initialization)** yang dijelaskan di bawah ini. Ini adalah satu-satunya solusi arsitektural yang benar.

2.  `TIDAK BOLEH:` Jangan buang waktu lagi dengan _hotfix_ V3.2.x. Jangan gunakan `task.wait()` untuk "memperbaiki" _race condition_.

3.  `WAJIB:` Refactor `SystemRegistry.lua` untuk memiliki dua _pass_ (putaran):

    - **Fase 1 (Initialize):** Panggil `:Initialize()` di _semua_ sistem (hanya untuk `.new()` dan mendapatkan referensi).

    - **Fase 2 (Start):** Panggil `:Start()` di _semua_ sistem (untuk menghubungkan _event_, _looping_, dan koneksi eksternal seperti DataStore).

4.  `WAJIB:` Refactor semua sistem yang "aktif" (seperti `DataManager`, `PlayerManager`, `NetworkingRouter`, `RateLimiter`) untuk memindahkan logika aktivasi mereka dari `:Initialize()` ke fungsi `:Start()` yang baru.

5.  **PERINGATAN DOKUMENTASI:** SSoT (Semua file di `docs/`) **USANG**. SSoT saat ini **TIDAK** mencerminkan arsitektur V3.2.2 (Manifest) atau V3.3.0 (Two-Phase) yang dibutuhkan. **Setelah** _engine_ stabil, Anda **WAJIB** memperbarui `101_GENESIS_ARCHITECTURE.md`, `102_CORE_MECHANICS.md`, dan `202_CONTRIBUTING_SYSTEM.md` agar sesuai dengan arsitektur V3.3.0 yang baru.
