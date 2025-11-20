--[[ @Component: TopbarAdapter (V18 - Domain Fix) ]]
local RS = game:GetService("ReplicatedStorage")
local Adapter = {}
Adapter.__index = Adapter

function Adapter.New() return setmetatable({_registry={}}, Adapter) end

function Adapter:Init(ctx)
    -- [FIX] Gunakan domain TOPBAR explicit
    self.Logger = ctx.LoggerFactory.Create("TOPBAR")
    
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
    local s, icon = pcall(function()
        local ico = self.Lib.new()
        if cfg.Text then ico:setLabel(cfg.Text) end
        if cfg.Icon then ico:setImage(cfg.Icon) end
        if cfg.Order then ico:setOrder(cfg.Order) end
        
        ico:bindEvent("selected", function() 
            self.Logger:Info("Selected", {Icon=cfg.Text}) 
            cb(true) 
        end)
        ico:bindEvent("deselected", function() 
            self.Logger:Info("Deselected", {Icon=cfg.Text})
            cb(false) 
        end)
        return ico
    end)
    
    if s and icon then
        -- self.Logger:Info("Registered", {Owner=ownerName}) -- Optional: Reduce spam
        self._registry[ownerName] = icon
    end
end

function Adapter:SetState(ownerName, isActive)
    local icon = self._registry[ownerName]
    if not icon then return end
    if isActive and not icon.isSelected then icon:select()
    elseif not isActive and icon.isSelected then icon:deselect() end
end
return Adapter
