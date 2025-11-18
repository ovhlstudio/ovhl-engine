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
