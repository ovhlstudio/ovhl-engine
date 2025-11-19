return {
	ModuleName = "MinimalModule",
	Version = "3.0.3",
	Enabled = true,
	UI = {
		DefaultMode = "AUTO",
		Screens = { MinimalMain = { Mode = "FUSION", FallbackMode = "NATIVE" } },
		Topbar = { Enabled = true, Icon = "rbxassetid://112605442047022", Text = "HELLO !!", Order = 1 },
	},
	Permissions = { BasicAction = { Rank = "NonAdmin" } },
	Security = { ValidationSchemas = { ActionData = { type = "table" } } },
}
