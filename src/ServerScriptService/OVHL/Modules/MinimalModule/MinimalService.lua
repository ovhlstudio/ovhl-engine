--[[
    OVHL ENGINE V1.2.0
    @Component: MinimalService
    @Path: src/ServerScriptService/OVHL/Modules/MinimalModule/MinimalService.lua
    @Purpose: Server Logic (Fasad)
    @Created: Wed, Nov 19, 2025 09:10:48
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local MinimalService = Knit.CreateService { Name = "MinimalService", Client = {} }

function MinimalService:KnitInit()
    self.Logger = require(ReplicatedStorage.OVHL.Core.OVHL).GetSystem("SmartLogger")
    self.Logger:Info("SERVICE", "MinimalService Initialized")
end

function MinimalService:KnitStart() end

return MinimalService
