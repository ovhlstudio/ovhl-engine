--[[ @Component: TopbarAdapter (Client - Wally Ready) ]]
local RS = game:GetService("ReplicatedStorage")
local Adapter = {}
Adapter.__index = Adapter

function Adapter.New() return setmetatable({}, Adapter) end

function Adapter:Init(ctx)
    self.Log = ctx.Logger
    
    -- ROBUST PATH FINDING (Wally Standard First)
    -- Package name can be 'topbarplus' or 'Icon' depending on naming
    local function GetLib()
        if RS:FindFirstChild("Packages") then
            return RS.Packages:FindFirstChild("topbarplus") or 
                   RS.Packages:FindFirstChild("Icon") or
                   RS.Packages:FindFirstChild("_Index") and RS.Packages._Index:FindFirstChild("1foreverhd_topbarplus@3.4.0") -- Raw Wally Path
        end
        return RS:FindFirstChild("Icon") -- Fallback Manual
    end

    local module = GetLib()
    if module then
        local ok, lib = pcall(require, module)
        if ok then 
            self.Lib = lib
            self.Log:Info("UX", "Icon Lib Loaded", {Path = module:GetFullName()})
        else
            self.Log:Error("UX", "Require Fail", {Path = module.Name})
        end
    else
        self.Log:Critical("UX", "MISSING DEPENDENCY: TopbarPlus (Check Wally)")
    end
end

function Adapter:Start() end

function Adapter:Add(cfg, cb)
    if not self.Lib or not cfg.Enabled then return end
    local success, err = pcall(function()
        local ico = self.Lib.new()
        if cfg.Text then ico:setLabel(cfg.Text) end
        if cfg.Icon then ico:setImage(cfg.Icon) end
        if cfg.Order then ico:setOrder(cfg.Order) end
        
        ico:bindEvent("selected", function() cb(true) end)
        ico:bindEvent("deselected", function() cb(false) end)
    end)
    if not success then self.Log:Warn("UX", "Icon Error", {Err = err}) end
end
return Adapter
