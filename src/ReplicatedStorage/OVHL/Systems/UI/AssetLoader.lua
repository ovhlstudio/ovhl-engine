--[[
OVHL ENGINE V1.0.0
@Component: AssetLoader (UI)
@Path: ReplicatedStorage.OVHL.Systems.UI.AssetLoader
@Purpose: [TODO: Add purpose]
@Stability: STABLE
--]]

--[[
OVHL ENGINE V3.0.0 - ASSET LOADER SYSTEM
Version: 3.0.0
Path: ReplicatedStorage.OVHL.Systems.UI.AssetLoader

FEATURES:
- Asset loading & management
- Input handling & keybinds
- Gesture recognition
- Performance optimization
--]]

local AssetLoader = {}
AssetLoader.__index = AssetLoader

function AssetLoader.new()
    local self = setmetatable({}, AssetLoader)
    self._logger = nil
    self._loadedAssets = {}
    self._keybinds = {}
    self._inputConnections = {}
    return self
end

function AssetLoader:Initialize(logger)
    if not logger then
        error("AssetLoader requires logger")
    end
    self._logger = logger
    
    self._logger:Info("ASSETLOADER", "Asset Loader initialized")
end

function AssetLoader:LoadIcon(iconName, assetId)
    assert(iconName, "Icon name required")
    
    if self._loadedAssets[iconName] then
        return self._loadedAssets[iconName]
    end
    
    if not assetId or not string.match(assetId, "^rbxassetid://%d+$") then
        self._logger:Error("ASSETLOADER", "Invalid asset ID format", {
            icon = iconName,
            assetId = assetId
        })
        return nil
    end
    
    local texture = Instance.new("ImageLabel")
    texture.Name = iconName .. "_Icon"
    texture.Image = assetId
    texture.BackgroundTransparency = 1
    texture.Size = UDim2.new(0, 32, 0, 32)
    
    self._loadedAssets[iconName] = texture
    
    self._logger:Debug("ASSETLOADER", "Icon loaded", {
        icon = iconName,
        assetId = assetId
    })
    
    return texture
end

function AssetLoader:PreloadAssets(assetConfig)
    if not assetConfig then
        self._logger:Warn("ASSETLOADER", "No asset config provided for preload")
        return
    end
    
    local loadedCount = 0
    
    if assetConfig.Icons then
        for iconName, assetId in pairs(assetConfig.Icons) do
            if self:LoadIcon(iconName, assetId) then
                loadedCount = loadedCount + 1
            end
        end
    end
    
    self._logger:Info("ASSETLOADER", "Assets preloaded", {
        total = loadedCount,
        config = assetConfig
    })
end

function AssetLoader:GetAsset(assetName)
    return self._loadedAssets[assetName]
end

function AssetLoader:RegisterKeybind(keyCode, callback, options)
    options = options or {}
    
    if not keyCode or not typeof(keyCode) == "EnumItem" then
        self._logger:Error("ASSETLOADER", "Invalid key code", {keyCode = tostring(keyCode)})
        return false
    end
    
    if self._keybinds[keyCode] then
        self._logger:Warn("ASSETLOADER", "Keybind already registered", {keyCode = tostring(keyCode)})
        return false
    end
    
    self._keybinds[keyCode] = {
        callback = callback,
        options = options
    }
    
    local connection
    if options.triggerOnPress ~= false then
        connection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.KeyCode == keyCode then
                pcall(callback, "pressed")
            end
        end)
    else
        connection = game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.KeyCode == keyCode then
                pcall(callback, "released")
            end
        end)
    end
    
    self._inputConnections[keyCode] = connection
    
    self._logger:Debug("ASSETLOADER", "Keybind registered", {
        keyCode = tostring(keyCode),
        trigger = options.triggerOnPress and "press" or "release"
    })
    
    return true
end

function AssetLoader:RegisterButtonClick(button, callback)
    if not button then
        self._logger:Error("ASSETLOADER", "Cannot register click for nil button")
        return false
    end
    
    if not button:IsA("GuiButton") then
        self._logger:Error("ASSETLOADER", "Object is not a GUI button", {type = button.ClassName})
        return false
    end
    
    local connection = button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    self._inputConnections[button] = connection
    
    self._logger:Debug("ASSETLOADER", "Button click registered", {button = button.Name})
    return true
end

function AssetLoader:Cleanup()
    for key, connection in pairs(self._inputConnections) do
        if typeof(connection) == "table" then
            for _, conn in ipairs(connection) do
                pcall(function() conn:Disconnect() end)
            end
        else
            pcall(function() connection:Disconnect() end)
        end
    end
    
    self._inputConnections = {}
    self._keybinds = {}
    
    self._logger:Info("ASSETLOADER", "Service cleanup completed")
end

return AssetLoader

--[[
@End: AssetLoader.lua
@Version: 1.0.0
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

