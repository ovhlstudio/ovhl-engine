--[[
    OVHL ENGINE V1.2.2
    @Component: UIManager
    @Update: Supports State Argument in Event Bus
--]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIManager = {}
UIManager.__index = UIManager

local function CreateSignal()
    local sig = {}
    local callbacks = {}
    function sig:Connect(fn)
        table.insert(callbacks, fn)
        return { Disconnect = function() for i,f in ipairs(callbacks) do if f == fn then table.remove(callbacks, i) end end end }
    end
    function sig:Fire(...)
        for _, fn in ipairs(callbacks) do task.spawn(fn, ...) end
    end
    return sig
end

function UIManager.new()
    local self = setmetatable({}, UIManager)
    self._logger = nil
    self._screens = {}
    self._adapter = nil
    self._setupComplete = false
    self._scanner = nil
    self.OnTopbarClick = CreateSignal() 
    return self
end

function UIManager:Initialize(logger)
    self._logger = logger
    local OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
    self._scanner = OVHL.GetSystem("ComponentScanner")
    local success, cfg = pcall(function() return require(ReplicatedStorage.OVHL.Config.EngineConfig) end)
    self._adapterName = (success and cfg.Adapters and cfg.Adapters.Navbar) or "InternalAdapter"
    self._logger:Info("UIMANAGER", "Initialized V1.2.2 (State Sync)")
end

function UIManager:Start()
    if self._setupComplete then return end
    self._setupComplete = true
    local folder = ReplicatedStorage.OVHL.Systems.Adapters.Navbar
    local mod = folder:FindFirstChild(self._adapterName) or folder:FindFirstChild("InternalAdapter")
    if mod then
        local cls = require(mod)
        self._adapter = cls.new()
        if self._adapter.Initialize then self._adapter:Initialize(self._logger) end
        if self._adapter.SetClickHandler then
            -- [UPDATE] Terima 2 argumen: ID dan State
            self._adapter:SetClickHandler(function(buttonId, state)
                self._logger:Debug("UIMANAGER", "📣 State Change", {id=buttonId, active=state})
                self.OnTopbarClick:Fire(buttonId, state)
            end)
        end
    end
end

function UIManager:RegisterTopbar(moduleId, config)
    if not self._adapter then return false end
    if not config or not config.Enabled then return false end
    return self._adapter:AddButton(moduleId, config)
end

function UIManager:RegisterScreen(name, instance) self._screens[name] = { Instance = instance, Enabled = false } end

-- [UPDATE] Toggle sekarang menerima paksaan state (forceState)
function UIManager:ToggleScreen(name, forceState)
    local s = self._screens[name]
    if s and s.Instance then
        if forceState ~= nil then
            s.Instance.Enabled = forceState
        else
            s.Instance.Enabled = not s.Instance.Enabled
        end
        s.Enabled = s.Instance.Enabled
        return s.Enabled
    end
    return false
end

function UIManager:ScanNativeUI(screenName, componentMap)
    local pGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local screen = pGui:WaitForChild(screenName, 5)
    if not screen then return nil, "Screen not found" end
    if self._scanner then return self._scanner:Scan(screen, componentMap), screen else return nil, "Scanner missing" end
end

return UIManager
