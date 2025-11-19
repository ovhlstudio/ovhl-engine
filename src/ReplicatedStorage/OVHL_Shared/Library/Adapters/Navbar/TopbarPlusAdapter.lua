local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OVHL = require(ReplicatedStorage.OVHL_Shared) -- Absolute
local TopbarAdapter = {}
TopbarAdapter.__index = TopbarAdapter
function TopbarAdapter.new() return setmetatable({_lib=nil,_icons={}},TopbarAdapter) end
function TopbarAdapter:Init()
    if game:GetService("RunService"):IsServer() then return end
    local libModule = nil
    if ReplicatedStorage:FindFirstChild("Packages") then
        libModule = ReplicatedStorage.Packages:FindFirstChild("Icon") or ReplicatedStorage.Packages:FindFirstChild("TopbarPlus")
    end
    if not libModule then libModule = ReplicatedStorage:FindFirstChild("Icon") end
    if libModule then
        local s, l = pcall(require, libModule)
        if s then self._lib = l; OVHL.Logger:Info("UI", "TopbarPlus Connected") else OVHL.Logger:Error("UI", "Icon Lib Error") end
    else OVHL.Logger:Warn("UI", "TopbarPlus Lib Missing") end
end
function TopbarAdapter:Add(id, c, cb)
    if not self._lib then return end
    if self._icons[id] then self._icons[id]:destroy() end
    local icon = self._lib.new():setName(id):setLabel(c.Text or id)
    if c.Icon then icon:setImage(c.Icon) end
    icon:bindEvent("selected", function() cb(true) end)
    icon:bindEvent("deselected", function() cb(false) end)
    self._icons[id] = icon
    OVHL.Logger:Debug("UI", "Icon Added: "..id)
end
return TopbarAdapter
