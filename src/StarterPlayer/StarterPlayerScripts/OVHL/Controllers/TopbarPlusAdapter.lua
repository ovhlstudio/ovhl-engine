--[[ @Component: TopbarAdapter (With State Control) ]]
local RS = game:GetService("ReplicatedStorage")
local LoggerClass = require(RS.OVHL.Core.SmartLogger)

local Adapter = {}
Adapter.__index = Adapter

function Adapter.New() 
    local self = setmetatable({}, Adapter) 
    self.Logger = LoggerClass.New("UX") 
    self._registry = {} -- [NEW] Store Icons by Owner Name
    return self
end

function Adapter:Init(ctx)
    local function GetLib()
        if RS:FindFirstChild("Packages") then
            return RS.Packages:FindFirstChild("topbarplus") or 
                   RS.Packages:FindFirstChild("Icon") or
                   RS.Packages:FindFirstChild("_Index") and RS.Packages._Index:FindFirstChild("1foreverhd_topbarplus@3.4.0")
        end
        return RS:FindFirstChild("Icon")
    end

    local module = GetLib()
    if module then
        local ok, lib = pcall(require, module)
        if ok then self.Lib = lib end
    end
end

function Adapter:Add(ownerName, cfg, cb)
    if not self.Lib or not cfg.Enabled then return end
    
    local success, icon = pcall(function()
        local ico = self.Lib.new()
        if cfg.Text then ico:setLabel(cfg.Text) end
        if cfg.Icon then ico:setImage(cfg.Icon) end
        if cfg.Order then ico:setOrder(cfg.Order) end
        
        -- BIND EVENTS
        ico:bindEvent("selected", function() 
            self.Logger:Info("Topbar Toggle", {Icon=cfg.Text, State="OPEN"}) 
            cb(true) 
        end)
        ico:bindEvent("deselected", function() 
            self.Logger:Info("Topbar Toggle", {Icon=cfg.Text, State="CLOSED"})
            cb(false) 
        end)
        
        return ico
    end)
    
    if success and icon then
        self.Logger:Info("Icon Registered", {Owner=ownerName, Label=cfg.Text})
        self._registry[ownerName] = icon -- [NEW] Save Ref
    end
end

-- [NEW] API FOR CONTROLLERS
function Adapter:SetState(ownerName, isActive)
    local icon = self._registry[ownerName]
    if not icon then return end
    
    -- Mencegah loop infinite dengan mengecek state saat ini
    if isActive and not icon.isSelected then
        icon:select()
    elseif not isActive and icon.isSelected then
        icon:deselect()
    end
end

return Adapter
