--[[
    OVHL ENGINE V1.2.0
    @Component: Install_Mock_UI
    @Path: src/ServerScriptService/OVHL/Debug_MockAssets/Install_Mock_UI.server.lua
    @Purpose: Generates StarterGui Assets for Testing
    @Created: Wed, Nov 19, 2025 09:10:48
--]]

local StarterGui = game:GetService("StarterGui")

if not StarterGui:FindFirstChild("ShopNativeScreen") then
    local sg = Instance.new("ScreenGui")
    sg.Name = "ShopNativeScreen"
    sg.ResetOnSpawn = false
    sg.Enabled = false
    sg.Parent = StarterGui
    
    local frame = Instance.new("Frame", sg)
    frame.Name = "MainFrame"
    frame.Size = UDim2.fromOffset(350, 250)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(200, 80, 80) -- Merah (Native)
    
    local lbl = Instance.new("TextLabel", frame)
    lbl.Name = "HeaderTitle"
    lbl.Text = "NATIVE UI DETECTED"
    lbl.Size = UDim2.new(1,0,0,40)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 18
    
    local btn = Instance.new("TextButton", frame)
    btn.Name = "Btn_BuySword"
    btn.Text = "BUY (NATIVE)"
    btn.Size = UDim2.fromOffset(200, 50)
    btn.Position = UDim2.fromScale(0.5, 0.4)
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    
    local close = Instance.new("TextButton", frame)
    close.Name = "Btn_Close"
    close.Text = "CLOSE"
    close.Size = UDim2.fromOffset(200, 40)
    close.Position = UDim2.fromScale(0.5, 0.8)
    close.AnchorPoint = Vector2.new(0.5, 0.5)
end
