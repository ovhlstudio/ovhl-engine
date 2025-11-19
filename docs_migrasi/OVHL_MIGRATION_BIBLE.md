# 📜 THE OVHL V2 MIGRATION BIBLE (PROTOCOL ZERO)

> **CLASSIFICATION:** TOP SECRET // ENGINEERING CORE
> **PROJECT:** OVHL ENGINE V2 (STANDALONE + LEGACY PRESERVATION)
> **AUTHOR:** PRINCIPAL ARCHITECT & USER
> **TARGET ENTITY:** AI ENGINEERING AGENT (NEXT SESSION)
> **ENFORCEMENT:** ABSOLUTE

---

## 🚨 1. MISSION DIRECTIVE (READ FIRST)

**CONTEXT:**
Project ini sedang dalam tahap **RE-ARCHITECTURE TOTAL**. Kita akan menghapus framework eksternal ("Knit") dan menggantinya dengan **OVHL Engine V2 (Standalone)** buatan sendiri.

**THE "KILL KNIT" MANDATE:**

1.  **No More External Dependencies:** Kita bangun Lifecycle, Networking, dan State Management sendiri.
2.  **Strict Separation:** Pisahkan **Engine** (Framework), **Library** (Reusable), dan **Systems** (Gameplay Logic).
3.  **Enterprise Grade:** Kode harus scalable, secure (`ServerStorage`), dan maintainable (< 500 lines/file).

**ROLE ANDA:**
Anda adalah **Senior Framework Engineer** yang ditugaskan untuk mengeksekusi migrasi ini. Anda TIDAK BOLEH beropini di luar dokumen ini. Anda TIDAK BOLEH berasumsi. Jika ragu, stop dan tanya.

---

## ⛔ 2. NEGATIVE CONSTRAINTS (JANGAN LAKUKAN INI)

1.  **DILARANG MENGGUNAKAN KNIT:** Jangan pernah me-require paket Knit. Hapus semua jejaknya.
2.  **DILARANG HARDCODE UI:** Jangan pernah menulis `Color3.fromRGB(...)` atau `UDim2` statis di dalam file Logic/View. Gunakan **Theme/Style Module**.
3.  **DILARANG MONOLITH:** Jika satu file Logic lebih dari 500 baris, PECAH menjadi `Manager` atau `Handler`.
4.  **DILARANG PAKAI FILE MANIFEST TERPISAH:** Config dependensi harus embedded di dalam file Service/Controller (Property `.Config`).
5.  **DILARANG MENGABAIKAN SERVER STORAGE:** Logic krusial (Database, Economy, Anti-Cheat) WAJIB di `ServerStorage`. Client haram akses folder ini.
6.  **DILARANG MEMBUAT KODE TANPA "KURIR":** Semua output kode harus dibungkus script Bash `.sh` yang aman (cek bagian Automation Standard).

---

## 🏛️ 3. ARCHITECTURE BLUEPRINT & PHILOSOPHY

### A. The "Holy Grail" Folder Structure (Target Layout)

