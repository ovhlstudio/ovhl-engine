--[[
	OVHL FRAMEWORK V.1.3.0 - TOPBARPLUS ADAPTER (EVENT EMITTER)
	@Component: TopbarPlusAdapter
	@Changes: No internal callback storage. Emits ID to handler.
--]]

local TopbarPlusAdapter = {}
TopbarPlusAdapter.__index = TopbarPlusAdapter

function TopbarPlusAdapter.new()
	local self = setmetatable({}, TopbarPlusAdapter)
	self._logger = nil
	self._topbarplus = nil
	self._available = false
	self._buttons = {} 
	self._globalHandler = nil -- Satu handler untuk semua tombol
	self._initialized = false
	return self
end

function TopbarPlusAdapter:Initialize(logger)
	self._logger = logger
	if self._initialized then return end
	self._initialized = true

	local success, result = pcall(function()
		local module = game:GetService("ReplicatedStorage"):FindFirstChild("Icon")
		if module then return require(module) end
		local packages = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
		if packages then return require(packages:FindFirstChild("Icon") or packages:FindFirstChild("TopbarPlus")) end
		return nil
	end)

	if success and result then
		self._topbarplus = result
		self._available = true
		if result.IconController then pcall(function() result.IconController:clearIcons() end) end
		self._logger:Info("NAVBAR", "Adapter V1.3 Ready")
	end
end

-- UIManager akan nitip fungsi dispatch disini
function TopbarPlusAdapter:SetClickHandler(handler)
	self._globalHandler = handler
end

function TopbarPlusAdapter:AddButton(id, config)
	if not self._available then return false end
	
	-- Bersih-bersih zombie
	if self._buttons[id] then pcall(function() self._buttons[id]:destroy() end) end

	local IconLib = self._topbarplus
	local icon = IconLib.new()
	
	icon:setName(id) -- ID ini yang akan dikirim balik
	icon:setLabel(config.Text or id)
	if config.Icon then icon:setImage(config.Icon) end
	if config.Order then icon:setOrder(config.Order) end
	
	-- SATU LOGIC UNTUK SEMUA: Lapor ID ke Global Handler
	local reportClick = function()
		if self._globalHandler then
			self._globalHandler(id) -- Kirim "MinimalModule" atau "PrototypeShop"
		else
			warn("Navbar: No handler connected!")
		end
	end

	icon:bindEvent("selected", reportClick)
	icon:bindEvent("deselected", reportClick)

	self._buttons[id] = icon
	return true
end

function TopbarPlusAdapter:RemoveButton(id)
	if self._buttons[id] then
		pcall(function() self._buttons[id]:destroy() end)
		self._buttons[id] = nil
	end
end

return TopbarPlusAdapter
