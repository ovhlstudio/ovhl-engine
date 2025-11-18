> START OF ./docs/README.md
>
> **OVHL ENGINE V1.0.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** ALL (Entry point)
> **PURPOSE:** Main navigation hub untuk semua dokumentasi OVHL Engine V1.0.0.

---

# 📚 OVHL ENGINE V1.0.0 - DOCUMENTATION HUB

Selamat datang di dokumentasi **OVHL Engine V1.0.0**.

Engine ini adalah framework Roblox yang menyediakan **infrastructure inti** untuk game development yang terstruktur, scalable, dan maintainable.

**Current Version:** V1.0.0 (Stable Release)  
**Last Updated:** 2025-11-18  
**Status:** Production Ready ✅

---

## 🚀 QUICK START - PILIH ROLE LU

### **👨‍💻 Saya Developer Gameplay (Bikin Fitur)**

**Start:** `docs/200_USER_GUIDES/201_CONTRIBUTING_MODULE.md`

```
Tujuan: Membuat fitur gameplay baru (Shop, Inventory, Quest, dll)
Time: 2-3 jam untuk module pertama
Path: 201_CONTRIBUTING_MODULE.md → copy MinimalModule → modify → test
```

**Yang lu pelajari:**

- 3-Config pattern (SharedConfig, ServerConfig, ClientConfig)
- Knit Service/Controller structure
- 3-pilar security pipeline
- UI setup dengan Fusion
- Testing + deployment

---

### **⚙️ Saya Engine Engineer (Tambahin Sistem)**

**Start:** `docs/100_ENGINE_GUIDES/101_GENESIS_ARCHITECTURE.md`

```
Tujuan: Membangun sistem engine baru (Logger, DataManager, SoundManager, dll)
Time: 4-6 jam untuk system lengkap (implement + test + doc)
Path: 101_GENESIS → 102_CORE_MECHANICS → 202_CONTRIBUTING_SYSTEM → implement
```

**Yang lu pelajari:**

- 12 Hukum Dasar Engine
- 4-Phase Lifecycle (Initialize, Register, Start, Destroy)
- SystemRegistry orchestration
- Dependency management
- Best practices

---

### **🔍 Saya Lookup API Reference (Pakai System)**

**Start:** `docs/200_USER_GUIDES/210_API_REFERENCE/README.md`

```
Tujuan: Tahu cara pakai system tertentu (Logger, UIEngine, DataManager, dll)
Time: 10-20 min per system
Path: Quick lookup di 210_API_REFERENCE/README.md → baca specific doc
```

**Available APIs (V1.0.0):**

- SmartLogger (`211_LOGGER.md`)
- PermissionCore (`212_PERMISSION.md`)
- InputValidator (`213_VALIDATOR.md`)
- UIEngine (`214_UI_ENGINE.md`)
- RateLimiter (`215_RATE_LIMITER.md`)
- NetworkingRouter (`216_NETWORKING.md`)
- UIManager (`217_UI_MANAGER.md`)
- AssetLoader (`218_ASSET_LOADER.md`)

---

### **🤖 Saya AI Architect / Principal**

**Start:** `docs/00_AI_WORKFLOW_GUIDE.md`

```
Tujuan: Understand workflow + mandat saat maintain/develop engine
Time: 30 min untuk read standards
Path: 00_AI_WORKFLOW_GUIDE → 101_GENESIS_ARCHITECTURE → reference as needed
```

**Key Mandates:**

- Anti-stale (always validate snapshot)
- Pre-flight checklist (before complex tasks)
- Anti-hack (no temporary workarounds)
- 4-Phase lifecycle compliance
- Documentation first

---

## 📂 FOLDER STRUCTURE

