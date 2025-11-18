return {
    ModuleName = "MinimalModule",
    Version = "3.0.3",
    Enabled = true,
    UI = {
        DefaultMode = "AUTO",
        Screens = { MinimalMain = { Mode = "FUSION", FallbackMode = "NATIVE" } },
        Topbar = { Enabled = true, Icon = "rbxassetid://1234567890", Text = "MINIMAL V3", Order = 1 }
    },
    Permissions = { BasicAction = { Rank = "NonAdmin" } },
    Security = { ValidationSchemas = { ActionData = { type = "table" } } }
}
