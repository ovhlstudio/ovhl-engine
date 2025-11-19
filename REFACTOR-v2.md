# 📜 OVHL V2: THE ENTERPRISE RESCUE PROTOCOL

**Status:** APPROVED FOR EXECUTION
**Baseline V1:** 62 Files | 145KB | ~3000 Lines of Code
**Target V2:** \>80 Files | Full Absolute Paths | Config-Driven | Strict Security

## 1\. ARSITEKTUR "HARGA MATI" (Non-Negotiable)

Kita tidak akan mengulangi kesalahan "Lobotomi". Semua fitur V1 akan dibawa naik kelas.

- **Absolute Pathing:** Semua require menggunakan game.ReplicatedStorage.OVHL.... Haram hukumnya menggunakan script.Parent untuk lintas modul.

- **No Knit Dependency:** Kita membangun **"The V2 Bridge"** (Custom Networking + Promise + Lifecycle) menggantikan Knit.

- **Feature-Sliced Hybrid:** Struktur folder dibagi secara FISIK (Server/Client/Shared) demi keamanan, namun disatukan secara LOGIS via penamaan Folder Modul.

- **Strict UI Scanner:** UI Fallback System. Native UI harus 100% cocok komponennya, atau sistem otomatis membuangnya dan me-render Fusion UI.

- **Granular Security:** Permission dicek 2 lapis: Module Visibility (V1 Adapter) dan Action Guard (Network Middleware).

---

## 2\. ROADMAP EKSEKUSI (Phase by Phase)

Kita akan mengeksekusi ini dalam urutan linear. Tidak ada playtest sampai Fase 5 selesai.

### 🚧 FASE 0: CLEAN SLATE & STRUCTURE (Bash 01)

- **Target:** Membuat struktur direktori V2 yang kosong namun lengkap.

- **Files:** Setup folder _Index (Dependencies), Core (Engine), dan Modules.

- **Output:** Kerangka folder 5-Pilar yang valid.

### 🏗️ FASE 1: THE NEW CORE - SHARED (Bash 02)

- **Target:** Otak dari Engine (Shared Context).

- **Work:**

  - EngineEnums: Standardisasi nama sistem.

  - SharedConfigLoader: Deep merge logic untuk config.

  - **PermissionCore**: Logika parsing config permission V2 (Granular).

  - **UIEngine (Scanner)**: Algoritma BFS (Breadth-First Search) untuk memvalidasi Native UI vs Config Component.

### 🔒 FASE 2: THE SERVER INFRASTRUCTURE (Bash 03)

- **Target:** Pertahanan Server & Lifecycle.

- **Work:**

  - **Kernel.server**: Bootstrapper & Dependency Injection Container.

  - **NetworkBridge.server**: Pembuat RemoteEvent otomatis dari definisi Config.

  - NetworkGuard (Porting V1): Integrasi sanitasi input otomatis.

  - HDAdminAdapter (Porting V1): Wrapper server-side untuk permission gate.

  - RateLimiter (Porting V1): Mencegah spam remote.

### 🎮 FASE 3: THE CLIENT INFRASTRUCTURE (Bash 04)

- **Target:** Visual & Interaction Handling.

- **Work:**

  - **Kernel.client**: Bootstrapper Client.

  - **NetworkBridge.client**: Wrapper Promise untuk memanggil server tanpa hang.

  - TopbarPlusAdapter (Porting V1): Config-driven button spawner.

  - AssetLoader (Upgrade V1): Promise-based preload system.

  - Fusion (Injection): Setup library Fusion untuk fallback UI.

### 🚀 FASE 4: THE FIRST MODULE (MIGRASI PROTOTYPE SHOP) (Bash 05)

- **Target:** Pembuktian Konsep (Proof of Concept) & Migrasi V1 Logic.

- **Work:**

  - Memecah PrototypeShop V1 menjadi struktur 3-folder (Shared/Server/Client).

  - Implementasi **Master Config V2** (Granular Perms, Strict UI).

  - Implementasi Service (Logic Beli).

  - Implementasi Controller & View (Fusion Fallback).

### ✅ FASE 5: FINAL AUDIT & DEPLOY (Bash 06)

- **Target:** Cek integritas.

- **Work:** Verifikasi jumlah file, sintaks checker (luau-analyze jika ada, atau dummy load), dan reporting final.
