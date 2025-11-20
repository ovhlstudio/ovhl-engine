local Srv = {}

function Srv:Init(ctx)
	self.Log = ctx.Logger
end
function Srv:Start() end

-- Simulate Database Data
local MOCK_DB = {
	{ Id = "item_001", Name = "INI ADALAH ITEM", Rarity = "Common", Power = 10 },
	{ Id = "item_002", Name = "Iron Sword", Rarity = "Uncommon", Power = 25 },
	{ Id = "item_003", Name = "Golden Bow", Rarity = "Rare", Power = 40 },
	{ Id = "item_004", Name = "Dragon Slayer", Rarity = "Legendary", Power = 999 },
	{ Id = "item_005", Name = "Wooden Shield", Rarity = "Common", Power = 5 },
	{ Id = "item_006", Name = "Health Potion", Rarity = "Consumable", Power = 0 },
	{ Id = "item_007", Name = "Mana Potion", Rarity = "Consumable", Power = 0 },
	{ Id = "item_008", Name = "Magic Scroll", Rarity = "Epic", Power = 0 },
}

function Srv:GetItems(player)
	-- Simulasi delay network
	task.wait(0.2)
	return { Success = true, Data = MOCK_DB }
end

function Srv:Equip(player, itemId)
	self.Log:Info("Equip", { Plr = player.Name, Item = itemId })
	return { Success = true, Msg = "Equipped " .. itemId }
end

return Srv
