return {
    Identity = { Name = "Inventory", Version = "1.0" },
    
    -- Permissions
    Permission = { Actions = { Open = 0, Equip = 0 } },

    -- Topbar
    Topbar = { 
        Enabled = true, 
        Text = "BAG", 
        Icon = "rbxassetid://3926305904", -- Placeholder Backpack
        Shortcut = Enum.KeyCode.I 
    },

    -- UI
    UI = {
        NativeTarget = "InventoryNative",
        Components = {}, -- Kita langsung pakai Fusion untuk demo ini
        Defaults = { Title = "MY BACKPACK" }
    },

    -- Network
    Network = {
        Requests = {
            GetItems = { Args={}, Action="Open" },
            Equip = { Args={"string"}, Action="Equip", RateLimit={Max=2, Interval=1} }
        }
    }
}
