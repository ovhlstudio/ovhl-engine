--[[
OVHL ENGINE V1.0.0
@Component: UIManager (UI)
@Path: ReplicatedStorage.OVHL.Systems.UI.UIManager
@Purpose: Screen lifecycle & Adapter-based Navbar management
@Stability: STABLE
--]]

local UIManager = {}
UIManager.__index = UIManager

function UIManager.new()
    local self = setmetatable({}, UIManager)
    self._logger = nil
    self._screens = {}
    self._eventBindings = {}
    self._adapter = nil
    self._adapterName = nil
    return self
end

function UIManager:Initialize(logger)
    if not logger then error("UIManager requires logger") end
    self._logger = logger
    
    local success, engineConfig = pcall(function()
        return require(game:GetService("ReplicatedStorage").OVHL.Config.EngineConfig)
    end)
    
    if success and engineConfig and engineConfig.Adapters then
        self._adapterName = engineConfig.Adapters.Navbar or "InternalAdapter"
    else
        self._logger:Warn("UIMANAGER", "Failed to load EngineConfig, defaulting navbar to Internal")
        self._adapterName = "InternalAdapter"
    end
    
    self._logger:Info("UIMANAGER", "UI Manager initialized", {navbar = self._adapterName})
end

function UIManager:Start()
    local adapterFolder = script.Parent.Parent.Adapters.Navbar
    local adapterModule = adapterFolder:FindFirstChild(self._adapterName)
    
    if not adapterModule then
        self._logger:Warn("UIMANAGER", "Navbar adapter not found, fallback to Internal", {adapter = self._adapterName})
        adapterModule = adapterFolder:FindFirstChild("InternalAdapter")
    end
    
    if adapterModule then
        local success, AdapterClass = pcall(require, adapterModule)
        if success then
            self._adapter = AdapterClass.new()
            if self._adapter.Initialize then
                self._adapter:Initialize(self._logger)
            end
            self._logger:Info("UIMANAGER", "Navbar adapter loaded", {adapter = adapterModule.Name})
        else
            self._logger:Critical("UIMANAGER", "Failed to require navbar adapter", {error = tostring(AdapterClass)})
        end
    end
end

function UIManager:RegisterScreen(screenName, screenInstance)
    self._screens[screenName] = {
        Instance = screenInstance,
        Enabled = false
    }
    self._logger:Debug("UIMANAGER", "Screen registered", {screen = screenName})
end

function UIManager:ShowScreen(screenName)
    local screen = self._screens[screenName]
    if not screen then return false end
    screen.Instance.Enabled = true
    screen.Enabled = true
    return true
end

function UIManager:HideScreen(screenName)
    local screen = self._screens[screenName]
    if not screen then return false end
    screen.Instance.Enabled = false
    screen.Enabled = false
    return true
end

function UIManager:ToggleScreen(screenName)
    local screen = self._screens[screenName]
    if not screen then return false end
    if screen.Enabled then return self:HideScreen(screenName) else return self:ShowScreen(screenName) end
end

-- [FIXED] SetupTopbar now smarter at finding config
function UIManager:SetupTopbar(moduleName, config)
    -- 1. Cari Config Topbar (Support Root atau nested UI)
    local topbarConfig = config.Topbar
    if not topbarConfig and config.UI and config.UI.Topbar then
        topbarConfig = config.UI.Topbar
    end

    -- 2. Validasi Config
    if not topbarConfig or not topbarConfig.Enabled then
        -- Silent return is OK (module doesn't want topbar)
        return nil
    end
    
    -- 3. Cek Adapter
    if not self._adapter then
        self._logger:Warn("UIMANAGER", "Cannot setup topbar: Adapter not ready")
        return nil
    end
    
    -- 4. Inject Default Click Handler jika kosong
    if not topbarConfig.OnClick then
        topbarConfig.OnClick = function()
            -- Coba toggle MainUI secara default
            local mainScreenName = "MainUI"
            if config.UI and config.UI.Screens and config.UI.Screens.MainUI then
                -- Support custom screen names in future if needed
            end
            self:ToggleScreen(mainScreenName)
        end
    end
    
    -- 5. Eksekusi Adapter
    local success = self._adapter:AddButton(moduleName, topbarConfig)
    
    if success then
        self._logger:Debug("UIMANAGER", "Topbar button created", {module = moduleName})
    else
        self._logger:Warn("UIMANAGER", "Adapter failed to create button", {module = moduleName})
    end
    
    return success
end

function UIManager:FindComponent(screenName, componentName)
    local screen = self._screens[screenName]
    if not screen then return nil end
    
    local function findRecursive(parent, name)
        for _, child in ipairs(parent:GetChildren()) do
            if child.Name == name then return child end
            local found = findRecursive(child, name)
            if found then return found end
        end
        return nil
    end
    return findRecursive(screen.Instance, componentName)
end

function UIManager:BindEvent(component, eventName, callback)
    if not component or not component[eventName] then return false end
    local connection = component[eventName]:Connect(callback)
    if not self._eventBindings[component] then self._eventBindings[component] = {} end
    table.insert(self._eventBindings[component], connection)
    return true
end

function UIManager:CleanupModule(moduleName)
    if self._adapter and self._adapter.RemoveButton then
        self._adapter:RemoveButton(moduleName)
    end
    -- Event cleanup logic here...
    self._logger:Info("UIMANAGER", "Module cleanup completed", {module = moduleName})
end

return UIManager

--[[
@End: UIManager.lua
@Version: 1.0.2 (Fixed Config Path Bug)
@LastUpdate: 2025-11-18
--]]