```
docs/
├── README.md                          ← You are here (MAIN ENTRY)
├── 00_AI_WORKFLOW_GUIDE.md            ✅ V1.0.0 (AI mandates + workflow)
│
├── 100_ENGINE_GUIDES/                 ✅ Engine architecture docs
│   ├── README.md                      (Index)
│   ├── 101_GENESIS_ARCHITECTURE.md    (12 Commandments)
│   ├── 102_CORE_MECHANICS.md          (Technical deep dive)
│   └── 104_ROADMAP_BUILD.md           (Implementation reference)
│
├── 200_USER_GUIDES/                   ✅ User & contributor docs
│   ├── README.md                      (Index)
│   ├── 201_CONTRIBUTING_MODULE.md     (How to make modules)
│   ├── 202_CONTRIBUTING_SYSTEM.md     (How to make systems)
│   └── 210_API_REFERENCE/             (API docs per system)
│       ├── README.md                  (API index)
│       ├── 211_LOGGER.md              ✅
│       ├── 212_PERMISSION.md          ✅
│       ├── 213_VALIDATOR.md           ✅
│       ├── 214_UI_ENGINE.md           ✅
│       ├── 215_RATE_LIMITER.md        ✅
│       ├── 216_NETWORKING.md          ✅
│       ├── 217_UI_MANAGER.md          ✅
│       ├── 218_ASSET_LOADER.md        ✅
│       ├── 219_DATA_MANAGER.md        ⏳ PLANNED
│       ├── 220_PLAYER_MANAGER.md      ⏳ PLANNED
│       └── 221_NOTIFICATION_SERVICE.md ⏳ PLANNED
│
└── 300_LOGS/                          📝 Development tracking
    ├── README.md                      (Logging standards)
    ├── 301_DEV_LOG.md                 (Session notes)
    └── 302_ADR_LOG.md                 (Architecture decisions)
```

---

## 📖 DOCUMENTATION BY FOLDER

### **`100_ENGINE_GUIDES/` - Engine Architecture**

| Doc                             | Purpose                  | Audience         | Read Time |
| ------------------------------- | ------------------------ | ---------------- | --------- |
| **101_GENESIS_ARCHITECTURE.md** | 12 Hukum + Blueprint     | Engine engineers | 30 min    |
| **102_CORE_MECHANICS.md**       | Technical deep dive      | Core developers  | 45 min    |
| **104_ROADMAP_BUILD.md**        | Implementation reference | Tech leads       | 30 min    |

**When to read:**

- Building new engine system
- Understanding architecture constraints
- Debugging lifecycle issues
- Planning roadmap

---

### **`200_USER_GUIDES/` - User & Contributor Guides**

| Doc                            | Purpose                      | Audience      | Read Time    |
| ------------------------------ | ---------------------------- | ------------- | ------------ |
| **201_CONTRIBUTING_MODULE.md** | How to make gameplay modules | Gameplay devs | 40 min       |
| **202_CONTRIBUTING_SYSTEM.md** | How to make engine systems   | Engine devs   | 50 min       |
| **210_API_REFERENCE/\*.md**    | System API reference         | All devs      | 10-15 min ea |

**When to read:**

- Creating new module/system
- Looking up API usage
- Understanding patterns
- Troubleshooting

---

### **`300_LOGS/` - Development Tracking**

| Doc                | Purpose                | Audience | Update Freq  |
| ------------------ | ---------------------- | -------- | ------------ |
| **301_DEV_LOG.md** | Session progress notes | Team     | Per session  |
| **302_ADR_LOG.md** | Architecture decisions | Team     | Per decision |

**When to read/write:**

- Track what was done in session
- Document major architectural decisions
- Reference past decisions

---

## 🎯 COMMON TASKS & PATHS

### **Task: "Bikin fitur Shop baru"**

```
1. Read: 201_CONTRIBUTING_MODULE.md (full)
2. Copy: MinimalModule folder
3. Rename: MinimalModule → ShopModule
4. Code: SharedConfig.lua, ShopService.lua, ShopController.lua
5. Refer: 210_API_REFERENCE/* saat butuh system
6. Test: Di studio - full workflow
7. Result: Working Shop module
Time: 2-4 jam
```

---

### **Task: "Debug race condition / lifecycle issue"**

```
1. Read: 102_CORE_MECHANICS.md (4-Phase section)
2. Read: 202_CONTRIBUTING_SYSTEM.md (if creating system)
3. Enable: Logger DEBUG mode
4. Trace: Log output during reproduce
5. Fix: Ensure 4-Phase compliance
6. Test: Verify issue gone
Time: 1-3 jam depending on complexity
```