```text
src/
├── 📁 ReplicatedFirst/
│   └── 🌙 Preloader.client.lua         # [UX] Loading Screen
│
├── 📁 ReplicatedStorage/
│   ├── 🌙 OVHL.lua                     # [PROXY] Shortcut: return require(script.OVHL_Core.OVHL)
│   │
│   ├── 📁 OVHL_Core/                   # [THE ENGINE] Jantung Framework
│   │   ├── 🌙 OVHL.lua                 # [MAIN API] Lifecycle Manager
│   │   ├── 🌙 Network.lua              # [BRIDGE] Wrapper RemoteEvent
│   │   ├── 🌙 Signal.lua               # [UTIL] Fast Event System
│   │   ├── 🌙 Logger.lua               # [MIGRATED] SmartLogger
│   │   └── 🌙 Permission.lua           # [MIGRATED] PermissionCore Interface
│   │
│   ├── 📁 OVHL_Library/                # [SHARED LIBS] Reusable Code
│   │   ├── 📁 Adapters/                # [CRITICAL: LEGACY ADAPTERS]
│   │   │   ├── 📁 Permission/          # (HDAdmin/Internal Logic)
│   │   │   └── 📁 Navbar/              # (TopbarPlus/Internal Logic)
│   │   ├── 📁 Security/
│   │   │   └── 🌙 InputValidator.lua   # [MIGRATED]
│   │   ├── 📁 UI_Framework/            # [ATOMIC UI] Fusion Design System
│   │   │   ├── 🌙 Theme.lua            # [TRUTH] Colors, Fonts
│   │   │   ├── 📁 Utils/               # (Scanner, AssetLoader)
│   │   │   └── 📁 Components/          # (Atomic UI: Button, Panel)
│   │   └── 🌙 SharedConfig.lua         # [MIGRATED]
│   │
│   └── 📁 Shared_Context/              # [DEFS] Data Types, Enums
│       └── 🌙 GameEnums.lua
│
├── 📁 ServerScriptService/
│   ├── 🌙 ServerBoot.server.lua        # [LOADER] Scan & Start Engine
│   └── 📁 OVHL_Systems/                # [GAMEPLAY - API LAYER]
│       ├── 📁 ShopSystem/
│       │   └── 🌙 ShopService.lua      # [MIGRATED] PrototypeShopService
│       └── 📁 PlayerData/
│           └── 🌙 DataService.lua      # [MIGRATED] Interface PlayerManager
│
├── 📁 ServerStorage/                   # [SECURE STORAGE - LOGIC LAYER]
│   └── 📁 OVHL_Internal/               # [HEAVY LOGIC]
│       ├── 📁 DataInternal/
│       │   └── 🌙 DataManager.lua      # [MIGRATED] Real Database Logic
│       └── 📁 Security/
│           └── 🌙 AntiCheat.lua
│
└── 📁 StarterPlayer/StarterPlayerScripts/
    ├── 🌙 ClientBoot.client.lua        # [LOADER]
    └── 📁 OVHL_Controllers/            # [GAMEPLAY - CLIENT]
        ├── 🌙 Interface.lua            # [MIGRATED] UIManager
        └── 📁 ShopUI/
            ├── 🌙 ShopController.lua   # [MIGRATED] ShopController
            └── 📁 Views/               # [UI] Pure Fusion Layouts
```

### B. Lifecycle Philosophy (3 Fase)

1.  **`OnBoot` (Synchronous):** Setup variable, load config. **HARAM:** Yielding.
2.  **`OnStart` (Asynchronous):** Runtime logic, DataStore connect, Network calls.
3.  **`OnDestroy` (Cleanup):** Disconnect listener saat shutdown.

---

## 💎 5. REFERENCE IMPLEMENTATIONS (TIERED EXAMPLES)

Gunakan pola ini sebagai **GOLDEN STANDARD**.

### A. TIER 1: MINIMAL MODULE (Simple Logic)

_Karakteristik: Logic sederhana, tanpa config, tanpa network._

```lua
-- Path: StarterPlayerScripts/OVHL_Controllers/Greeter/DailyMessage.lua
local OVHL = require(game.ReplicatedStorage.OVHL)

local DailyMessage = OVHL.CreateController({
    Name = "DailyMessage"
})

function DailyMessage:OnStart()
    print("👋 Welcome to OVHL V2! Have a nice day.")
end

return DailyMessage
```

### B. TIER 2: COMPLEX MODULE (Feature Module)

_Karakteristik: Ada Networking (Client-Server), Config Dependencies, Validasi._

```lua
-- Path: ServerScriptService/OVHL_Systems/ShopSystem/WeaponShop.lua
local OVHL = require(game.ReplicatedStorage.OVHL)

local WeaponShop = OVHL.CreateService({
    Name = "WeaponShop",
    Client = {
        -- Otomatis bikin RemoteEvent yang bisa dipanggil Client
        Purchase = OVHL.Network.CreateEvent(),
    },
    Config = {
        Dependencies = {"RateLimiter", "DataService"}
    }
})

function WeaponShop:OnStart()
    -- Lazy Injection
    self.RateLimiter = OVHL.GetService("RateLimiter")
    self.DataService = OVHL.GetService("DataService")
end

function WeaponShop.Client:Purchase(player, itemId)
    -- 1. Security Check
    if not self.RateLimiter:Check(player, "BuyWeapon") then return false end

    -- 2. Logic
    local success = self.DataService:DeductMoney(player, 100)
    if success then
        print("⚔️", player.Name, "bought", itemId)
        return true
    end
    return false
end

return WeaponShop
```

### C. TIER 3: ENTERPRISE MODULE (System Module)

_Karakteristik: Pemisahan tegas antara API (Service) dan Logic Berat (Internal)._

**Layer 1: The API (ServerScriptService)**

