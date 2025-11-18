--[[
OVHL FRAMEWORK V.1.0.1
@Component: InternalAdapter (Navbar)
@Path: ReplicatedStorage.OVHL.Systems.Adapters.Navbar.InternalAdapter
@Purpose: Native UI Navbar (High Visibility & IDEMPOTENT)
@Stability: STABLE
--]]

local InternalAdapter = {}
InternalAdapter.__index = InternalAdapter
local Players = game:GetService("Players")

function InternalAdapter.new()
    local self = setmetatable({}, InternalAdapter)
    self._logger = nil
    self._gui = nil
    self._container = nil
    self._buttons = {} -- Cache registry
    return self
end

function InternalAdapter:Initialize(logger)
    self._logger = logger
end

function InternalAdapter:_ensureGui()
    local player = Players.LocalPlayer
    if not player then return end
    local pg = player:WaitForChild("PlayerGui")
    
    if self._gui and self._gui.Parent then return end
    
    -- Destroy old GUI if exists to prevent ghosts
    local old = pg:FindFirstChild("OVHL_Internal_Navbar")
    if old then old:Destroy() end
    
    local sg = Instance.new("ScreenGui")
    sg.Name = "OVHL_Internal_Navbar"
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 999
    sg.Parent = pg
    
    local fr = Instance.new("Frame", sg)
    fr.Name = "Bar"
    fr.Size = UDim2.new(1, 0, 0, 44)
    fr.Position = UDim2.new(0, 0, 0, 0)
    fr.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    fr.BackgroundTransparency = 0.2
    
    local list = Instance.new("UIListLayout", fr)
    list.FillDirection = Enum.FillDirection.Horizontal
    list.Padding = UDim.new(0, 4)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Left
    
    local pad = Instance.new("UIPadding", fr)
    pad.PaddingLeft = UDim.new(0, 100)
    pad.PaddingTop = UDim.new(0, 4)
    
    self._gui = sg
    self._container = fr
end

function InternalAdapter:AddButton(id, config)
    self:_ensureGui()
    
    -- [CRITICAL FIX] CLEANUP OLD BUTTON IF EXISTS
    if self._buttons[id] then
        pcall(function() self._buttons[id]:Destroy() end)
        self._buttons[id] = nil
    end
    
    local btn = Instance.new("TextButton")
    btn.Name = id
    -- TAMPILKAN ID JIKA TEXT SAMA (DEBUGGING VISUAL)
    btn.Text = config.Text or id
    btn.Size = UDim2.new(0, 120, 1, -8)
    btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = self._container
    
    local uc = Instance.new("UICorner", btn); uc.CornerRadius = UDim.new(0,6)
    
    btn.MouseButton1Click:Connect(function()
        print("🖱️ INTERNAL NAV CLICKED:", id) -- Debug Print
        if config.OnClick then 
            local s, e = pcall(config.OnClick) 
            if not s then warn("OnClick Error:", e) end
        else
            warn("No OnClick handler for", id)
        end
    end)
    
    self._buttons[id] = btn
    return true
end

function InternalAdapter:RemoveButton(id) 
    if self._buttons[id] then 
        self._buttons[id]:Destroy()
        self._buttons[id] = nil
    end
    return true 
end

function InternalAdapter:SetButtonActive(id, active) return true end

return InternalAdapter
--[[ @End: InternalAdapter.lua ]]
