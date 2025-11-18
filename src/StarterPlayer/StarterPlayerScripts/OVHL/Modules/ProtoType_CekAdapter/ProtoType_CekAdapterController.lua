--[[
OVHL ENGINE V1.0.0
@Component: ProtoType_CekAdapterController
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Controller = Knit.CreateController { Name = "ProtoType_CekAdapterController" }

function Controller:KnitInit()
    self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
    self.UIManager = self.OVHL.GetSystem("UIManager")
    self.UIEngine = self.OVHL.GetSystem("UIEngine")
    self.Config = self.OVHL.GetClientConfig("ProtoType_CekAdapter")
    self.Service = Knit.GetService("ProtoType_CekAdapterService")
end

function Controller:KnitStart()
    self:SetupUI()
    self:SetupNavbar()
end

function Controller:SetupUI()
    -- Explicit Name: ProtoMain
    local screen = self.UIEngine:CreateScreen("ProtoMain", self.Config)
    self.UIManager:RegisterScreen("ProtoMain", screen)
    
    if not screen:FindFirstChild("Frame") then self:_mockUIStructure(screen) end
    
    local btnClose = self.UIManager:FindComponent("ProtoMain", "Btn_Close")
    if btnClose then
        self.UIManager:BindEvent(btnClose, "Activated", function() self.UIManager:HideScreen("ProtoMain") end)
    end
end

function Controller:SetupNavbar()
    -- PASS EXPLICIT ONCLICK FUNCTION
    self.UIManager:SetupTopbar("ProtoType_CekAdapter", self.Config, function()
        self.UIManager:ToggleScreen("ProtoMain")
    end)
end

function Controller:_mockUIStructure(screen)
    local frame = Instance.new("Frame", screen)
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 300, 0, 250)
    frame.Position = UDim2.new(0.5, -150, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    -- Add dummy content so user can see it opens
    local txt = Instance.new("TextLabel", frame)
    txt.Text = "PROTO ADAPTER UI"
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.new(1,1,1)
    
    local close = Instance.new("TextButton", frame)
    close.Name = "Btn_Close"
    close.Text = "CLOSE"
    close.Size = UDim2.new(0, 100, 0, 30)
    close.Position = UDim2.new(0.5, -50, 0.9, 0)
end

return Controller
