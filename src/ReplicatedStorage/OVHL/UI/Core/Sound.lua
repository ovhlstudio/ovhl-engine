local SoundService = game:GetService("SoundService")
local Sound = {}

-- Standard UI Sounds
local SFX = {
    Click   = "rbxassetid://6895079853",
    Hover   = "rbxassetid://6895079955",
    Success = "rbxassetid://6895079853",
    Error   = "rbxassetid://4612377142",
}

function Sound.Play(name)
    task.spawn(function()
        local id = SFX[name]
        if not id then return end
        
        local s = Instance.new("Sound")
        s.SoundId = id
        s.Volume = 0.5
        s.Parent = SoundService
        s:Play()
        
        s.Ended:Wait()
        s:Destroy()
    end)
end

return Sound
