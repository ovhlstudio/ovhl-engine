> START OF ./docs/100_ENGINE_GUIDES/README.md
>
> **OVHL ENGINE V1.0.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** ENGINE ARCHITECTS, CORE DEVELOPERS, AI
> **PURPOSE:** Index dan navigation guide untuk semua engine architecture docs.

---

# 📚 100_ENGINE_GUIDES: Engine Architecture Documentation

Folder ini berisi **BLUEPRINT & DEEP DIVE** dokumentasi untuk OVHL Engine V1.0.0.

**Audience:** Engine engineers, AI architects, core developers  
**Purpose:** Understand _why_ dan _how_ engine dibangun seperti ini  
**Not for:** Gameplay programmers (gunakan `200_USER_GUIDES/` untuk itu)

---

## 📂 Daftar Dokumen

### **101_GENESIS_ARCHITECTURE.md** - The Core Law

**Purpose:** Definisi 12 hukum dasar engine yang absolut dan abadi.

**Isi:**

- The 12 Commandments (hukum dasar engine)
- Directory structure V1.0.0
- Technology stack
- 4-Phase lifecycle overview
- Security pipeline (3 pilar)
- Module pattern golden standard
- Error handling strategy
- Performance budget
- Testing strategy
- Documentation standards

**Gunakan untuk:**

- Memahami filosofi & constraints engine
- Refer saat coding untuk ensure tidak violate hukum
- Design pattern baru (must conform ke 12 commandments)

**Related:** `00_AI_WORKFLOW_GUIDE.md` (mandat AI), `102_CORE_MECHANICS.md` (technical deep dive)

---

### **102_CORE_MECHANICS.md** - Deep Technical Dive

**Purpose:** Menjelaskan detail teknis bagaimana engine bekerja secara internal.

**Isi:**

- 4-Phase lifecycle detailed explanation (dengan constraints per fase)
- Boot sequence step-by-step (dengan flowchart)
- Data flow & security pipeline (dengan diagram ASCII)
- Client → Server request flow
- UI rendering pipeline (Fusion scoped)
- Manifest system & environment awareness
- Error scenarios & recovery
- Performance implications
- Debugging & monitoring APIs

**Gunakan untuk:**

- Debug engine issues (race condition, lifecycle problems)
- Understand flow data saat development
- Tune performance
- Add new systems yang patuh lifecycle
- Monitor health saat runtime

**Related:** `101_GENESIS_ARCHITECTURE.md` (hukum), `202_CONTRIBUTING_SYSTEM.md` (how to create system)

---

### **104_ROADMAP_BUILD.md** - Implementation Reference

**Purpose:** Peta implementasi OVHL V1.0.0 dari scratch, plus roadmap V1.1.0+.

**Isi:**

- Status V1.0.0 (semua completed systems)
- Phase history (Phase 0-4 yang sudah done)
- Phase 5-10 planned (V1.1.0 sampai V2.0.0)
- Detailed implementation plans per phase
- Timeline + effort estimates
- Dependencies antar phase
- Next immediate actions

**Gunakan untuk:**

- Reference: bagaimana membangun engine dari nol
- Plan: fitur apa yg akan datang
- Estimate: berapa effort untuk task
- Prioritize: mana yang urgent, mana yang future

**Related:** `101_GENESIS_ARCHITECTURE.md` (constraints), `104_ROADMAP_BUILD.md` (future phases)

---

## 🎯 Quick Navigation by Task

### **"Saya ingin memahami filosofi engine"**

→ Baca: **101_GENESIS_ARCHITECTURE.md** (full) → **102_CORE_MECHANICS.md** (boot section)

### **"Saya ingin debug race condition / lifecycle issue"**

→ Baca: **102_CORE_MECHANICS.md** (4-Phase section) → `202_CONTRIBUTING_SYSTEM.md` (how to fix)

### **"Saya ingin membuat system baru"**

→ Baca: **101_GENESIS_ARCHITECTURE.md** (hukum) → **102_CORE_MECHANICS.md** (lifecycle) → `202_CONTRIBUTING_SYSTEM.md` (step-by-step)

### **"Saya ingin understand data flow"**

→ Baca: **102_CORE_MECHANICS.md** (section 2 & 3: Data Flow + UI Pipeline)

### **"Saya ingin plan roadmap / estimate features"**

→ Baca: **104_ROADMAP_BUILD.md** (full)

### **"Saya AI yang ingin maintain engine"**

→ Baca: **101_GENESIS_ARCHITECTURE.md** (hukum) → **00_AI_WORKFLOW_GUIDE.md** (mandat) → **102_CORE_MECHANICS.md** (technical)

---

## 📖 Reading Order by Role

### **New Engine Engineer**

1. **101_GENESIS_ARCHITECTURE.md** - Understand the 12 laws
2. **102_CORE_MECHANICS.md** - See how it works
3. **104_ROADMAP_BUILD.md** - Understand history + future
4. **`202_CONTRIBUTING_SYSTEM.md`** - Start contributing

### **Core Developer (Maintenance Mode)**

1. **102_CORE_MECHANICS.md** - Debug & monitor
2. **101_GENESIS_ARCHITECTURE.md** - Refer hukum saat design
3. **104_ROADMAP_BUILD.md** - Plan next features

### **AI Principal Architect**

1. **00_AI_WORKFLOW_GUIDE.md** - Mandat AI
2. **101_GENESIS_ARCHITECTURE.md** - Hukum dasar
3. **102_CORE_MECHANICS.md** - Technical reference
4. **`202_CONTRIBUTING_SYSTEM.md`** - Implementation guide

---

## 🔍 Document Summary Table

| Document          | Focus                    | Length      | Difficulty | Update Freq                       |
| ----------------- | ------------------------ | ----------- | ---------- | --------------------------------- |
| **101_GENESIS**   | Philosophy + Laws        | ~4000 words | Medium     | Rare (only if laws change)        |
| **102_MECHANICS** | Technical deep dive      | ~5000 words | Hard       | Rare (only if lifecycle changes)  |
| **104_ROADMAP**   | Implementation reference | ~3500 words | Medium     | Per release (V1.1.0, V1.2.0, etc) |

---

## ✅ Version History

- **V1.0.0** (2025-11-18): Initial release, V1.0.0 complete
- **V1.1.0 (Planned):** Update dengan adapter pattern + networking complete
- **V1.2.0 (Planned):** Update dengan performance optimization
- **V2.0.0 (Future):** Major revision dengan new architecture

---

## 🤝 Contributing to Architecture Docs

Jika ada perubahan architecture:

1. **Update `101_GENESIS_ARCHITECTURE.md`** jika berubah hukum dasar
2. **Update `102_CORE_MECHANICS.md`** jika berubah lifecycle/flow
3. **Update `104_ROADMAP_BUILD.md`** saat ada phase baru atau timeline change
4. **Log di `302_ADR_LOG.md`** untuk major decisions
5. **Sync dengan `00_AI_WORKFLOW_GUIDE.md`** jika workflow berubah

---

> END OF ./docs/100_ENGINE_GUIDES/README.md