---

### **Task: "Tambah SoundManager system ke engine"**

```
1. Read: 101_GENESIS_ARCHITECTURE.md (understand hukum)
2. Read: 102_CORE_MECHANICS.md (understand lifecycle)
3. Read: 202_CONTRIBUTING_SYSTEM.md (step-by-step)
4. Implement: SoundManager.lua + SoundManagerManifest.lua
5. Test: Boot sequence + usage in module
6. Document: Create 219_SOUND_MANAGER.md API reference
7. Submit: PR for review
Time: 4-6 jam
```

---

### **Task: "Saya ingin tahu cara pakai DataManager"**

```
1. Open: 210_API_REFERENCE/README.md
2. Find: "DataManager" (or search for 219_DATA_MANAGER.md)
3. Status: ⏳ PLANNED (tidak ada doc yet, refer code directly)
4. Code reference: src/ReplicatedStorage/OVHL/Systems/Advanced/DataManager.lua
Quick usage:
   local DataManager = OVHL:GetSystem("DataManager")
   local playerData = DataManager:LoadData(player)
Time: 5 min
```

---

## 📊 DOCUMENTATION STATUS (V1.0.0)

### **Engine Architecture** ✅ COMPLETE

- ✅ 101_GENESIS_ARCHITECTURE.md (12 Commandments + blueprint)
- ✅ 102_CORE_MECHANICS.md (Technical details)
- ✅ 104_ROADMAP_BUILD.md (Implementation reference)

### **User Guides** ✅ COMPLETE

- ✅ 201_CONTRIBUTING_MODULE.md (Module creation)
- ✅ 202_CONTRIBUTING_SYSTEM.md (System creation)

### **API Reference** ⚠️ 8/12 DONE

- ✅ 211_LOGGER.md
- ✅ 212_PERMISSION.md
- ✅ 213_VALIDATOR.md
- ✅ 214_UI_ENGINE.md
- ✅ 215_RATE_LIMITER.md
- ✅ 216_NETWORKING.md
- ✅ 217_UI_MANAGER.md
- ✅ 218_ASSET_LOADER.md
- ⏳ 219_DATA_MANAGER.md (PLANNED)
- ⏳ 220_PLAYER_MANAGER.md (PLANNED)
- ⏳ 221_NOTIFICATION_SERVICE.md (PLANNED)
- ⏳ 210_CONFIG_LOADER.md (PLANNED)

### **Workflow & Standards** ✅ COMPLETE

- ✅ 00_AI_WORKFLOW_GUIDE.md (AI mandates + workflow)
- ✅ 300_LOGS/README.md (Logging standards)

---

## 🔄 DOCUMENTATION ROADMAP

### **V1.0.0** (Current - Nov 2025) ✅

- Core architecture docs complete
- User guides complete
- 8/12 API references done
- All standards documented
- **Status: Production Ready**

### **V1.1.0** (Planned - Q1 2026)

- Complete remaining API references (DataManager, PlayerManager, NotificationService, ConfigLoader)
- Add adapter pattern docs (when implemented)
- Add advanced testing guide
- Update with networking enhancements

### **V1.2.0** (Planned - Q2 2026)

- Performance optimization guide
- Advanced troubleshooting guide
- Performance monitoring docs
- Optimization patterns

### **V2.0.0** (Future)

- Complete architecture revision
- New design patterns
- Breaking changes documented

---

## 🔗 CROSS-REFERENCE GUIDE

**If you need to understand:**

