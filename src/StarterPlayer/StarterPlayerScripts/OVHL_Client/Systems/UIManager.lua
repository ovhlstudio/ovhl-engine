local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedPath = ReplicatedStorage.OVHL_Shared
local OVHL = require(SharedPath)
local Config = require(SharedPath.Library.SharedConfig)

local UIManager = {
    Name = "UIManager",
    Dependencies = {"AssetLoader"} 
}

OVHL.RegisterSystem("UIManager", UIManager)

local _navbar = nil

function UIManager:OnInit()
    OVHL.Logger:Info("UI", "UIManager Initialized")
end

function UIManager:OnStart()
    self:InitNavbar()
end

function UIManager:InitNavbar()
    local adapterName = Config.Adapters.Navbar or "InternalAdapter"
    local mod = SharedPath.Library.Adapters.Navbar:FindFirstChild(adapterName)
    if mod then
        local s, instance = pcall(function() return require(mod).new() end)
        if s then
            _navbar = instance
            if _navbar.Init then _navbar:Init() end
            OVHL.Logger:Info("UI", "Navbar Ready", {adapter=adapterName})
        end
    end
end

function UIManager:RegisterApp(id, config, callback)
    if _navbar then 
        -- Wrap callback to add log
        _navbar:Add(id, config, function(state)
            OVHL.Logger:Debug("UI", "Navbar Toggle Event", {app=id, state=state})
            if callback then callback(state) end
        end)
    else
        OVHL.Logger:Warn("UI", "Navbar not ready for app: " .. id)
    end
end

return UIManager
