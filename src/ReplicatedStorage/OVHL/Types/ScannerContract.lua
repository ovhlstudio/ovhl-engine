--[[
OVHL ENGINE V1.0.0
@Component: ScannerContract (Types)
@Path: ReplicatedStorage.OVHL.Types.ScannerContract
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.2.2
@Component: ScannerContract (Core Types)
@Path: ReplicatedStorage.OVHL.Types.ScannerContract
@Purpose: Mendefinisikan kontrak data antara Bootstrap (Scanner) dan SystemRegistry (Orchestrator).
--]]

--[[
    Kontrak ini adalah "Single Source of Truth" untuk metadata sistem.
    Sesuai ADR V3.2.2 (Explicit Sibling Manifests).
--]]

-- Definsi Manifest yang dibaca dari *Manifest.lua
export type SystemManifest = {
    -- Nama sistem, wajib cocok dengan nama file *.lua utama
    name: string,
    
    -- Daftar dependensi (nama sistem lain)
    dependencies: {string},
    
    -- Path ke ModuleScript utama (diisi oleh Scanner)
    modulePath: ModuleScript,
    
    -- Prioritas load (opsional, untuk fine-tuning)
    priority: number?
}

-- Hasil yang dikirim oleh Bootstrap.ScanManifests()
export type ScanResult = {
    -- Daftar manifest yang berhasil dipindai
    manifests: {SystemManifest},
    
    -- Daftar error (misal: manifest rusak, dependensi hilang)
    errors: {[string]: string}?,
    
    -- Daftar sistem V3.1.0 (legacy, tanpa manifest)
    unmigrated: {ModuleScript}?
}


return nil

--[[
@End: ScannerContract.lua
@Version: 3.2.2
@See: docs/ADR_V3-2-2.md (Nanti kita buat)
--]]

--[[
@End: ScannerContract.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

