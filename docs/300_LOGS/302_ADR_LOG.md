> START OF ./docs/300_LOGS/302_ADR_LOG.md
>
> **OVHL ENGINE V3.4.0** > **STATUS:** MONOLITHIC LOGGING
> **AUDIENCE:** AI & CORE DEVELOPERS
> **PURPOSE:** Arsip Keputusan Arsitektural.

# 302. Architecture Decision Record (ADR)

# 📢 [2025-11-18] Keputusan ADR-004 - Full System Lifecycle (4-Fase)

**TANGGAL KEPUTUSAN:** 2025-11-18, 12:00
**KONTEKS:** Arsitektur V3.3.0 (Two-Phase Init) gagal menangani _race condition_ resolusi dependensi dan mengabaikan _memory leak_ saat shutdown.
**STATUS:** DITETAPKAN

**KEPUTUSAN (ADR-004): Mengadopsi "Full System Lifecycle" 4-Fase yang diatur oleh `SystemRegistry.lua`.**

**Alur Fase:**

1. **Initialize:** Konstruksi objek & `logger`. (Dilarang `GetSystem` atau `Connect`)
2. **Register:** Sistem terdaftar ke _gateway_ `OVHL`. (Otomatis)
3. **Start:** Resolusi dependensi (`OVHL:GetSystem()`) dan Aktivasi (`Connect()`, `task.spawn()`).
4. **Destroy:** Cleanup _event_ dan _loop_ secara terbalik (dipicu `BindToClose()`).

**ALASAN / KONTEKS:**
Model V3.3.0 menyebabkan _race condition_ yang mematikan (`DataManager` gagal ditemukan oleh `PlayerManager` di Fase 1). Model 4-Fase menjamin `OVHL:GetSystem()` aman di Fase 3 (`Start`), menyelesaikan _crash_ dan secara paksa menambahkan fase `Destroy` untuk _memory leak cleanup_ (RateLimiter, PlayerManager).

**DAMPAK (IMPACT):**

- `SystemRegistry.lua` (Refaktor total).
- `PlayerManager.lua` (Perbaikan _crash_ dan _leak_).
- `RateLimiter.lua` (Perbaikan _leak_).
- **Semua sistem aktif** wajib memiliki fungsi `:Destroy()`.

**REFERENSI DOKUMEN BLUEPRINT:**

- `docs/100_ENGINE_GUIDES/102_CORE_MECHANICS.md` (Diperbarui)
- `docs/200_USER_GUIDES/202_CONTRIBUTING_SYSTEM.md` (Diperbarui)
- `docs/100_ENGINE_GUIDES/101_GENESIS_ARCHITECTURE.md` (Diperbarui, Hukum ADR Integration)

---

## 🏛️ 302_ADR_LOG (Keputusan Arsitektur Saat Ini)

**TANGGAL:** 2025-11-18, 11:29 **KONTEKS:** Evolusi Arsitektur Booting Engine (V3.1.0 -> V3.3.0) **STATUS:** DITETAPKAN (V3.3.0 Belum Diimplementasi)

**KEPUTUSAN (ADR-001): V3.1.0 (Manual) Ditolak.**

- **Alasan:** Arsitektur V3.1.0 (manual `systemDependencies` di `Bootstrap.lua`) tidak _scalable_ dan melanggar Prinsip _Open/Closed_.

**KEPUTUSAN (ADR-002): V3.2.2 (Sibling Manifest) Diadopsi.**

- **Alasan:** Arsitektur V3.2.2 (menggunakan `*Manifest.lua` dan _scanner_ V3.2.3 _environment-aware_ di `Bootstrap.lua`) adalah cara paling _robust_ dan _Rojo-compatible_ untuk _discovery_ sistem.

- **Status:** **SEBAGIAN DIIMPLEMENTASIKAN** (File `*Manifest.lua` sudah ada, _scanner_ V3.2.3 sudah ada).

**KEPUTUSAN (ADR-003): V3.3.0 (Two-Phase Init) Diadopsi (KRITIS).**

- **Alasan:** Arsitektur V3.2.2 (dengan satu fase `:Initialize()`) terbukti **CACAT** dan menyebabkan _race condition_.

- **Implementasi:** `SystemRegistry.lua` **HARUS DI-REFACTOR** untuk memisahkan inisialisasi menjadi dua fase: `:Initialize()` (untuk konstruksi/referensi) dan `:Start()` (untuk aktivasi/koneksi).

- **Status:** **BELUM DIIMPLEMENTASIKAN.** (Ini adalah TUGAS ANDA).

---

> END OF ./docs/300_LOGS/302_ADR_LOG.md
