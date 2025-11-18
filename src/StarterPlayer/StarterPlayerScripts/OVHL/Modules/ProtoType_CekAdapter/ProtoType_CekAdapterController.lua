--[[
OVHL ENGINE V1.0.0
@Component: ProtoType_CekAdapterController
@Path: StarterPlayer.StarterPlayerScripts.OVHL.Modules.ProtoType_CekAdapter.ProtoType_CekAdapterController
@Purpose: Test UI Manager & Toast Notification
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Controller = Knit.CreateController { Name = "ProtoType_CekAdapterController" }

function Controller:KnitInit()
    self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
    self.Logger = self.OVHL:GetSystem("SmartLogger")
    self.UIManager = self.OVHL:GetSystem("UIManager")
    self.UIEngine = self.OVHL:GetSystem("UIEngine")
    self.Config = self.OVHL:GetClientConfig("ProtoType_CekAdapter")
    self.Service = Knit.GetService("ProtoType_CekAdapterService")
    
    self._toastJob = nil -- Untuk handle debounce/reset timer toast
end

function Controller:KnitStart()
    self:SetupUI()
    self:SetupNavbar()
end

function Controller:SetupUI()
    local screen = self.UIEngine:CreateScreen("MainUI", self.Config)
    self.UIManager:RegisterScreen("MainUI", screen)
    
    -- MOCK UI STRUCTURE (jika belum ada fusion)
    if not screen:FindFirstChild("Frame") then
        self:_mockUIStructure(screen)
    end
    
    -- Set Label from Config
    local lblStatus = self.UIManager:FindComponent("MainUI", "Lbl_DynamicStatus")
    if lblStatus then lblStatus.Text = self.Config.UI_Data.StatusText end

    -- Bind Buttons
    self:_bindButton("Btn_Creator")
    self:_bindButton("Btn_Public")
    
    local btnClose = self.UIManager:FindComponent("MainUI", "Btn_Close")
    if btnClose then
        self.UIManager:BindEvent(btnClose, "Activated", function()
            self.UIManager:HideScreen("MainUI")
        end)
    end
end

function Controller:_bindButton(btnName)
    local btn = self.UIManager:FindComponent("MainUI", btnName)
    if btn then
        self.UIManager:BindEvent(btn, "Activated", function()
            -- Feedback Klik
            self:ShowToast("⏳ Memproses...", Color3.fromRGB(255, 255, 100))
            
            self.Service:RequestClick(btnName):andThen(function(success, msg)
                if success then
                    self:ShowToast(msg, Color3.fromRGB(100, 255, 100)) -- Hijau
                    self.Logger:Info("UI", "Success", {msg=msg})
                else
                    self:ShowToast(msg, Color3.fromRGB(255, 100, 100)) -- Merah
                    self.Logger:Warn("UI", "Failed", {msg=msg})
                end
            end)
        end)
    end
end

function Controller:ShowToast(text, color)
    local frameToast = self.UIManager:FindComponent("MainUI", "FrameToast")
    local lblToast = self.UIManager:FindComponent("MainUI", "Lbl_Toast")
    
    if frameToast and lblToast then
        lblToast.Text = text
        lblToast.TextColor3 = color or Color3.fromRGB(255, 255, 255)
        frameToast.Visible = true
        
        -- Reset timer auto-close
        if self._toastJob then task.cancel(self._toastJob) end
        
        self._toastJob = task.delay(3, function()
            frameToast.Visible = false
        end)
    end
end

function Controller:SetupNavbar()
    self.UIManager:SetupTopbar("ProtoType_CekAdapter", self.Config)
end

-- HELPER: Buat UI Dummy secara Script (karena tidak ada file .rbxm)
function Controller:_mockUIStructure(screen)
    local frame = Instance.new("Frame", screen)
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 300, 0, 250)
    frame.Position = UDim2.new(0.5, -150, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0

    local title = Instance.new("TextLabel", frame)
    title.Name = "Title"
    title.Text = "TEST ADAPTER"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18

    local lbl = Instance.new("TextLabel", frame)
    lbl.Name = "Lbl_DynamicStatus"
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.Position = UDim2.new(0, 0, 0, 30)
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Loading..."

    -- TOAST FRAME
    local toast = Instance.new("Frame", frame)
    toast.Name = "FrameToast"
    toast.Size = UDim2.new(0.9, 0, 0, 40)
    toast.Position = UDim2.new(0.05, 0, 0.8, 0)
    toast.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    toast.Visible = false -- Hidden by default
    toast.ZIndex = 10
    
    local toastCorner = Instance.new("UICorner", toast)
    toastCorner.CornerRadius = UDim.new(0, 8)

    local lblToast = Instance.new("TextLabel", toast)
    lblToast.Name = "Lbl_Toast"
    lblToast.Size = UDim2.new(1, 0, 1, 0)
    lblToast.BackgroundTransparency = 1
    lblToast.TextColor3 = Color3.fromRGB(255, 255, 255)
    lblToast.Text = "Toast Message"
    lblToast.Font = Enum.Font.GothamMedium
    lblToast.ZIndex = 11

    -- BUTTONS
    local function mkBtn(name, text, y, color)
        local b = Instance.new("TextButton", frame)
        b.Name = name
        b.Text = text
        b.Size = UDim2.new(0.9, 0, 0, 35)
        b.Position = UDim2.new(0.05, 0, 0, y)
        b.BackgroundColor3 = color
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.Gotham
        local c = Instance.new("UICorner", b)
        c.CornerRadius = UDim.new(0, 6)
        return b
    end

    mkBtn("Btn_Creator", "👑 Sultan Only (Owner)", 60, Color3.fromRGB(255, 170, 0))
    mkBtn("Btn_Public", "🌍 Rakyat Biasa (Everyone)", 105, Color3.fromRGB(0, 170, 255))
    mkBtn("Btn_Close", "❌ Tutup", 150, Color3.fromRGB(200, 50, 50))
end

return Controller
