--[[
    OVHL ENGINE V1.2.2
    @Component: TopbarPlusAdapter (Navbar)
    @Fixes: Sends exact state (Selected=true, Deselected=false)
--]]
local TopbarPlusAdapter = {}
TopbarPlusAdapter.__index = TopbarPlusAdapter

function TopbarPlusAdapter.new()
    local self = setmetatable({}, TopbarPlusAdapter)
    self._logger = nil
    self._topbarplus = nil
    self._available = false
    self._buttons = {} 
    self._globalHandler = nil 
    self._initialized = false
    return self
end

function TopbarPlusAdapter:Initialize(logger)
    self._logger = logger
    if self._initialized then return end
    self._initialized = true
    local success, result = pcall(function()
        local RS = game:GetService("ReplicatedStorage")
        local module = RS:FindFirstChild("Icon") or 
                       (RS:FindFirstChild("Packages") and RS.Packages:FindFirstChild("Icon")) or
                       (RS:FindFirstChild("Packages") and RS.Packages:FindFirstChild("TopbarPlus"))
        if module then return require(module) end
        return nil
    end)
    if success and result then
        self._topbarplus = result
        self._available = true
        if result.IconController then pcall(function() result.IconController:clearIcons() end) end
        self._logger:Info("NAVBAR", "TopbarPlus Adapter V1.2.2 (State Sync)")
    else
        self._logger:Warn("NAVBAR", "TopbarPlus Not Found")
    end
end

function TopbarPlusAdapter:SetClickHandler(handler)
    self._globalHandler = handler
end

function TopbarPlusAdapter:AddButton(id, config)
    if not self._available then return false end
    if self._buttons[id] then pcall(function() self._buttons[id]:destroy() end) self._buttons[id] = nil end

    local IconLib = self._topbarplus
    local icon = IconLib.new()
    icon:setName(id)
    icon:setLabel(config.Text or id)
    if config.Icon then icon:setImage(config.Icon) end
    if config.Order then icon:setOrder(config.Order) end
    
    -- [CRITICAL] Handler menerima State eksplisit
    local function handleState(selectedIcon, isSelected)
        if selectedIcon ~= icon then return end -- Strict Check
        if self._globalHandler then
            self._globalHandler(id, isSelected) -- Kirim ID dan State
        end
    end

    -- Bind dengan state hardcoded
    icon:bindEvent("selected", function(i) handleState(i, true) end)
    icon:bindEvent("deselected", function(i) handleState(i, false) end)

    self._buttons[id] = icon
    return true
end

function TopbarPlusAdapter:RemoveButton(id)
    if self._buttons[id] then pcall(function() self._buttons[id]:destroy() end) self._buttons[id] = nil end
    return true
end
return TopbarPlusAdapter
