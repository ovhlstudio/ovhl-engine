-- [[ OVHL V2 PRELOADER ]]
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Simple Loading Screen
local screen = Instance.new("ScreenGui")
screen.Name = "OVHL_Preloader"
screen.IgnoreGuiInset = true
screen.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromScale(1, 1)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Parent = screen

local label = Instance.new("TextLabel")
label.Text = "INITIALIZING OVHL V2..."
label.Size = UDim2.fromScale(1, 0.1)
label.Position = UDim2.fromScale(0, 0.45)
label.TextColor3 = Color3.new(1,1,1)
label.BackgroundTransparency = 1
label.Parent = frame

-- Cleanup Logic (Listen to Engine Loaded signal later if needed)
task.delay(4, function()
    screen:Destroy()
end)
