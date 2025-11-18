> START OF ./docs/200_USER_GUIDES/210_API_REFERENCE/211_LOGGER.md
>
> **OVHL ENGINE V3.1.0** > **STATUS:** FINAL & AUTHORITATIVE
> **AUDIENCE:** GAMEPLAY PROGRAMMERS, ENGINE ENGINEERS
> **PURPOSE:** Panduan API mendalam untuk Sistem `SmartLogger`.

---

# 🎯 211_LOGGER.MD (Smart Logger Guide)

> **REFERENSI:** Dokumen ini di-bootstrap dari `02a_API_GUIDE_LOGGER.md` dan divalidasi dengan `snapshot-20251118_071230.md`.

---

## 1. OVERVIEW

**SmartLogger** adalah fondasi logging system OVHL Engine.

- **Akses:** `local Logger = OVHL:GetSystem("SmartLogger")`
- **Fitur Utama:**
  - ✅ **4 Model System**: SILENT, NORMAL, DEBUG, VERBOSE
  - ✅ **Emoji-based Domains**: Didefinisikan di `LoggerConfig.lua`
  - ✅ **Structured Metadata**: Key-value pairs untuk logging kontekstual
  - ✅ **Performance Aware**: Zero overhead di mode SILENT.

## 2. QUICK START

```lua
local OVHL = require(game:GetService("ReplicatedStorage").OVHL.Core.OVHL)
local Logger = OVHL:GetSystem("SmartLogger")

-- Logging sederhana
Logger:Info("SERVER", "Engine started", {version = "3.1.0"})

-- Dengan metadata
Logger:Debug("DATA", "Processing request", {
    userId = 123,
    action = "purchase"
})
```

**Expected Studio Output:**

```
🚀 SERVER - Engine started {version=3.1.0}
📊 DATA - Processing request {userId=123 action=purchase}
```

## 3. API REFERENCE

### Core Logging Methods

(Sesuai `SmartLogger.lua`)

- `Logger:Debug(domain, message, metadata)`
- `Logger:Info(domain, message, metadata)`
- `Logger:Warn(domain, message, metadata)`
- `Logger:Error(domain, message, metadata)`
- `Logger:Critical(domain, message, metadata)`

### Model Management

- `Logger:SetModel("DEBUG")`
- `local currentModel = Logger:GetModel()`
- `if Logger:IsModel("DEBUG") then ... end`

### Advanced Logging

- `Logger:Performance("TIMING", "Database query", {duration=0.15})`

## 4. DOMAIN SYSTEM

Domain (seperti `SERVER`, `CLIENT`, `DATA`) didefinisikan dalam `src/ReplicatedStorage/OVHL/Config/LoggerConfig.lua`.

| Domain        | Emoji | Tujuan               |
| ------------- | ----- | -------------------- |
| `SERVER`      | 🚀    | Operasi server-side  |
| `CLIENT`      | 🎮    | Operasi client-side  |
| `DATA`        | 📊    | Alur data & state    |
| `CONFIG`      | ⚙️    | Sistem konfigurasi   |
| `SERVICE`     | 🔧    | Operasi Knit Service |
| `NETWORK`     | 🌐    | Networking & remotes |
| `UI`          | 📱    | User interface       |
| `PERMISSION`  | 🔐    | Auth & izin          |
| `PERFORMANCE` | ⚡    | Metrik performa      |
| `DEBUG`       | 🐛    | Informasi debug      |

## 5. MODEL SYSTEM

Model diatur di `LoggerConfig.lua` dan `EngineConfig.lua`.

| Model       | Levels                      | Use Case              |
| ----------- | --------------------------- | --------------------- |
| **SILENT**  | CRITICAL                    | Production live games |
| **NORMAL**  | INFO, WARN, ERROR, CRITICAL | Standard testing      |
| **DEBUG**   | DEBUG + NORMAL              | Active development    |
| **VERBOSE** | ALL + PERFORMANCE           | System analysis       |

## 6. BEST PRACTICES

### Metadata Usage

- **✅ BAIK:** `Logger:Error("DB", "Query failed", {query = "SELECT *", error = err})`
- **❌ BURUK:** `Logger:Error("DB", "Query SELECT * failed with error: " .. err)`

### Performance

Gunakan `IsModel` untuk kalkulasi yang mahal:

```lua
if Logger:IsModel("DEBUG") then
    Logger:Debug("NETWORK", "Raw packet data", {data = largeData})
end
```

---

> END OF ./docs/200_USER_GUIDES/210_API_REFERENCE/211_LOGGER.md
