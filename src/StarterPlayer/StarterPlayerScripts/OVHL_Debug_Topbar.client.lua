--[[
    OVHL DEBUGGER: TOPBARPLUS PROBE
    Purpose: Menguji ketersediaan dan API TopbarPlus secara langsung
    Run Context: Client
]]

task.wait(3) -- Tunggu boot selesai
print("\n========================================")
print("🕵️‍♂️ [DEBUG] MEMULAI DIAGNOSA TOPBARPLUS")
print("========================================")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. CEK KEBERADAAN FILE
local iconModule = ReplicatedStorage:FindFirstChild("Icon")
if iconModule then
    print("✅ [1] Module 'Icon' DITEMUKAN di ReplicatedStorage")
    print("      Type:", iconModule.ClassName)
else
    warn("❌ [1] Module 'Icon' TIDAK DITEMUKAN di ReplicatedStorage!")
    print("      Pastikan Anda menginstal TopbarPlus v3")
    return -- Stop diagnostic
end

-- 2. CEK REQUIRE & API
local success, IconLib = pcall(require, iconModule)
if success then
    print("✅ [2] Module berhasil di-require")
    print("      Isi Table Module:")
    for k, v in pairs(IconLib) do
        print("      - " .. tostring(k) .. " (" .. type(v) .. ")")
    end
    
    -- 3. TEST PEMBUATAN MANUAL (RAW TEST)
    print("⏳ [3] Mencoba membuat Icon manual (Bypassing OVHL)...")
    
    local testIcon
    local createSuccess, err = pcall(function()
        -- Coba deteksi metode yang tersedia
        if IconLib.new then
            print("      ℹ️ Menggunakan metode: Icon.new()")
            testIcon = IconLib.new()
        elseif IconLib.createButton then
             print("      ℹ️ Menggunakan metode: Icon:createButton()")
            testIcon = IconLib:createButton()
        else
             error("Tidak menemukan metode .new() atau :createButton()")
        end
        
        -- Set properti dasar
        if testIcon then
            testIcon:setLabel("DEBUG UI")
            testIcon:setCaption("Ini tes manual")
            testIcon:setImage("rbxassetid://4801884516")
        end
    end)
    
    if createSuccess then
        print("✅ [3] Icon Manual BERHASIL dibuat! Cek Topbar Anda.")
    else
        warn("❌ [3] GAGAL membuat Icon manual:", err)
    end
    
else
    warn("❌ [2] Gagal require module Icon:", IconLib)
end

-- 4. CEK DATA OVHL
print("⏳ [4] Mengecek Config OVHL...")
local successOVHL, OVHL = pcall(function() 
    return require(ReplicatedStorage.OVHL.Core.OVHL) 
end)

if successOVHL then
    local config = OVHL.GetClientConfig("ProtoType_CekAdapter")
    if config then
        print("✅ [4] Config ProtoType ditemukan")
        print("      Topbar Enabled:", config.UI.Topbar.Enabled)
        print("      Icon Asset:", config.UI.Topbar.Icon)
    else
        warn("⚠️ [4] Config ProtoType TIDAK ditemukan di Client")
    end
else
    warn("⚠️ [4] Gagal akses OVHL Core")
end

print("========================================")
print("🕵️‍♂️ [DEBUG] DIAGNOSA SELESAI")
print("========================================\n")
