> START OF ./docs/300_LOGS/README.md

- **OVHL ENGINE V3.1.0** > **STATUS:** FINAL & AUTHORITATIVE
- **AUDIENCE:** TIM INTI, AI
- **PURPOSE:** Menyediakan template standar untuk `DEV_LOG` dan `ADR_LOG` (Sesuai Mandat Logging #4 di `00_AI_WORKFLOW_GUIDE.md`).

---

# 📈 300_LOGS: Template Logging

Gunakan template di bawah ini untuk semua entri log baru.

---

## 1. TEMPLATE: DEV_LOG (Progres Fitur/Bug)

Gunakan ini di folder `301_DEV_LOG/` untuk melacak progres harian, bug, dan penyelesaian fitur.

```markdown
**TANGGAL:** YYYY-MM-DD, HH:MM
**KONTEKS:** [Apa yang sedang dikerjakan? Misal: "Refactor UIManager Adapter"]
**STATUS:** [STUCK / SELESAI / GAGAL / INVESTIGASI]

**TUJUAN:**
[Tujuan dari sesi kerja ini.]

**FILE YANG DIUBAH / DIBUAT / DIHAPUS:**

- `src/path/to/file.lua` (Alasan: ...)

**HASIL ITERASI / KEPUTUSAN:**

- [Poin 1 progres]
- [Poin 2 progres]

**MASALAH (JIKA ADA):**

- **Problem:** [Deskripsi masalah]
- **Root Cause:** [Analisis penyebab]
- **Solusi:** [Bagaimana menyelesaikannya]

**PELAJARAN (UNTUK AI/DEV BERIKUTNYA):**

- **BOLEH:** [Pola yang harus diikuti]
- **TIDAK BOLEH:** [Pola yang harus dihindari]
```

## 2. TEMPLATE: ADR_LOG (Keputusan Arsitektur)

Gunakan ini di folder `302_ADR_LOG/` untuk mencatat keputusan arsitektur yang penting dan permanen.

```Markdown
**TANGGAL:** YYYY-MM-DD, HH:MM
**KONTEKS:** [Keputusan arsitektur apa? Misal: "Pemilihan Pola Adapter vs Hardcoded"]
**STATUS:** [DITETAPKAN / DIPERTIMBANGKAN]

**KEPUTUSAN (ADR-XXX):**
[Keputusan final yang diambil.]

**ALASAN / KONTEKS:**

- [Mengapa keputusan ini diambil?]
- [Alternatif apa yang ditolak dan mengapa?]

**DAMPAK (IMPACT):**

- [Bagaimana ini mempengaruhi `101_GENESIS_ARCHITECTURE.md`?]
- [Sistem apa yang harus di-refactor?]

**PELAJARAN (UNTUK AI/DEV BERIKUTNYA):**

- **BOLEH:** [Pola baru yang harus diikuti]
- **TIDAK BOLEH:** [Pola lama yang sekarang dilarang]
```

> END OF ./docs/300_LOGS/README.md
