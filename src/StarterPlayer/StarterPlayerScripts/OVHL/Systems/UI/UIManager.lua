--[[
OVHL FRAMEWORK V.1.1.0
@Component: UIManager (UI)
@Path: StarterPlayer.StarterPlayerScripts.OVHL.Systems.UI.UIManager
@Purpose: Screen lifecycle & Adapter-based Navbar management
--]]

local UIManager = {}
UIManager.__index = UIManager

function UIManager.new()
    local self = setmetatable({}, UIManager)
    self._logger = nil
    self._screens = {}
    self._eventBindings = {}
    self._adapter = nil
    self._fallbackAdapter = nil
    self._adapterName = nil
    return self
end

function UIManager:Initialize(logger)
    self._logger = logger
    -- [V1.1.0 ARCHITECTURE FIX] ABSOLUTE PATH
    local success, cfg = pcall(function() return require(game:GetService("ReplicatedStorage").OVHL.Config.EngineConfig) end)
    self._adapterName = (success and cfg.Adapters and cfg.Adapters.Navbar) or "InternalAdapter"
    self._logger:Info("UIMANAGER", "Init", {navbar = self._adapterName})
end

function UIManager:Start()
    -- [V1.1.0 ARCHITECTURE FIX] ABSOLUTE PATH TO SHARED ADAPTERS
    local folder = game:GetService("ReplicatedStorage").OVHL.Systems.Adapters.Navbar
    
    local mod = folder:FindFirstChild(self._adapterName)
    if mod then
        local cls = require(mod)
        self._adapter = cls.new()
        if self._adapter.Initialize then self._adapter:Initialize(self._logger) end
    end
    local fallbackMod = folder:FindFirstChild("InternalAdapter")
    if fallbackMod then
        local cls = require(fallbackMod)
        self._fallbackAdapter = cls.new()
        if self._fallbackAdapter.Initialize then self._fallbackAdapter:Initialize(self._logger) end
    end
end

function UIManager:RegisterScreen(screenName, screenInstance)
    self._screens[screenName] = { Instance = screenInstance, Enabled = false }
    self._logger:Debug("UIMANAGER", "Screen registered", {name=screenName})
end

function UIManager:ShowScreen(screenName)
    local s = self._screens[screenName]
    if s then 
        s.Instance.Enabled = true
        s.Enabled = true 
        self._logger:Debug("UIMANAGER", "Show Screen", {name=screenName})
        return true 
    end
    self._logger:Warn("UIMANAGER", "Show failed: Screen not found", {name=screenName})
    return false
end

function UIManager:HideScreen(screenName)
    local s = self._screens[screenName]
    if s then 
        s.Instance.Enabled = false
        s.Enabled = false 
        return true 
    end
    return false
end

function UIManager:ToggleScreen(screenName)
    local s = self._screens[screenName]
    if not s then 
        self._logger:Warn("UIMANAGER", "Toggle failed: Screen not found", {name=screenName})
        return false 
    end
    if s.Enabled then return self:HideScreen(screenName) else return self:ShowScreen(screenName) end
end

function UIManager:SetupTopbar(moduleName, _ignoredConfig, explicitOnClick)
    -- [V1.1.0 ARCHITECTURE FIX] ABSOLUTE PATH
    local OVHL = require(game:GetService("ReplicatedStorage").OVHL.Core.OVHL)
    local fullConfig = OVHL.GetClientConfig(moduleName)
    
    if not fullConfig then
        self._logger:Warn("UIMANAGER", "Gagal load config untuk Topbar", {module=moduleName})
        return false
    end
    
    local topbarConfig = fullConfig.Topbar or (fullConfig.UI and fullConfig.UI.Topbar)
    
    if not topbarConfig or not topbarConfig.Enabled then 
        return nil 
    end

    if explicitOnClick then
        topbarConfig.OnClick = explicitOnClick
    elseif not topbarConfig.OnClick then
         self._logger:Warn("UIMANAGER", "Topbar setup without OnClick handler", {module=moduleName})
         return false
    end
    
    local success = false
    if self._adapter then
        success = self._adapter:AddButton(moduleName, topbarConfig)
    end
    
    if not success then
        if self._fallbackAdapter then
            self._logger:Warn("UIMANAGER", "Main Adapter failed, using Fallback", {module=moduleName})
            success = self._fallbackAdapter:AddButton(moduleName, topbarConfig)
        else
            self._logger:Critical("UIMANAGER", "No Navbar Adapter available!")
        end
    end
    
    return success
end

function UIManager:FindComponent(screenName, componentName)
    local s = self._screens[screenName]
    if not s then return nil end
    return s.Instance:FindFirstChild(componentName, true)
end

function UIManager:BindEvent(component, eventName, callback)
    if not component then return false end
    component[eventName]:Connect(callback)
    return true
end

return UIManager
