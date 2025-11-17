# ⚙️ CORE INTERNAL MECHANICS (DEEP DIVE)

> **STATUS:** FINAL
> **TUJUAN:** Menjelaskan detail teknis "Black Box" engine agar rebuild bisa dilakukan tanpa error.

---

## 1. THE BOOT SEQUENCE (Urutan Nyala)

OVHL V3.0.0 menggunakan urutan booting deterministik.

### FASE 1: RUNTIME WAKE UP

File `ServerRuntime.server.lua` berjalan.

1.  **Patching:** Helper function lokal (seperti penghitung tabel) didefinisikan di sini jika Luau tidak menyediakannya.
2.  **Bootstrap Call:** Memanggil `Bootstrap:Initialize()`.

### FASE 2: SMART DISCOVERY (Bootstrap)

Bootstrap melakukan scanning dengan aturan ketat:

1.  **Environment Check:** Memisahkan `Server` dan `Client`.
2.  **Manual Foundation:** `SmartLogger` dimuat manual pertama kali agar log tersedia dari detik ke-0.
3.  **Recursive Pathing:** Menggunakan fungsi traversal custom (bukan `FindFirstChild` biasa) untuk membaca path sistem.
4.  **Registration:** Mendaftarkan sistem ke `SystemRegistry` beserta dependensi-nya (yang didefinisikan di lokal tabel `systemDependencies`).

### FASE 3: DEPENDENCY RESOLUTION

`SystemRegistry` melakukan _Topological Sort_:

1.  **Input:** Daftar sistem tak berurutan.
2.  **Process:** Cek dependensi. Jika A butuh B, B harus load duluan.
3.  **Output:** Array linier (Contoh: Config -> Logger -> Validator -> UIEngine).
4.  **Execution:** Loop array ini dan panggil `:Initialize(Logger)`.

### FASE 4: KNIT BRIDGE (Kernel)

1.  **Module Scan:** Kernel mencari Folder di `ServerScriptService` (Service) dan `PlayerScripts` (Controller).
2.  **Knit Registration:**
    - Kernel menggunakan `knit:GetService` (Colon syntax) untuk memanggil internal Knit.
    - _Safety:_ Ada fallback try-catch untuk menangani module yang gagal load tanpa mematikan seluruh engine.

---

## 2. DATA FLOW & SECURITY PIPELINE

Bagaimana data mengalir tanpa `Double Register Bug` dan `Permission Denied`?

```mermaid
graph TD
    A[Client Controller] -->|Kirim Data Sesuai Schema| B[Networking Router]
    B --> C{Security Middleware}
    C -->|Validasi| D[Input Validator]
    D -->|Cek Schema| D1{Tipe Data Cocok?}
    D1 -->|Tidak (String vs Table)| X[Tolak Request]
    D1 -->|Ya| E[Rate Limiter]
    E -->|Cek Spam| F[Permission Core]
    F -->|Cek Rank (HD Admin Style)| F1{Rank Cukup?}
    F1 -->|Kurang| X
    F1 -->|Cukup| G[Service Logic]
    G -->|Execute| H[Return Success/Fail]
```

---

## 3. UI RENDERING PIPELINE (FUSION 0.3 SCOPED)

Ini bagian paling kritikal untuk menghindari error `scopeMissing`.

1.  **Request:** `MinimalController` memanggil `UIEngine:CreateScreen`.
2.  **Scope Init:** `UIEngine` secara internal membuat `local scope = Fusion.scoped(Fusion)`.
3.  **Component Creation:**
    - Semua komponen dibuat menggunakan `scope:New "ClassName" {}`.
    - **PENTING:** Event listener (`OnEvent`) di-bind menggunakan closure yang aman di dalam scope.
4.  **Cleanup:** Saat `HideScreen` dipanggil, scope dibersihkan (`scope:doCleanup()`) untuk menghapus semua event connection dan instance.
