> START OF ./docs/300_LOGS/302_ADR_LOG.md
>
> **OVHL ENGINE V3.4.0** > **STATUS:** MONOLITHIC LOGGING
> **AUDIENCE:** AI & CORE DEVELOPERS
> **PURPOSE:** Arsip Keputusan Arsitektural.

# 302. Architecture Decision Record (ADR)

# 📢 [2025-11-18] Keputusan ADR-005 - Adapter Pattern Implementation

**TANGGAL KEPUTUSAN:** 2025-11-18, 15:20  
**KONTEKS:** Implementasi Permission & Navbar systems harus config-driven (Hukum #4), mendukung multi-adapter (future-proof)  
**STATUS:** ✅ DITETAPKAN

---

## 🎯 KEPUTUSAN (ADR-005)

### **Implement Config-Driven Adapter Pattern untuk Permission & Navbar Systems**

Kedua sistem (PermissionCore & UIManager) sekarang menggunakan **adapter loader pattern**:

1. **EngineConfig.lua** menyediakan selektor adapter
2. **PermissionCore** / **UIManager** membaca config saat runtime
3. Load adapter yang dipilih dynamically
4. Fallback otomatis ke InternalAdapter jika adapter unavailable

**Benefit:** Config-driven (Hukum #4), future-proof, no code changes untuk switch adapter

---

## 🔍 ALASAN / KONTEKS

### **Problem:**

- PermissionCore hardcoded internal fallback (tidak extensible)
- UIManager hardcoded TopbarPlus logic (tidak extensible)
- Violate **Hukum #4: Config-Driven** (behavior tidak via config)
- Sulit menambah adapter baru (require code change)

### **Solution Decision:**

Adapter Pattern dengan:

- **InternalAdapter:** Fallback implementation (ours)
- **HDAdminAdapter:** HD Admin bridge
- **TopbarPlusAdapter:** TopbarPlus V3 bridge
- **Loader Pattern:** Core system (PermissionCore/UIManager) jadi simple loader
- **EngineConfig:** Single point of adapter selection

### **Why This Pattern:**

1. **Separation of Concerns** ✅

   - Core logic (PermissionCore) separate dari adapter logic
   - Each adapter responsible untuk implementasi own

2. **Config-Driven (Hukum #4)** ✅

   - Adapter selection via EngineConfig, not hardcoded
   - Change adapter without code modification

3. **Future-Proof** ✅

   - Add new admin system? Just create adapter
   - Add new navbar? Just create adapter
   - Core code unchanged

4. **Fallback Strategy** ✅

   - HD Admin unavailable? Auto fallback to Internal
   - TopbarPlus unavailable? Auto fallback to Fusion UI
   - No crashes, graceful degradation

5. **Testing** ✅
   - Can mock adapters untuk unit tests
   - Can switch adapters untuk different scenarios
   - Easier to test each adapter independently

---

## 📐 DAMPAK (IMPACT)

### **Files Modified:**

- `src/ReplicatedStorage/OVHL/Systems/Security/PermissionCore.lua`

  - Dari: Implementation dengan fallback logic
  - Ke: Adapter loader (simple, clean)

- `src/ReplicatedStorage/OVHL/Systems/UI/UIManager.lua`

  - Dari: Implementation dengan TopbarPlus logic
  - Ke: Adapter loader (simple, clean)

- `src/ReplicatedStorage/OVHL/Config/EngineConfig.lua`
  - Added: `Adapters` section dengan selectors

### **Files Created:**

```
Systems/Adapters/
├── Permission/
│   ├── InternalAdapter.lua (155 lines)
│   └── HDAdminAdapter.lua (138 lines)
└── Navbar/
    ├── TopbarPlusAdapter.lua (105 lines)
    └── InternalAdapter.lua (72 lines)
```

### **Behavior Changes:**

1. Permission checks → go through adapter (InternalAdapter atau HDAdminAdapter)
2. Navbar buttons → created via adapter (TopbarPlusAdapter atau InternalAdapter)
3. Adapter selection → via EngineConfig.lua
4. Fallback → automatic (HD Admin/TopbarPlus unavailable → use Internal)

### **Breaking Changes:**

- ❌ NONE - Backward compatible
- Existing code continue to work
- Permission/Navbar behavior unchanged
- Just now config-driven

### **No API Changes:**

- `PermissionCore:Check(player, node)` - same signature
- `UIManager:SetupTopbar(module, config)` - same signature
- User code unchanged

---

## 🏗️ ARCHITECTURE DIAGRAM

```
EngineConfig.lua (Single Source of Truth)
    │
    ├─→ Adapters.Permission = "HDAdminAdapter"
    │   └─→ PermissionCore:Start()
    │       └─→ Load HDAdminAdapter
    │           └─→ Bridge to HD Admin API
    │
    └─→ Adapters.Navbar = "TopbarPlusAdapter"
        └─→ UIManager:Start()
            └─→ Load TopbarPlusAdapter
                └─→ Bridge to TopbarPlus V3 API

If adapter unavailable:
    └─→ Auto fallback to InternalAdapter
        └─→ Use built-in implementation
```

---

## 📋 IMPLEMENTATION DETAILS

### **PermissionCore (Loader):**

```lua
function PermissionCore:Start()
    -- 1. Read EngineConfig
    local adapterName = engineConfig.Adapters.Permission

    -- 2. Load adapter class
    local AdapterClass = require(adapters/Permission/[adapterName])

    -- 3. Instantiate
    self._adapter = AdapterClass.new()
    self._adapter:Initialize(logger)
end

function PermissionCore:Check(player, node)
    -- Delegate to adapter
    return self._adapter:CheckPermission(player, node)
end
```

### **InternalAdapter (Implementation):**

```lua
-- Own permission service
-- Rank system, DataStore persistence, etc.
function InternalAdapter:CheckPermission(player, node)
    -- Check rank vs required permission
    -- Return true/false
end
```

### **HDAdminAdapter (Implementation):**

```lua
-- Bridge to HD Admin
function HDAdminAdapter:CheckPermission(player, node)
    -- Call HD Admin API
    -- Translate response
    -- Return true/false
end
```

---

## 🎯 VERSIONING & TIMELINE

**ADR-005 Status:**

- Version: V1.0.0 (Initial Implementation)
- Status: ✅ DITETAPKAN
- Effective: 2025-11-18 (immediate)

**Future Roadmap:**

- V1.1.0: Add StateManager adapter
- V1.1.0: Add more permission adapters (other admin systems)
- V1.2.0: Performance optimization adapters
- V2.0.0: Support plugin-based adapters

---

## 📚 REFERENCE DOCS UPDATED

Docs yang perlu update dengan ADR-005:

- ✅ `101_GENESIS_ARCHITECTURE.md` - Add Hukum #13 (Adapter Pattern)
- ✅ `102_CORE_MECHANICS.md` - Add adapter loading section
- ✅ `103_ARCHITECTURE_ADAPTERS.md` - Already drafted
- ⏳ `210_API_REFERENCE/212_PERMISSION.md` - Update with adapter info
- ⏳ `210_API_REFERENCE/217_UI_MANAGER.md` - Update with adapter info
- ⏳ `202_CONTRIBUTING_SYSTEM.md` - Add adapter creation guide

---

## 🧪 VALIDATION & TESTING

### **Unit Tests (Must Pass):**

- [ ] InternalAdapter permission check
- [ ] HDAdminAdapter permission check (if HD Admin available)
- [ ] TopbarPlusAdapter button creation (if TopbarPlus available)
- [ ] InternalAdapter navbar fallback
- [ ] Adapter fallback logic

### **Integration Tests (Must Pass):**

- [ ] PermissionCore loads correct adapter
- [ ] UIManager loads correct adapter
- [ ] Permission checks work end-to-end
- [ ] Navbar buttons appear end-to-end
- [ ] Auto-fallback works

### **E2E Tests (Must Pass):**

- [ ] Player login → permission check works
- [ ] Click action → security pipeline validates
- [ ] Permission honored (can/cannot based on rank)
- [ ] Navbar button permission-based showing

---

## ✅ APPROVAL & SIGN-OFF

**Decision Makers:**

- Lead Architect: AI (Principal Architect)
- Lead Developer: You (Dev Lead)
- Decision: ✅ **APPROVED**

**Implementation Timeline:**

- Phase 1: Fix Issues (DONE)
- Phase 2.1: Permission Adapters (DONE)
- Phase 2.2: Navbar Adapters (DONE)
- Phase 3: Testing (PENDING)

**Status: READY FOR PLAYTEST** 🎮

---

## 📝 AMENDMENT LOG

**V1.0.0 (2025-11-18):**

- Initial decision: Adapter Pattern untuk Permission & Navbar
- Config-driven via EngineConfig.lua
- Auto-fallback strategy implemented
- 4 adapters created (Internal Permission, HDAdmin, TopbarPlus, Internal Navbar)

---

> **NOTE:** This ADR establishes the adapter pattern as standard for all OVHL systems going forward. Any new system requiring external integrations MUST use this pattern.

---

**KEPUTUSAN FINAL: ADR-005 DITETAPKAN ✅**

## Effective immediately. All team members should follow adapter pattern when extending OVHL systems.

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
