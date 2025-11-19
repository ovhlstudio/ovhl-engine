return {
	ModuleName = "PrototypeShop",
	Version = "1.1.0", -- Bump Version
	Enabled = true,
	UI = {
		DefaultMode = "NATIVE",
		Screens = { ShopMain = { Mode = "NATIVE" } },
		Topbar = {
			Enabled = true,
			Icon = "rbxassetid://6031225837",
			Text = "SHOP",
			Order = 5,
		},
	},
	-- Security Rules
	Security = {
		ValidationSchemas = {
			-- Schema Data Transaksi
			BuyItem = { type = "table", fields = { itemId = { type = "string" }, amount = { type = "number" } } },
		},
		-- Anti Spam: Max 3 request per 10 detik
		RateLimits = { BuyItem = { max = 3, window = 10 } },
	},
	-- Permission: Hanya NonAdmin ke atas (Semua player) bisa beli
	Permissions = { BuyItem = { Rank = "NonAdmin" } },
}
