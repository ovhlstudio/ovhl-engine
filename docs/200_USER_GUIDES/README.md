> START OF ./docs/200_USER_GUIDES/README.md
>
> **OVHL ENGINE V1.0.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** GAMEPLAY PROGRAMMERS, USERS, DEVELOPERS
> **PURPOSE:** Pintu gerbang untuk panduan "Cara Menggunakan" dan "Cara Berkontribusi" ke OVHL Engine.

---

# 📖 200_USER_GUIDES: User & Contributor Documentation

Folder ini berisi **SEMUA panduan praktis** untuk menggunakan atau berkontribusi ke OVHL Engine.

**Audience:** Gameplay programmers, game developers, contributors  
**Purpose:** "Bagaimana cara membuat fitur?" + "Bagaimana cara pakai system ini?"  
**Not for:** Engine architects (gunakan `100_ENGINE_GUIDES/` untuk itu)

---

## 🎯 QUICK START BY TASK

### **"Saya ingin membuat fitur gameplay baru (Shop, Inventory, Quest)"**

**Path:** `201_CONTRIBUTING_MODULE.md`

**What you'll learn:**

- 3-Config pattern (SharedConfig, ServerConfig, ClientConfig)
- Knit Service/Controller structure
- Security pipeline (3-pilar validation)
- UI setup dengan Fusion
- Networking dengan Knit
- Testing + deployment

**Start here:** Copy `MinimalModule` dan follow template di `201_CONTRIBUTING_MODULE.md`

---

### **"Saya ingin membuat sistem engine baru (Logger, DataManager, dll)"**

**Path:** `202_CONTRIBUTING_SYSTEM.md`

**What you'll learn:**

- 4-Phase Lifecycle (Initialize, Register, Start, Destroy)
- Manifest system + dependencies
- SystemRegistry orchestration
- Best practices untuk system design
- Troubleshooting common issues

**Start here:** Follow step-by-step contoh SoundManager di `202_CONTRIBUTING_SYSTEM.md`

---

### **"Saya ingin tahu cara pakai SmartLogger, UIEngine, DataManager, dll"**

**Path:** `210_API_REFERENCE/`

**What's there:**

- `211_LOGGER.md` - SmartLogger API
- `212_PERMISSION.md` - PermissionCore API
- `213_VALIDATOR.md` - InputValidator API
- `214_UI_ENGINE.md` - UIEngine API
- `215_RATE_LIMITER.md` - RateLimiter API
- `216_NETWORKING.md` - NetworkingRouter API
- `217_UI_MANAGER.md` - UIManager API
- `218_ASSET_LOADER.md` - AssetLoader API

**Start here:** Buka `210_API_REFERENCE/README.md` untuk index lengkap

---

### **"Saya ingin understand architecture + hukum dasar engine"**

**Path:** `100_ENGINE_GUIDES/` (bukan 200_USER_GUIDES)

**See:** `100_ENGINE_GUIDES/README.md` untuk engine architect docs

---

## 📂 FOLDER STRUCTURE

```
200_USER_GUIDES/
├── README.md                          ← You are here
├── 201_CONTRIBUTING_MODULE.md         ← How to create modules
├── 202_CONTRIBUTING_SYSTEM.md         ← How to create systems
└── 210_API_REFERENCE/
    ├── README.md                      ← API reference index
    ├── 211_LOGGER.md                  ✅ DONE
    ├── 212_PERMISSION.md              ✅ DONE
    ├── 213_VALIDATOR.md               ✅ DONE
    ├── 214_UI_ENGINE.md               ✅ DONE
    ├── 215_RATE_LIMITER.md            ✅ DONE
    ├── 216_NETWORKING.md              ✅ DONE
    ├── 217_UI_MANAGER.md              ✅ DONE
    ├── 218_ASSET_LOADER.md            ✅ DONE
    ├── 219_DATA_MANAGER.md            ⏳ PLANNED
    ├── 220_PLAYER_MANAGER.md          ⏳ PLANNED
    └── 221_NOTIFICATION_SERVICE.md    ⏳ PLANNED
```

---

## 📚 DOCUMENTATION BY ROLE

### **Role: Gameplay Programmer**

(Membuat fitur gameplay untuk game)

