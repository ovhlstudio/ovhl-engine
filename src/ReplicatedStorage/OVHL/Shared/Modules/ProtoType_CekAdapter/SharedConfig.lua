--[[
OVHL ENGINE V1.0.0
@Component: ProtoType_CekAdapter (Shared Config)
@Path: ReplicatedStorage.OVHL.Shared.Modules.ProtoType_CekAdapter.SharedConfig
@Purpose: Config for Adapter & UI Manager Validation (FIXED ASSETS)
--]]

return {
    ModuleName = "ProtoType_CekAdapter",
    Version = "1.0.2",
    Enabled = true,

    UI = {
        DefaultMode = "FUSION",
        Screens = {
            MainUI = { Mode = "FUSION", FallbackMode = "NATIVE" } 
        },
        -- [FIX] Navbar Configuration
        Topbar = {
            Enabled = true,
            -- Icon Asli (Gambar Script/Dev) - Agar tidak blank
            Icon = "rbxassetid://4801884516", 
            
            -- Teks Jelas (Akan muncul di sebelah icon)
            Text = "TEST ADAPTER",
            
            -- Tooltip saat hover
            Tooltip = "Klik untuk Validasi Adapter",
            
            -- Order (Urutan) - Opsional
            Order = 1
        }
    },

    UI_Data = {
        StatusText = "🚀 OVHL SYSTEM: ONLINE (Config Driven)",
        TitleText = "🛡️ SECURITY CHECK"
    },
    
    Permissions = {
        CreatorAction = { Rank = "Owner", Description = "Hanya Creator yang bisa klik" },
        PublicAction = { Rank = "NonAdmin", Description = "Semua orang bisa klik" }
    },

    Security = {
        ValidationSchemas = {
            ButtonClick = {
                type = "table",
                fields = { btnName = { type = "string" } }
            }
        },
        RateLimits = {
            ClickAction = { max = 5, window = 2 }
        }
    }
}
--[[
@End: SharedConfig.lua
@Version: 1.0.2 (Fixed Icon)
--]]