```lua
-- Path: ServerScriptService/OVHL_Systems/Economy/EconomyService.lua
local OVHL = require(game.ReplicatedStorage.OVHL)
-- Require Logic rahasia dari ServerStorage
local EconomyLogic = require(game.ServerStorage.OVHL_Internal.Economy.EconomyLogic)

local EconomyService = OVHL.CreateService({
    Name = "EconomyService",
    Client = {
        GetBalance = OVHL.Network.CreateFunction()
    }
})

-- Service cuma jadi "Resepsionis"
function EconomyService.Client:GetBalance(player)
    return EconomyLogic:GetBalance(player)
end

return EconomyService
```

**Layer 2: The Brain (ServerStorage)**

```lua
-- Path: ServerStorage/OVHL_Internal/Economy/EconomyLogic.lua
local EconomyLogic = {}
local DataStoreService = game:GetService("DataStoreService")

-- Logic berat, Session Locking, Retry, Math ada di sini.
-- Client TIDAK BISA menyentuh file ini sama sekali.
function EconomyLogic:GetBalance(player)
    -- ... complex logic ...
    return 1000
end

return EconomyLogic
```

---

## 📦 6. LEGACY MIGRATION INVENTORY (CRITICAL)

Anda **WAJIB** memindahkan kode logic dari file lama ke lokasi baru.

### A. Core & Adapters

| FILE LAMA          | LOKASI BARU (V2)           | TINDAKAN                                  |
| :----------------- | :------------------------- | :---------------------------------------- |
| `SmartLogger`      | `OVHL_Core/Logger.lua`     | Gabungkan dengan Formatter.               |
| `PermissionCore`   | `OVHL_Core/Permission.lua` | Interface utama.                          |
| `*Adapter.lua`     | `Library/Adapters/...`     | Copy logic HDAdmin, Internal, TopbarPlus. |
| `NetworkingRouter` | `OVHL_Core/Network.lua`    | **REWRITE** jadi Wrapper Remote otomatis. |

### B. UI & Utilities

| FILE LAMA          | LOKASI BARU (V2)             | TINDAKAN                               |
| :----------------- | :--------------------------- | :------------------------------------- |
| `UIManager.lua`    | `SPS/.../Interface.lua`      | Controller UI Global.                  |
| `ComponentScanner` | `Library/UI_Framework/Utils` | **CRITICAL**. Fitur Native UI Scanner. |

### C. Security & Data

| FILE LAMA     | LOKASI BARU (V2)                    | TINDAKAN                                  |
| :------------ | :---------------------------------- | :---------------------------------------- |
| `RateLimiter` | `SSS/.../RateLimiter.lua`           | Logic anti-spam Server.                   |
| `DataManager` | `ServerStorage/.../DataManager.lua` | Pindah ke ServerStorage (Tier 3 pattern). |

### D. Gameplay Logic

| FILE LAMA        | LOKASI BARU (V2)             | TINDAKAN                    |
| :--------------- | :--------------------------- | :-------------------------- |
| `PrototypeShop`  | `SSS/.../ShopService.lua`    | Refactor ke Tier 2 Pattern. |
| `ShopController` | `SPS/.../ShopController.lua` | Update call ke Service.     |

---

## 🤖 7. AUTOMATION PROTOCOL (THE KURIR)

Semua output kode WAJIB dibungkus Script Bash.

**TEMPLATE WAJIB:**

```bash
#!/bin/bash
set -eou pipefail

# --- CONFIG ---
BASE_DIR="src"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=".backups/OVHL_MIGRATE_$TIMESTAMP"

# --- HELPER ---
log() { echo -e "[\e[34mOVHL\e[0m] $1"; }
create_file() {
    local filepath="$1"
    local content_func="$2"
    mkdir -p "$(dirname "$filepath")"
    if [ -f "$filepath" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$filepath")"
        cp "$filepath" "$BACKUP_DIR/$filepath"
    fi
    $content_func > "$filepath"
    log "✅ Created: $filepath"
}

# --- CONTENT ---
# (AI defines content functions here...)

# --- EXECUTION ---
log "🚀 Starting OVHL V2 Migration..."
# (AI calls create_file...)
log "✨ Done."
```

---

## 🗓️ 8. EXECUTION PHASES

1.  **Phase 0:** Backup Project.
2.  **Phase 1 (Skeleton):** Buat struktur folder lengkap.
3.  **Phase 2 (Core):** Implementasi Engine, Network, Logger.
4.  **Phase 3 (Library & Adapters):** Migrasi Legacy Adapters & Scanner.
5.  **Phase 4 (Systems):** Migrasi Security & Data (Tier 3 Pattern).
6.  **Phase 5 (Gameplay):** Migrasi Shop (Tier 2 Pattern).

---

**END OF BIBLE**
Gunakan dokumen ini sebagai satu-satunya sumber kebenaran.
