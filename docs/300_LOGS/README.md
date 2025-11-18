> START OF ./docs/300_LOGS/README.md
>
> **OVHL ENGINE V3.4.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** AI & CORE DEVELOPERS
> **PURPOSE:** Menetapkan format dan penyimpanan log sentral engine.

---

# 📚 300_LOGS.MD (Logging Standards V3.4.0)

## 1. HUKUM LOGGING MONOLITHIC (V3.4.0)

Semua log yang relevan harus dicatat ke dalam **dua file utama** yang terletak di `docs/300_LOGS/`. **Semua folder log sebelumnya harus dihapus.**

| File Log             | Tujuan                                                                                                                                                     | Prioritas Entri                                               |
| :------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------ |
| **`302_ADR_LOG.md`** | Mencatat Keputusan Arsitektural (Architecture Decision Record) yang berdampak besar pada struktur atau stabilitas. **Wajib dirujuk** ke dokumen blueprint. | **Tertinggi** (Reverse Chronological: Terbaru di Paling Atas) |
| **`301_DEV_LOG.md`** | Mencatat sesi kerja penting (Refaktor besar, Perbaikan _Crash_ Kritis, Implementasi Fitur Baru).                                                           | **Tinggi** (Reverse Chronological: Terbaru di Paling Atas)    |

### ⚠️ Mandat: Reverse Chronological Order

Setiap entri log baru **WAJIB** ditambahkan di bagian **paling atas** dari file tersebut.

## 2. FORMAT LOG

### Format ADR_LOG (`302_ADR_LOG.md`)

```markdown
# 📢 [TANGGAL YYYY-MM-DD] Keputusan ADR-[NOMOR] - [JUDUL KEPUTUSAN]

**TANGGAL KEPUTUSAN:** [Tanggal Lengkap]
**KONTEKS:** [Masalah yang ingin dipecahkan]
**STATUS:** [DITETAPKAN/DITOLAK/DIGANTIKAN]

**KEPUTUSAN (ADR-XXX):** [Ringkasan Keputusan]

**ALASAN / KONTEKS:**
[Alasan detail mengapa keputusan ini dipilih.]

**DAMPAK (IMPACT):**
[File apa saja yang terkena dampak, bagaimana alur kerjanya berubah.]

**REFERENSI DOKUMEN BLUEPRINT:**
[Daftar file yang telah diperbarui sesuai Hukum #13 (ADR Integration Rule).]
```

### Format DEV_LOG (`301_DEV_LOG.md`)

```markdown
# 🛠️ [TANGGAL YYYY-MM-DD] Sesi Kerja - [JUDUL SINGKAT]

**TANGGAL SESI:** [Tanggal Lengkap]
**TUJUAN:** [Tujuan sesi kerja (misal: Fix Crash DataManager)]
**STATUS:** [SELESAI/DIBATALKAN/DALAM PROGRES]

**FILE YANG DIUBAH / DIBUAT:**

- [File 1]
- [File 2]

**MASALAH (Problem) & SOLUSI:**

- **Problem:** [Masalah]
- **Root Cause:** [Akar masalah]
- **Solusi:** [Bagaimana masalah diperbaiki]
```

---

> END OF ./docs/300_LOGS/README.md
