> START OF ./docs/100_ENGINE_GUIDES/101_GENESIS_ARCHITECTURE.md
>
> **OVHL ENGINE V3.4.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** ENGINE ARCHITECT
> **PURPOSE:** Definisi Hukum Arsitektural yang Absolut dan Abadi.

---

# 📜 101_GENESIS_ARCHITECTURE.MD (The Core Law)

---

## 1. FILOSOFI & HUKUM DASAR (THE COMMANDMENTS)

1.  **Zero Core Modification:** Modul game (`Modules/`) dilarang menyentuh folder `Core/`. Core adalah _black box_.
2.  **Separation of Concerns:** `Systems/` = Technical (Logger, Security). `Modules/` = Gameplay (Inventory). (Lihat `202_CONTRIBUTING_SYSTEM.md` untuk detail).
3.  **Server Authority:** Client tidak dipercaya. Input wajib lewat `InputValidator` (Schema) & `RateLimiter`.
4.  **Config-Driven:** Behavior diatur via 3 file Config (`SharedConfig`, `ServerConfig`, `ClientConfig`). Dilarang hardcode magic values.
5.  **Fusion 0.3 (Strict Scope):** UI wajib menggunakan `Fusion.scoped`. Dilarang instansiasi UI tanpa Scope (untuk memory safety).
6.  **No Global State:** State disimpan di Service/Controller atau `StateManager` (Roadmap Phase 3). `_G` dilarang.
7.  **Self-Contained Modules:** Modul membawa 3 file config, service, dan controller-nya sendiri.
8.  **No `init.lua`:** Dilarang keras menggunakan file bernama `init.lua`. Gunakan nama deskriptif (`Bootstrap.lua`, `Kernel.lua`).
9.  **Explicit Paths:** Gunakan `game:GetService` atau path traversal eksplisit. Dilarang `script.Parent` berlebihan.
10. **Luau Compatibility:** Gunakan sintaks Luau yang valid (misal: `table.size` tidak ada).
11. **Mandatory Code Header V3.4.0:** Semua file `.lua` wajib menyertakan blok Header V3.4.0 (`@Component:`, `@Path:`, `@Purpose:`).
12. **Mandatory Code Footer V3.4.0:** Semua file `.lua` wajib menyertakan blok Footer V3.4.0 (`@End:`, `@Version:`, `@See:`).
13. **ADR Integration Rule:** Semua keputusan arsitektural yang dicatat dalam `302_ADR_LOG.md` wajib diintegrasikan (dikutip, diringkas, atau dijelaskan) ke dalam dokumen _blueprint_ terkait (di folder `100_ENGINE_GUIDES/` dan `200_USER_GUIDES/`).
14. **Demarkasi Networking:** Gunakan **Knit Networking** (`Service.Client:Method()`) untuk semua komunikasi Modul-ke-Modul. Gunakan **OVHL Networking** (`NetworkingRouter`) HANYA untuk komunikasi Sistem-ke-Sistem (level engine) atau jika Pola Adapter membutuhkannya.

---

## 2. STRUKTUR DIREKTORI PRODUKSI (V3.4.0)

(Struktur ini sesuai dengan `snapshot-20251118_113010.md`)

```text
src/
├── ReplicatedStorage/
│   └── OVHL/
│       ├── Core/                 # Jantung Engine
│       │   ├── Bootstrap.lua     # [ENTRY] Environment Loader & Dependency Definition
│       │   ├── Kernel.lua        # [ENTRY] Module Loader & Knit Bridge
│       │   ├── OVHL.lua          # [API] Public API Gateway
│       │   └── SystemRegistry.lua # [INTERNAL] Dependency Resolution Logic
│       ├── Systems/              # Organ Tubuh (Fitur Teknis)
│       │   ├── Foundation/       # Logger, ConfigLoader
│       │   ├── Networking/       # Router, Security Middleware
│       │   ├── Security/         # Validator, RateLimiter, Permission
│       │   ├── UI/               # UIEngine (Fusion), UIManager, AssetLoader
│       │   ├── Adapters/         # [BARU V3.1.0] Jembatan ke API Pihak Ketiga
│       │   └── Advanced/         # [KOSONG, TARGET ROADMAP PHASE 3]
│       ├── Config/               # Konfigurasi Global Engine
│       ├── Types/                # CoreTypes.lua (Definisi Tipe)
│       └── Shared/Modules/       # Game Modules (Bagian Shared)
│           └── [ModuleName]/     # Nama Folder = Nama Modul
│               ├── SharedConfig.lua # Config & Schema Validasi
│
├── ServerScriptService/
│   └── OVHL/
│       ├── ServerRuntime.server.lua  # Entry Point Server
│       └── Modules/              # Game Modules (Bagian Server)
│           └── [ModuleName]/
│               ├── [Name]Service.lua # Logika Server & Security Implementation
│               └── ServerConfig.lua  # Config rahasia
│
└── StarterPlayer/StarterPlayerScripts/
    └── OVHL/
        ├── ClientRuntime.client.lua  # Entry Point Client
        └── Modules/              # Game Modules (Bagian Client)
            └── [ModuleName]/
                ├── [Name]Controller.lua # Logika Client & UI Mounting
                └── ClientConfig.lua     # Config visual/input
```

---

## 3. TECHNOLOGY STACK (VERSI BAKU V3.4.0)

