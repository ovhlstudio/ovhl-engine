return {
    Meta = {
        Name = "Inventory",
        Type = "Feature",
        Version = "2.0.0",
        Author = "OVHL Principal"
    },

    -- [FIXED] DIKEMBALIKAN AGAR TOPBAR PLUS DETECT
    Topbar = { 
        Enabled = true, 
        Text = "BAG", 
        Icon = "rbxassetid://3926305904", -- Backpack Icon
        Shortcut = Enum.KeyCode.I 
    },

    Behavior = { Debounce = 0.5, AutoFetch = true },
    
    UI = {
        Type = "Fusion",
        RootTag = "InventoryWindow", 
        Theme = "Dark",
        Defaults = { Title = "MY BACKPACK" }
    },

    Network = {
        Route = "Inventory",
        Requests = {
            GetItems = { Args = {}, RateLimit = {Max=10, Interval=5} },
            Equip = { Args = {"string"}, RateLimit = {Max=2, Interval=1} }
        }
    },
    
    Contract = { Provides = {"Toggle"}, Requires = {"DataManager"} }
}
