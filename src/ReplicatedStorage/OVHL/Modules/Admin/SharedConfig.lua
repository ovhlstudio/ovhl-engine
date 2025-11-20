return {
    Meta = { 
        Name = "Admin", 
        Type = "System", 
        Version = "2.0.0" 
    },
    
    -- [FIXED] Config dikembalikan ke sini. 
    -- Kernel akan otomatis membaca ini dan mendaftarkan Topbar Icon.
    Topbar = {
        Enabled = true,
        Text = "ADMIN",
        Icon = "rbxassetid://3926305904",
        Permission = 3, -- Min Rank 3 (Admin)
        Order = 99      -- Paling kanan
    },
    
    Network = {
        Route = "PermissionSystem", -- Route ke Service Permission (Bukan module Admin terpisah)
        Requests = {} 
        -- Note: Karena Admin Panel nembak 'PermissionSystem' (Core Service), 
        -- config network disini kosong gapapa, atau bisa dihapus kalau mau strict.
    }
}
