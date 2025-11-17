# 📚 MEGA API REFERENCE (OVHL V3.0.0)

> **INSTRUKSI AI:** Gunakan daftar fungsi ini sebagai referensi kebenaran (Source of Truth). Jangan mengarang fungsi yang tidak ada di sini.

---

## 🌐 GLOBAL ACCESS (`OVHL.lua`)

Akses: `local OVHL = require(game.ReplicatedStorage.OVHL.Core.OVHL)`

| Method                             | Return         | Deskripsi                                                             |
| :--------------------------------- | :------------- | :-------------------------------------------------------------------- |
| `OVHL:GetSystem("Name")`           | `Table/System` | Mengambil sistem core (Logger, UI, dll). Return `nil` jika tidak ada. |
| `OVHL:GetConfig("Module")`         | `Table`        | Mengambil config gabungan (Server+Shared+Engine).                     |
| `OVHL:GetClientConfig("Mod")`      | `Table`        | Mengambil config aman untuk client (sensitive data difilter).         |
| `OVHL:ValidateInput(schema, data)` | `bool, string` | Shortcut validasi data instan.                                        |
| `OVHL:CheckPermission(plr, node)`  | `bool, string` | Shortcut cek permission player.                                       |
| `OVHL:CheckRateLimit(plr, action)` | `bool`         | Shortcut cek limit spam.                                              |

---

## 🔧 SYSTEMS API

### 1. SmartLogger (`OVHL:GetSystem("SmartLogger")`)

- `Info(domain, message, metadata)`: Log info standar.
- `Warn(domain, message, metadata)`: Log peringatan kuning.
- `Error(domain, message, metadata)`: Log error merah (recoverable).
- `Debug(domain, message, metadata)`: Log debug (hanya muncul di mode DEBUG/VERBOSE).
- `SetModel(modelName)`: Ganti mode ("SILENT", "NORMAL", "DEBUG", "VERBOSE").

### 2. UIEngine (`OVHL:GetSystem("UIEngine")`) - _Client Only_

- `CreateScreen(screenName, config)`: Membuat UI dari Fusion/Native berdasarkan Config.
- `ShowScreen(screenName)`: Menampilkan UI.
- `HideScreen(screenName)`: Menyembunyikan UI.

### 3. UIManager (`OVHL:GetSystem("UIManager")`) - _Client Only_

- `FindComponent(screenName, componentName)`: Mencari object UI berdasarkan nama (Wajib set `.Name` di Fusion).
- `BindEvent(component, eventName, callback)`: Connect event aman (auto-cleanup saat module destroy).
- `SetupTopbar(module, config)`: Bikin tombol TopbarPlus otomatis.

### 4. Security (`InputValidator`, `RateLimiter`, `PermissionCore`)

- `InputValidator:Validate(schemaName, dataTable)`: Validasi format data.
- `RateLimiter:Check(player, actionKey)`: Cek quota request.
- `PermissionCore:Check(player, "Module.Action")`: Cek rank player (0-5).

### 5. Networking (`OVHL:GetSystem("NetworkingRouter")`)

- `SendToServer(route, data)`: Kirim event ke server.
- `SendToClient(player, route, data)`: Kirim event ke client.
- _Note: Gunakan ini hanya jika tidak menggunakan Knit Service Methods._
