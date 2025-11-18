--[[
OVHL ENGINE V1.0.0
@Component: UIManager (UI)
@Path: ReplicatedStorage.OVHL.Systems.UI.UIManager
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.0.0 - UI MANAGER SYSTEM
Version: 3.0.0
Path: ReplicatedStorage.OVHL.Systems.UI.UIManager

FEATURES:
- Screen lifecycle management
- TopbarPlus v3 integration
- Component discovery
- Secure event binding
--]]

local UIManager = {}
UIManager.__index = UIManager

function UIManager.new()
    local self = setmetatable({}, UIManager)
    self._logger = nil
    self._screens = {}
    self._topbarButtons = {}
    self._eventBindings = {}
    return self
end

function UIManager:Initialize(logger)
    if not logger then
        error("UIManager requires logger")
    end
    self._logger = logger
    
    self._logger:Info("UIMANAGER", "UI Manager initialized")
end

function UIManager:RegisterScreen(screenName, screenInstance)
    assert(screenName, "Screen name required")
    assert(screenInstance, "Screen instance required")
    
    self._screens[screenName] = {
        Instance = screenInstance,
        Enabled = false
    }
    
    self._logger:Debug("UIMANAGER", "Screen registered", {screen = screenName})
end

function UIManager:ShowScreen(screenName)
    local screen = self._screens[screenName]
    if not screen then
        self._logger:Warn("UIMANAGER", "Screen not found", {screen = screenName})
        return false
    end
    
    screen.Instance.Enabled = true
    screen.Enabled = true
    
    self._logger:Debug("UIMANAGER", "Screen shown", {screen = screenName})
    return true
end

function UIManager:HideScreen(screenName)
    local screen = self._screens[screenName]
    if not screen then
        self._logger:Warn("UIMANAGER", "Screen not found", {screen = screenName})
        return false
    end
    
    screen.Instance.Enabled = false
    screen.Enabled = false
    
    self._logger:Debug("UIMANAGER", "Screen hidden", {screen = screenName})
    return true
end

function UIManager:ToggleScreen(screenName)
    local screen = self._screens[screenName]
    if not screen then
        self._logger:Warn("UIMANAGER", "Screen not found", {screen = screenName})
        return false
    end
    
    if screen.Enabled then
        return self:HideScreen(screenName)
    else
        return self:ShowScreen(screenName)
    end
end

function UIManager:SetupTopbar(moduleName, config)
    if not config.Topbar or not config.Topbar.Enabled then
        self._logger:Debug("UIMANAGER", "Topbar disabled", {module = moduleName})
        return nil
    end
    
    local topbarPlus = self:_getTopbarPlus()
    if not topbarPlus then
        self._logger:Warn("UIMANAGER", "TopbarPlus not available", {module = moduleName})
        return nil
    end
    
    local success, button = pcall(function()
        return topbarPlus.createButton({
            Icon = config.Topbar.Icon,
            Text = config.Topbar.Text,
            Tooltip = config.Topbar.Tooltip or config.Topbar.Text,
            
            OnClick = function()
                if config.Screens and config.Screens.MainUI then
                    self:ToggleScreen(config.Screens.MainUI)
                end
            end
        })
    end)
    
    if success and button then
        self._topbarButtons[moduleName] = button
        self._logger:Info("UIMANAGER", "TopbarPlus button created", {
            module = moduleName,
            text = config.Topbar.Text
        })
        return button
    else
        self._logger:Error("UIMANAGER", "Failed to create TopbarPlus button", {
            module = moduleName,
            error = tostring(button)
        })
        return nil
    end
end

function UIManager:_getTopbarPlus()
    local success, topbarPlus = pcall(function()
        return _G.TopbarPlus
    end)
    
    if success and topbarPlus then
        return topbarPlus
    end
    
    local success2, topbarPlus2 = pcall(function()
        return require(game:GetService("ReplicatedStorage").TopbarPlus)
    end)
    
    return success2 and topbarPlus2 or nil
end

function UIManager:FindComponent(screenName, componentName)
    local screen = self._screens[screenName]
    if not screen then
        self._logger:Warn("UIMANAGER", "Screen not found for component search", {
            screen = screenName,
            component = componentName
        })
        return nil
    end
    
    local function findRecursive(parent, name)
        for _, child in ipairs(parent:GetChildren()) do
            if child.Name == name then
                return child
            end
            
            local found = findRecursive(child, name)
            if found then
                return found
            end
        end
        return nil
    end
    
    local component = findRecursive(screen.Instance, componentName)
    
    if component then
        self._logger:Debug("UIMANAGER", "Component found", {
            screen = screenName,
            component = componentName,
            type = component.ClassName
        })
    else
        self._logger:Warn("UIMANAGER", "Component not found", {
            screen = screenName,
            component = componentName
        })
    end
    
    return component
end

function UIManager:BindEvent(component, eventName, callback)
    if not component then
        self._logger:Error("UIMANAGER", "Cannot bind event to nil component")
        return false
    end
    
    if not component[eventName] then
        self._logger:Error("UIMANAGER", "Event not found on component", {
            component = component.Name,
            event = eventName,
            type = component.ClassName
        })
        return false
    end
    
    local connection = component[eventName]:Connect(callback)
    
    if not self._eventBindings[component] then
        self._eventBindings[component] = {}
    end
    table.insert(self._eventBindings[component], connection)
    
    self._logger:Debug("UIMANAGER", "Event bound", {
        component = component.Name,
        event = eventName
    })
    
    return true
end

function UIManager:CleanupModule(moduleName)
    if self._topbarButtons[moduleName] then
        pcall(function()
            self._topbarButtons[moduleName]:Destroy()
        end)
        self._topbarButtons[moduleName] = nil
    end
    
    for screenName, screen in pairs(self._screens) do
        if string.find(screenName, moduleName) then
            local bindings = self._eventBindings[screen.Instance]
            if bindings then
                for _, connection in ipairs(bindings) do
                    connection:Disconnect()
                end
                self._eventBindings[screen.Instance] = nil
            end
        end
    end
    
    self._logger:Info("UIMANAGER", "Module cleanup completed", {module = moduleName})
end

return UIManager

--[[
@End: UIManager.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

