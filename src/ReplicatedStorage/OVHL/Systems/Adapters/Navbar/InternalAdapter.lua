--[[
OVHL ENGINE V1.0.0
@Component: InternalAdapter (Navbar)
@Path: ReplicatedStorage.OVHL.Systems.Adapters.Navbar.InternalAdapter
@Purpose: Native UI Navbar implementation (Fallback for TopbarPlus)
@Stability: STABLE
--]]

local InternalAdapter = {}
InternalAdapter.__index = InternalAdapter

local Players = game:GetService("Players")

function InternalAdapter.new()
    local self = setmetatable({}, InternalAdapter)
    self._logger = nil
    self._buttons = {} -- {id = {config, instance}}
    self._gui = nil
    self._container = nil
    return self
end

function InternalAdapter:Initialize(logger)
    self._logger = logger
    self._logger:Info("NAVBAR", "InternalAdapter initialized (Native UI Mode)")
end

function InternalAdapter:_ensureGui()
    local player = Players.LocalPlayer
    if not player then return end
    
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Prevent duplicate
    if self._gui and self._gui.Parent then return end
    
    local screen = Instance.new("ScreenGui")
    screen.Name = "OVHL_InternalNavbar"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.DisplayOrder = 100 -- Always on top
    
    -- Container (Top Bar Area)
    local container = Instance.new("Frame", screen)
    container.Name = "Container"
    container.Size = UDim2.new(1, 0, 0, 40) -- Height 40px
    container.Position = UDim2.new(0, 0, 0, 0)
    container.BackgroundTransparency = 1
    
    -- Layout
    local layout = Instance.new("UIListLayout", container)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Padding
    local padding = Instance.new("UIPadding", container)
    padding.PaddingTop = UDim.new(0, 4)
    
    screen.Parent = playerGui
    self._gui = screen
    self._container = container
end

function InternalAdapter:AddButton(buttonId, config)
    self:_ensureGui()
    
    if self._buttons[buttonId] then
        self._logger:Warn("NAVBAR", "Button already exists", {id=buttonId})
        return false
    end
    
    local btn = Instance.new("TextButton")
    btn.Name = buttonId
    btn.Text = config.Text or buttonId
    btn.Size = UDim2.new(0, 100, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.Parent = self._container
    
    -- Styling
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    -- Events
    btn.MouseButton1Click:Connect(function()
        if config.OnClick then
            pcall(config.OnClick)
        end
    end)
    
    self._buttons[buttonId] = {
        config = config,
        instance = btn
    }
    
    self._logger:Debug("NAVBAR", "Internal Button Created", {id=buttonId})
    return true
end

function InternalAdapter:RemoveButton(buttonId)
    local data = self._buttons[buttonId]
    if data and data.instance then
        data.instance:Destroy()
        self._buttons[buttonId] = nil
        return true
    end
    return false
end

function InternalAdapter:SetButtonActive(buttonId, active)
    local data = self._buttons[buttonId]
    if data and data.instance then
        data.instance.Visible = active
        return true
    end
    return false
end

return InternalAdapter

--[[
@End: InternalAdapter.lua
@Version: 1.1.0 (Visual Implementation)
--]]
