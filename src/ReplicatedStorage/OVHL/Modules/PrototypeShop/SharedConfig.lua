--[[ @Component: SharedConfig (Data Driven) ]]
return {
	Identity = { Name = "PrototypeShop", Version = "2.1" },

	Permission = {
		Actions = { Buy = 0, Restock = 4 }, -- Guest / Admin
	},

	Topbar = {
		Enabled = true,
		Text = "KLIK SHOP",
		Icon = "rbxassetid://112605442047022",
		Shortcut = Enum.KeyCode.P,
	},

	UI = {
		NativeTarget = "ShopNativeUI",

		-- MAPPING KE LOGIC/SCANNER
		Components = {
			-- Format: LogicName = { Name="NativeInstanceName", ... }
			HeaderLabel = { Name = "Txt_Header" },
			InfoLabel = { Name = "Txt_Info" },
			BuyBtn = { Name = "Btn_Buy" },
			CancelBtn = { Name = "Btn_Close" },
		},

		-- DATA TEKS (SOURCE OF TRUTH)
		-- Controller akan menyuntikkan ini ke UI (Baik Native maupun Fusion)
		Defaults = {
			HeaderLabel = "LEGENDARY ARMORY",
			InfoLabel = "Item: Fire Sword\nPrice: 1.500 Coins",
			BuyBtn = "PURCHASE SWORD",
			CancelBtn = "CLOSE MENU",
		},
	},

	Network = {
		Requests = {
			BuyItem = { Args = { "string" }, Action = "Buy", RateLimit = { Max = 5, Interval = 2 } },
		},
	},
}
