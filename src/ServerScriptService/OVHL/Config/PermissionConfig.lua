--[[ @Component: PermissionConfig (Internal Fallback DB) ]]
return {
    -- Setting Global
    Settings = {
        OwnerIsSuperAdmin = true,
        DebugMode = true
    },

    -- INTERNAL USER LIST (FALLBACK ONLY)
    -- Digunakan HANYA JIKA 3rd Party (HD Admin) tidak ditemukan
    -- Format: [UserId] = RankLevel
    Users = {
        [game.CreatorId] = 5, -- Auto detect owner as fallback
        -- [12345678] = 4,    -- Contoh Head Admin manual
    },

    -- INTERNAL GROUPS (FALLBACK ONLY)
    Groups = {
        -- Format: { GroupId = 0000, RankId = 255, Role = 5 }
    }
}
