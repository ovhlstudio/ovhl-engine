--[[
    OVHL Bootstrap
    Universal Entry Point for Server/Client
]]
local RunService = game:GetService('RunService')
local Bootstrap = {}
Bootstrap.Server = {}
Bootstrap.Client = {}

function Bootstrap.Server:Start()
    if RunService:IsServer() then
        require(game.ServerScriptService.OVHL.Core.Kernel).Boot()
    end
end

function Bootstrap.Client:Start()
    if RunService:IsClient() then
        local PS = game.Players.LocalPlayer:WaitForChild('PlayerScripts')
        require(PS.OVHL.Core.Kernel).Boot()
    end
end

return Bootstrap
