return {
    ModuleName = "ProtoType_CekAdapter",
    Version = "1.0.5",
    Enabled = true,
    UI = {
        DefaultMode = "FUSION",
        Screens = { ProtoMain = { Mode = "FUSION", FallbackMode = "NATIVE" } },
        Topbar = { Enabled = true, Icon = "rbxassetid://4801884516", Text = "ADAPTER TEST", Order = 2 }
    },
    Permissions = { PublicAction = { Rank = "NonAdmin" } },
    Security = { ValidationSchemas = { ButtonClick = { type = "table" } } }
}
