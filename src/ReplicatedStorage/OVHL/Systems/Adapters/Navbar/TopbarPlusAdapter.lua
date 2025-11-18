--[[
OVHL FRAMEWORK V.1.0.1
@Component: TopbarPlusAdapter (Navbar)
@Path: ReplicatedStorage.OVHL.Systems.Adapters.Navbar.TopbarPlusAdapter
@Purpose: Bridge to TopbarPlus V3 API (Robust & Idempotent)
--]]

local TopbarPlusAdapter = {}
TopbarPlusAdapter.__index = TopbarPlusAdapter

function TopbarPlusAdapter.new()
    local self = setmetatable({}, TopbarPlusAdapter)
    self._logger = nil
    self._topbarplus = nil
    self._available = false
    self._buttons = {} -- Cache registry
    return self
end

function TopbarPlusAdapter:Initialize(logger)
    self._logger = logger
    local success, result = pcall(function()
        local module = game:GetService("ReplicatedStorage"):FindFirstChild("Icon") 
        if module then return require(module) end
        local packages = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
        if packages then
            local iconPkg = packages:FindFirstChild("Icon") or packages:FindFirstChild("TopbarPlus")
            if iconPkg then return require(iconPkg) end
        end
        return nil
    end)
    if success and result then
        self._topbarplus = result
        self._available = true
        self._logger:Info("NAVBAR", "TopbarPlusAdapter connected")
    else
        self._logger:Warn("NAVBAR", "TopbarPlus module not found")
    end
end

function TopbarPlusAdapter:IsAvailable() return self._available and self._topbarplus ~= nil end

function TopbarPlusAdapter:AddButton(buttonId, config)
    if not self:IsAvailable() then return false end
    
    -- [PHASE 3 FIX] Force Cleanup Old Button (Idempotency)
    -- Jangan cuma cek if exists, tapi hancurkan dulu biar fresh.
    if self._buttons[buttonId] then
        self._logger:Debug("NAVBAR", "Refreshing existing button", {id = buttonId})
        pcall(function() 
            self._buttons[buttonId]:destroy() 
        end)
        self._buttons[buttonId] = nil
    end
    
    local iconLib = self._topbarplus
    local iconInstance = nil
    
    -- Robust Construction
    local success, err = pcall(function()
        if type(iconLib.new) == "function" then iconInstance = iconLib.new()
        elseif iconLib.createButton then iconInstance = iconLib:createButton()
        elseif type(iconLib) == "table" and getmetatable(iconLib) and getmetatable(iconLib).__call then iconInstance = iconLib()
        end
    end)
    
    if not success or not iconInstance then
        self._logger:Warn("NAVBAR", "Failed to construct Icon", {error = err})
        return false
    end
    
    -- Apply Config
    pcall(function()
        iconInstance:setName(config.Name or buttonId)
        iconInstance:setLabel(config.Text or buttonId)
        if config.Icon then iconInstance:setImage(config.Icon) end
        if config.Tooltip then iconInstance:setCaption(config.Tooltip) end
        if config.Order then iconInstance:setOrder(config.Order) end
        
        if config.OnClick then
            -- Support binding methods v2/v3
            if iconInstance.bindEvent then
                iconInstance:bindEvent("selected", function() config.OnClick() end)
                iconInstance:bindEvent("deselected", function() config.OnClick() end)
            else
                 iconInstance.selected:Connect(function() config.OnClick() end)
                 iconInstance.deselected:Connect(function() config.OnClick() end)
            end
        end
    end)
    
    self._buttons[buttonId] = iconInstance
    self._logger:Debug("NAVBAR", "TopbarPlus button created", {id = buttonId})
    return true
end

function TopbarPlusAdapter:RemoveButton(buttonId)
    local btn = self._buttons[buttonId]
    if btn then 
        pcall(function() btn:destroy() end)
        self._buttons[buttonId] = nil
        return true 
    end
    return false
end

function TopbarPlusAdapter:SetButtonActive(buttonId, active)
    local btn = self._buttons[buttonId]
    if btn then 
        pcall(function() 
            if active then btn:setEnabled(true) else btn:setEnabled(false) end 
        end)
        return true 
    end
    return false
end

return TopbarPlusAdapter
