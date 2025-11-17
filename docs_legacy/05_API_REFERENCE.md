# 📚 OVHL API REFERENCE V3.0.0

Daftar lengkap layanan dan utilitas yang tersedia di OVHL Engine.

---

## 🌐 CORE API (OVHL.lua)

Akses utama: `local OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)`

| Method                             | Deskripsi                                                          |
| :--------------------------------- | :----------------------------------------------------------------- |
| `OVHL:GetSystem("Name")`           | Mengambil instance sistem OVHL (contoh: "SmartLogger").            |
| `OVHL:GetConfig("Module")`         | Mengambil konfigurasi gabungan (Engine + Shared + Server).         |
| `OVHL:GetClientConfig("Mod")`      | Mengambil konfigurasi aman untuk Client (sensitive data difilter). |
| `OVHL:ValidateInput(Schema, Data)` | Validasi data input (Shortcut ke Security System).                 |
| `OVHL:CheckPermission(Plr, Node)`  | Cek permission player (Shortcut ke Security System).               |

---

## 🛡️ SECURITY SYSTEMS

### 1. InputValidator

_Validasi format data table/string/number._

- `Validate(SchemaName, Data)` -> `boolean, string`
- **Schema Example:**
  ```lua
  ActionData = {
      type = "table",
      fields = {
          action = { type = "string" },
          amount = { type = "number", min = 1 }
      }
  }
  ```

### 2. RateLimiter

_Mencegah spam remote._

- `Check(Player, ActionName)` -> `boolean`
- `SetLimit(ActionName, Max, Window)`

### 3. PermissionCore

_Sistem permission ala HD Admin._

- `Check(Player, PermissionNode)` -> `boolean, string`
- **Fallbacks:** Owner=5, SuperAdmin=4, Admin=3, Mod=2, VIP=1, NonAdmin=0.

---

## 🎨 UI SYSTEMS (Client Only)

### 1. UIEngine

_Render UI menggunakan Fusion (Primary) + Native (Fallback)._

- `CreateScreen(ScreenName, Config)` -> Membuat UI berdasarkan Config.
- `ShowScreen(Name)`, `HideScreen(Name)`.
- **Fusion Scope:** Sudah di-handle otomatis di dalam engine.

### 2. UIManager

_Lifecycle management & Helper._

- `SetupTopbar(Module, Config)` -> Integrasi TopbarPlus otomatis.
- `FindComponent(Screen, Name)` -> Cari tombol/text di dalam Fusion UI (Wajib set property `.Name` di Fusion).
- `BindEvent(Comp, Event, Func)` -> Connect event dengan aman.

---

## 🔧 FOUNDATION

### 1. SmartLogger

_Logging canggih dengan emoji & level._

- `Info(Domain, Msg, Meta)`
- `Warn(Domain, Msg, Meta)`
- `Error(Domain, Msg, Meta)`
- `Debug(Domain, Msg, Meta)`

### 2. ConfigLoader

_Resolusi konfigurasi berlapis._

- Otomatis menggabungkan `EngineConfig` -> `SharedConfig` -> `Server/ClientConfig`.
