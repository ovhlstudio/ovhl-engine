--[[
OVHL ENGINE V1.0.0
@Component: TopbarPlusAdapter (Navbar)
@Path: ReplicatedStorage.OVHL.Systems.Adapters.Navbar.TopbarPlusAdapter
@Purpose: Bridge to TopbarPlus V3 API
@Stability: BETA
--]]

local TopbarPlusAdapter = {}
TopbarPlusAdapter.__index = TopbarPlusAdapter

function TopbarPlusAdapter.new()
    local self = setmetatable({}, TopbarPlusAdapter)
    self._logger = nil
    self._topbarplus = nil
    self._available = false
    self._buttons = {}
    return self
end

function TopbarPlusAdapter:Initialize(logger)
    self._logger = logger
    
    local success, TopbarPlus = pcall(function()
        return require(game:GetService("ReplicatedStorage"):FindFirstChild("Icon"))
    end)
    
    if success and TopbarPlus then
        self._topbarplus = TopbarPlus
        self._available = true
        self._logger:Info("NAVBAR", "TopbarPlusAdapter connected to TopbarPlus")
    else
        self._logger:Warn("NAVBAR", "TopbarPlus not available - fallback to Internal")
    end
end

function TopbarPlusAdapter:IsAvailable()
    return self._available and self._topbarplus ~= nil
end

function TopbarPlusAdapter:AddButton(buttonId, config)
    if not self:IsAvailable() then
        return false, "TopbarPlus not available"
    end
    
    local success, button = pcall(function()
        return self._topbarplus:createButton({
            Name = config.Name or buttonId,
            Icon = config.Icon or "rbxassetid://0",
            Text = config.Text or "Button",
            Tooltip = config.Tooltip or config.Text or "Button",
            OnClick = config.OnClick or function() end
        })
    end)
    
    if success and button then
        self._buttons[buttonId] = button
        self._logger:Debug("NAVBAR", "TopbarPlus button created", {
            button = buttonId,
            text = config.Text
        })
        return true
    else
        self._logger:Warn("NAVBAR", "Failed to create TopbarPlus button", {
            button = buttonId,
            error = tostring(button)
        })
        return false
    end
end

function TopbarPlusAdapter:RemoveButton(buttonId)
    if self._buttons[buttonId] then
        pcall(function()
            self._buttons[buttonId]:Destroy()
        end)
        self._buttons[buttonId] = nil
        return true
    end
    return false
end

function TopbarPlusAdapter:SetButtonActive(buttonId, active)
    if self._buttons[buttonId] then
        pcall(function()
            if active then
                self._buttons[buttonId]:Show()
            else
                self._buttons[buttonId]:Hide()
            end
        end)
        return true
    end
    return false
end

return TopbarPlusAdapter

--[[
@End: TopbarPlusAdapter.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]
