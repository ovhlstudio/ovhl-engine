# 🏗️ OVHL GENESIS ARCHITECTURE (V3.0.0)

> **STATUS:** FINAL & AUTHORITATIVE (Post-Debug Verification)
> **TUJUAN:** Dokumen ini adalah fondasi mutlak untuk membangun ulang OVHL Engine dari nol.
> **WARNING:** Dokumen ini ditulis "dengan darah" (berdasarkan bug-fix history). Patuhi setiap detailnya.

---

## 1. FILOSOFI & HUKUM DASAR (THE 10 COMMANDMENTS)

1.  **Zero Core Modification:** Modul game dilarang menyentuh folder `Core`. Core adalah _black box_.
2.  **Separation of Concerns:** `Systems/` = Technical (Logger, Security). `Modules/` = Gameplay (Inventory).
3.  **Server Authority:** Client tidak dipercaya. Input wajib lewat `InputValidator` (Schema) & `RateLimiter`.
4.  **Config-Driven:** Behavior diatur via `SharedConfig` & `ServerConfig`. Dilarang hardcode magic values.
5.  **Fusion 0.3 (Strict Scope):** UI wajib menggunakan `Fusion.scoped`. Dilarang instansiasi UI tanpa Scope (untuk memory safety).
6.  **No Global State:** State disimpan di Service/Controller atau `StateManager`. `_G` dilarang.
7.  **Self-Contained Modules:** Modul membawa aset, config, service, dan controller-nya sendiri dalam satu folder.
8.  **No `init.lua`:** Dilarang keras menggunakan file bernama `init.lua`. Gunakan nama deskriptif (`Bootstrap.lua`, `Kernel.lua`).
9.  **Explicit Paths:** Gunakan recursive search atau `game:GetService`. Dilarang `script.Parent` berlebihan.
    - _Note:_ `FindFirstChild("Folder/File")` TIDAK BERFUNGSI di Roblox.
10. **Luau Compatibility:** Gunakan sintaks Luau yang valid.
    - _Warning:_ `table.size` tidak ada. Gunakan helper function atau iterasi manual.

---

## 2. STRUKTUR DIREKTORI PRODUKSI (V3.0.0)

Struktur ini didesain agar **Smart Bootstrap** bisa melakukan auto-discovery tanpa error.

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
│       │   └── Advanced/         # StateManager, Performance
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

## 3. TECHNOLOGY STACK (VERSI BAKU)

- **Framework:** [Knit (v1.7.0+)](https://sleitnick.github.io/Knit/)
  - _Implementation Detail:_ Gunakan `Knit:GetService("Name")` (Colon syntax) di Kernel untuk menghindari error `attempt to call nil`.
- **UI Library:** [Fusion (v0.3.0)](https://elttob.uk/Fusion/)
  - _Critical Rule:_ Gunakan syntax `scope:New "ClassName" {}`. Jangan gunakan `New "ClassName" {}` gaya lama.
- **Build Tools:** Mojo/Rojo + Wally.

---

## 4. SISTEM INTI (CORE SYSTEMS)

### 4.1 Smart Bootstrap (`Core/Bootstrap.lua`)

- **Tugas:** Auto-discovery sistem di folder `Systems/`.
- **Logic Dependensi:** Tabel dependensi (`systemDependencies`) didefinisikan secara **HARDCODED** di dalam file ini.
  - _Kenapa?_ Agar urutan load sistem (Logger -> Config -> UI) tersentralisasi di satu tempat.

### 4.2 System Registry (`Core/SystemRegistry.lua`)

- **Tugas:** Mengurutkan sistem berdasarkan dependensi menggunakan _Topological Sort_.
- **Aturan:** Hanya untuk sistem internal OVHL. Knit Service dilarang masuk ke sini (Double Register Bug).

### 4.3 Security Layer (`Systems/Security/`)

- **InputValidator:** Memvalidasi data berdasarkan Schema di `SharedConfig`.
  - _Strict:_ Jika schema minta `Table`, `String` akan ditolak.
- **PermissionCore:** Sistem Rank (0-5).
  - _Logika:_ Menggunakan Fallback provider yang membaca `SharedConfig.Permissions`.

---

## 5. MODULE PATTERN (GOLDEN STANDARD)

Setiap modul game **WAJIB** mengikuti pola `MinimalModule` yang ada di snapshot.

### Server Service

Wajib memiliki metode `KnitInit` (untuk load dependency) dan `KnitStart` (untuk logic).

```lua
function MinimalService:KnitInit()
    self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
    self.InputValidator = self.OVHL:GetSystem("InputValidator")
end
```

### Client Controller

Wajib menggunakan `UIEngine` untuk render UI.

```lua
function MinimalController:SetupUI()
    self.UIEngine:CreateScreen("MainUI", self.Config)
end
```

### Shared Config

Wajib mendefinisikan `Security` (Schema & RateLimit) dan `Permissions`.

```lua
Security = {
    ValidationSchemas = { ActionData = { type = "table", ... } }
}
```