**Read in order:**

1. **Start:** `201_CONTRIBUTING_MODULE.md` - Buat module baru
2. **Reference:** `210_API_REFERENCE/README.md` - Lookup system APIs
3. **Deep dive:** `210_API_REFERENCE/211_LOGGER.md`, `213_VALIDATOR.md`, `215_RATE_LIMITER.md`, etc sesuai kebutuhan

**Typical workflow:**

```
1. Baca 201_CONTRIBUTING_MODULE.md
2. Copy MinimalModule
3. Buat SharedConfig.lua (kontrak + schema)
4. Buat Service.lua (security pipeline + logic)
5. Buat Controller.lua (UI + networking)
6. Test di studio
7. Refer API docs jika butuh system tertentu
```

---

### **Role: Engine Contributor**

(Menambah sistem ke engine)

**Read in order:**

1. **Prerequisites:** `100_ENGINE_GUIDES/101_GENESIS_ARCHITECTURE.md` - Pahami hukum dasar
2. **Deep dive:** `100_ENGINE_GUIDES/102_CORE_MECHANICS.md` - Understand lifecycle
3. **Technical guide:** `202_CONTRIBUTING_SYSTEM.md` - Implementasi system baru

**Typical workflow:**

```
1. Baca 100_ENGINE_GUIDES/101_GENESIS_ARCHITECTURE.md (hukum)
2. Baca 100_ENGINE_GUIDES/102_CORE_MECHANICS.md (technical)
3. Baca 202_CONTRIBUTING_SYSTEM.md (step-by-step)
4. Implement system + manifest
5. Test di studio
6. Write API reference doc
7. Submit untuk code review
```

---

### **Role: API User / Reference**

(Cukup pakai system, tidak bikin baru)

**Read:**

- `210_API_REFERENCE/README.md` - Cari system yang dibutuhkan
- Specific API file (misal: `211_LOGGER.md`)

**Typical workflow:**

```
1. Tau lu butuh apa system? Cari di 210_API_REFERENCE/README.md
2. Buka doc sistem itu
3. Copy-paste example code
4. Adjust untuk kebutuhan lu
```

---

## 📖 DETAILED GUIDE OVERVIEW

### **201_CONTRIBUTING_MODULE.md** - Membuat Module Gameplay

| Aspek            | Detail                                    |
| ---------------- | ----------------------------------------- |
| **Length**       | ~4000 words                               |
| **Difficulty**   | Medium                                    |
| **Time to read** | 30 min                                    |
| **When to use**  | Bikin fitur baru (Shop, Inventory, Quest) |
| **Contains**     | Complete examples + checklist             |

**Highlights:**

- 3-Config pattern explained
- Complete example: InventoryModule (Service + Controller + Configs)
- Facade pattern untuk module besar
- Security checklist
- FAQ

---

### **202_CONTRIBUTING_SYSTEM.md** - Membuat System Engine

| Aspek            | Detail                             |
| ---------------- | ---------------------------------- |
| **Length**       | ~3500 words                        |
| **Difficulty**   | Hard                               |
| **Time to read** | 45 min                             |
| **When to use**  | Tambah teknologi ke engine         |
| **Contains**     | Step-by-step + examples + patterns |

**Highlights:**

- 4-Phase lifecycle detailed
- Step-by-step: SoundManager example
- Advanced patterns (dependencies, background tasks, etc)
- Troubleshooting guide
- Validation checklist

---

### **210_API_REFERENCE/** - System API Reference

| Aspek               | Detail                                  |
| ------------------- | --------------------------------------- |
| **Files**           | 8 DONE + 4 PLANNED                      |
| **Length per file** | ~1500-2000 words                        |
| **Difficulty**      | Easy (reference)                        |
| **Time to read**    | 10-15 min per file                      |
| **When to use**     | Lookup system API                       |
| **Contains**        | API methods + examples + best practices |

**Highlights:**

- Quick start code
- All public methods documented
- Real-world examples
- Best practices + FAQ

---

## 🎯 COMMON SCENARIOS & PATHS

### **Scenario 1: "Gua developer baru, ga tahu mulai dari mana"**

**Path:**