| Topic                 | Start here                  | Then read                  |
| --------------------- | --------------------------- | -------------------------- |
| **Philosophy**        | 101_GENESIS_ARCHITECTURE.md | 00_AI_WORKFLOW_GUIDE.md    |
| **4-Phase Lifecycle** | 102_CORE_MECHANICS.md       | 202_CONTRIBUTING_SYSTEM.md |
| **Making modules**    | 201_CONTRIBUTING_MODULE.md  | 210_API_REFERENCE/\*       |
| **Making systems**    | 101_GENESIS_ARCHITECTURE.md | 202_CONTRIBUTING_SYSTEM.md |
| **Using a system**    | 210_API_REFERENCE/README.md | Specific API doc           |
| **Debugging**         | 102_CORE_MECHANICS.md       | Specific issue             |
| **Contributing**      | 00_AI_WORKFLOW_GUIDE.md     | Specific guide             |

---

## ✅ STANDARDS & CONVENTIONS

### **Documentation Standards (V1.0.0)**

All docs follow:

- Header/Footer format dengan metadata
- Markdown + code examples
- V1.0.0 version references
- No placeholders or ellipsis
- Complete, copy-paste ready code

### **Code Standards (V1.0.0)**

All code files have:

```lua
--[[
OVHL ENGINE V1.0.0
@Component: [Name] ([Category])
@Path: [Full.Path.To.Module]
@Purpose: [One sentence]
@Stability: [STABLE/BETA/EXPERIMENTAL]
--]]

-- code here

--[[
@End: [FileName].lua
@Version: 1.0.0
@LastUpdate: [YYYY-MM-DD]
@Maintainer: [Name or "OVHL Core Team"]
--]]
```

---

## 🆘 GETTING HELP

### **Documentation question?**

→ Check relevant folder's README.md first

### **Can't find what you need?**

→ Check cross-reference table above

### **Found error in docs?**

→ Fix directly (or note in 301_DEV_LOG.md)

### **Think doc is missing?**

→ Check `DOCUMENTATION STATUS` section (maybe planned)

---

## 📝 HOW TO UPDATE DOCS

1. **Typo/clarity:** Fix directly, minimal discussion
2. **New content:** Align dengan existing structure
3. **Major change:** Discuss dengan team first
4. **New API doc:** Follow `210_API_REFERENCE/` template
5. **Always:** Update relevant README.md + version header

---

## 📞 CONTACTS & RESOURCES

- **Documentation issues:** Track in `301_DEV_LOG.md`
- **Architecture questions:** Ask in team / create `302_ADR_LOG.md` entry
- **Code reference:** Check `snapshot-[timestamp].md`

---

## 🎓 LEARNING PATH (Recommended)

**For complete beginners:**

```
1. This page (README.md) - Understand structure
2. 201_CONTRIBUTING_MODULE.md - Make first module
3. 210_API_REFERENCE/* - Learn systems as needed
4. 100_ENGINE_GUIDES/* - Deep dive when interested
```

**For experienced developers:**

```
1. 100_ENGINE_GUIDES/ - Understand architecture
2. 202_CONTRIBUTING_SYSTEM.md - Extend engine
3. 210_API_REFERENCE/* - Reference as needed
```

**For engine architects:**

```
1. 00_AI_WORKFLOW_GUIDE.md - Understand mandates
2. 100_ENGINE_GUIDES/* - Architecture principles
3. 102_CORE_MECHANICS.md - Technical reference
4. 202_CONTRIBUTING_SYSTEM.md - Implementation guide
```

---

## ✨ KEY POINTS (TL;DR)

- **V1.0.0** is **STABLE & PRODUCTION READY** ✅
- **12 Hukum Dasar** govern all development
- **4-Phase Lifecycle** is mandatory for all systems
- **3-Config Pattern** is mandatory for all modules
- **3-Pilar Security** (Validator, RateLimiter, Permission) is non-negotiable
- **Complete documentation** is provided for all V1.0.0 features
- **Contributing guide** included for both modules + systems

---

## 🚀 READY?

**Pick your role above and start!**

- 👨‍💻 **Gameplay Dev?** → Start with `201_CONTRIBUTING_MODULE.md`
- ⚙️ **Engine Eng?** → Start with `101_GENESIS_ARCHITECTURE.md`
- 🔍 **Lookup API?** → Start with `210_API_REFERENCE/README.md`
- 🤖 **AI Architect?** → Start with `00_AI_WORKFLOW_GUIDE.md`

---

> END OF ./docs/README.md