- **Framework:** [Knit (v1.7.0+)](https://sleitnick.github.io/Knit/)
- **UI Library:** [Fusion (v0.3.0)](https://elttob.uk/Fusion/)
- **Aturan UI:** Hanya `Fusion` (Programmatic) dan `Native` (Fallback). **Plasma Dihapus**.
- **Integrasi Pihak Ketiga:** Wajib melalui **Pola Adapter** (Lihat `103_ARCHITECTURE_ADAPTERS.md`).

---

## 4. SISTEM INTI (CORE SYSTEMS)

- **Smart Bootstrap (`Core/Bootstrap.lua`):** Auto-discovery sistem di `Systems/`. Dependensi di-hardcode di file ini untuk SSoT load order.
- **System Registry (`Core/SystemRegistry.lua`):** Melakukan _Topological Sort_ untuk mengurutkan sistem berdasarkan dependensi. **Mengimplementasikan Lifecycle 4-Fase (ADR-004)**.
- **Security Layer (`Systems/Security/`):** `InputValidator` (Schema), `RateLimiter` (Spam), `PermissionCore` (Rank).

---

## 5. MODULE PATTERN (GOLDEN STANDARD)

(Rujuk `201_CONTRIBUTING_MODULE.md` untuk detail)

- **Server Service:** Wajib `KnitInit` (load dependency via `self.OVHL:GetSystem()`) dan `KnitStart` (logic).
- **Client Controller:** Wajib menggunakan `UIEngine` untuk render UI.
- **3-Config:** Wajib menggunakan 3 file config (Shared, Server, Client).

---

## 7. ERROR HANDLING & RECOVERY

> **Sumber:** Diselamatkan dari `01_OVHL_ENGINE.md` (Legacy V2.2)

### 7.1 Error Classification

- **Level 1 (Non-critical):** Fallback tersedia, log warning.
- **Level 2 (Module-specific):** Isolasi kegagalan, jangan crash engine.
- **Level 3 (System-wide):** Degradasi sistem ke mode fallback.
- **Level 4 (Critical):** Emergency recovery, simpan state, notifikasi monitoring.

### 7.2 Layered Error Handling

- **Layer 1: Input Validation (Modules):** `assert(typeof(param) == "string")`.
- **Layer 2: System-Level Recovery (Core):** `pcall()` saat `require()` sistem, jika gagal gunakan fallback.
- **Layer 3: Network Resilience (Router):** Retry dengan exponential backoff.

---

## 8. PERFORMANCE & OPTIMIZATION

> **Sumber:** Diselamatkan dari `01_OVHL_ENGINE.md` (Legacy V2.2)

### 8.1 Performance Budget

- **Frame Time Impact:** ≤5ms maksimum per frame.
- **Memory Usage:** Kontrol pertumbuhan dengan lazy loading.
- **Load Time:** <3 detik inisialisasi engine.

### 8.2 Optimization Strategies

- **Lazy Loading:** Modul di-load saat dibutuhkan (`Kernel:GetModule(name)`).
- **Object Pooling:** (Target Roadmap Phase 3) `pool:Get()` dan `pool:Return(obj)`.
- **Batched Operations:** Kirim update ganda dalam satu panggilan (Router).
- **Performance Monitoring:** (Target Roadmap Phase 3) Deteksi operasi lambat.

---

## 9. SECURITY CONSIDERATIONS

> **Sumber:** Diselamatkan dari `01_OVHL_ENGINE.md` (Legacy V2.2)

### 9.1 Server Authority Pattern

- **NEVER trust client input.**
- **BURUK ❌:** Client mengirim `Client:Fire("GiveMoney", 9999999)`.
- **BAIK ✅:** Client mengirim `Client:Fire("PurchaseItem", itemId)`. Server memvalidasi harga, uang, dan izin.

### 9.2 Input Validation

- Validasi selalu di server menggunakan whitelist, type check, dan schema.

### 9.3 Rate Limiting

- Mencegah abuse dengan `RateLimiter:CheckLimit(player, action)`.

---

## 10. TESTING STRATEGY

> **Sumber:** Diselamatkan dari `01_OVHL_ENGINE.md` (Legacy V2.2)

### 10.1 Test Types

- **Unit Tests:** Tes fungsi individual, mock dependencies (Contoh: `SmartLogger.spec.lua`).
- **Integration Tests:** Tes interaksi antar sistem (Contoh: `DataFlow.spec.lua`).
- **E2E Tests:** Tes skenario workflow penuh (Contoh: `FullWorkflow.spec.lua`).

### 10.2 Test Structure

```text
tests/
├── Unit/
│   ├── SmartLogger.spec.lua
│   ├── StateManager.spec.lua
│   └── PermissionCore.spec.lua
├── Integration/
│   ├── DataFlow.spec.lua
│   └── ModuleCommunication.spec.lua
└── E2E/
    └── FullWorkflow.spec.lua
```

---

## 11. DOCUMENTATION STANDARDS (V3.4.0)

- **Standar Kode:** Standar Header/Footer V3.4.0 (Hukum #11 dan #12) menggantikan format LuaDoc lama.
- **Dokumentasi Gameplay:** Modul _gameplay_ wajib didokumentasikan di `201_CONTRIBUTING_MODULE.md`.
- **Dokumentasi Engine:** _Sistem_ engine wajib memiliki file API-nya sendiri di `210_API_REFERENCE/`.

---

> END OF ./docs/100_ENGINE_GUIDES/101_GENESIS_ARCHITECTURE.md