```
1. Baca: 201_CONTRIBUTING_MODULE.md (full)
2. Copy: MinimalModule
3. Rename + modify
4. Test di studio
5. Refer: 210_API_REFERENCE/* saat butuh system
```

**Time:** 2-3 jam untuk understand + bikin module pertama

---

### **Scenario 2: "Gua sudah tau bikin module, tapi butuh pake system baru"**

**Path:**

```
1. Buka: 210_API_REFERENCE/README.md
2. Cari: System yang butuh
3. Baca: Specific API doc
4. Copy-paste: Example code
5. Adjust: Untuk kebutuhan lu
```

**Time:** 10-20 min (lookup + usage)

---

### **Scenario 3: "Engine kayaknya butuh fitur baru (misal: SoundManager)"**

**Path:**

```
1. Baca: 100_ENGINE_GUIDES/101_GENESIS_ARCHITECTURE.md (hukum)
2. Baca: 100_ENGINE_GUIDES/102_CORE_MECHANICS.md (lifecycle)
3. Baca: 202_CONTRIBUTING_SYSTEM.md (step-by-step)
4. Implement: SoundManager (follow example)
5. Test: Di studio
6. Document: Buat API reference
7. Submit: PR / for review
```

**Time:** 4-6 jam (design + implement + test + doc)

---

### **Scenario 4: "Ada bug di module / system, gimana debug?"**

**Path:**

```
1. Baca: 100_ENGINE_GUIDES/102_CORE_MECHANICS.md (data flow + lifecycle)
2. Enable: Logger DEBUG mode (EngineConfig.lua)
3. Trace: Log output saat reproduce bug
4. Locate: Mana error terjadi
5. Fix: Implement fix
6. Test: Verify bug gone
```

**Time:** Depends on bug complexity

---

## 📋 DOCUMENTATION CHECKLIST (untuk contributors)

Jika lu bikin module atau system baru, ensure:

- [ ] Code lengkap + teruji di studio
- [ ] SharedConfig.lua atau Manifest.lua sesuai pattern
- [ ] 3-pilar security pipeline (module) atau manifest (system)
- [ ] Code headers/footers V1.0.0
- [ ] No placeholder / TODOs
- [ ] Minimal 1 test atau playtest proof
- [ ] Update relevant docs (atau PR untuk docs)
- [ ] Related docs linked properly

---

## 🔗 CROSS-REFERENCES

### **From this folder to:**

- **Engine Architecture:** `100_ENGINE_GUIDES/README.md`
- **AI Workflow:** `00_AI_WORKFLOW_GUIDE.md`
- **Logs:** `300_LOGS/301_DEV_LOG.md` (for tracking progress)

### **To this folder from:**

- **Engine guides refer here:** For implementation details
- **AI uses this:** For coding reference

---

## ✅ VERSION HISTORY

- **V1.0.0** (2025-11-18): Initial release, 8/12 API docs complete
- **V1.1.0 (Planned):** Add missing API docs (DataManager, PlayerManager, NotificationService)
- **V1.2.0 (Planned):** Add advanced guides (Testing, Performance tuning, etc)
- **V2.0.0 (Future):** Complete rewrite if major architecture changes

---

## 🤝 HOW TO CONTRIBUTE DOCUMENTATION

Jika ingin improve atau add docs:

1. **Bugfix:** If ada typo/error, buat fix langsung
2. **New API doc:** Follow `210_API_REFERENCE/` template
3. **New guide:** Align dengan existing docs structure
4. **Major changes:** Discuss dengan team terlebih dahulu

**Template for new API doc:**

```markdown
> START OF ./docs/200_USER_GUIDES/210_API_REFERENCE/2XX_SYSTEM_NAME.md
> **OVHL ENGINE V1.0.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** GAMEPLAY PROGRAMMERS
> **PURPOSE:** [One sentence]

# System Name Guide

## Quick Start

[Copy-paste example]

## API Reference

[All methods documented]

## Usage Examples

[Real-world scenarios]

## Best Practices

[Dos and don'ts]

## FAQ

[Common questions]

> END OF ./docs/200_USER_GUIDES/210_API_REFERENCE/2XX_SYSTEM_NAME.md
```

---

> END OF ./docs/200_USER_GUIDES/README.md
