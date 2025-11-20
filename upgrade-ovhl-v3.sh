#!/bin/bash

PROJECT_ROOT="$(pwd)"
SRC_DIR="$PROJECT_ROOT/src"

echo ">>> FIXING LOGGING DOMAINS..."

# 1. FIX PERMISSION SERVICE (FORCE CORRECT DOMAIN)
# ------------------------------------------------------------------------------
# Kita inject LoggerFactory, lalu kita buat logger spesifik "PERMISSION"
cat > "$SRC_DIR/ServerScriptService/OVHL/Services/PermissionService.lua" << 'EOF'
--[[ @Service: PermissionService (V18 - Domain Fixed) ]]
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")
-- [FIX] Load Config agar log source jelas
local Cfg = require(SSS.OVHL.Config.PermissionConfig)

local Hub = {}

function Hub:Init(ctx)
    self.DB = ctx.Adapters.DB
    self.HD = ctx.Adapters.HD
    
    -- [FIX V18] JANGAN PAKE ctx.Logger (Itu System!)
    -- Gunakan Factory untuk create domain spesifik "PERMISSION"
    self.Logger = ctx.LoggerFactory.Create("PERMISSION")
    
    self._cache = {}
    
    ctx.Network:Register("PermissionSystem", {
        Requests = {
            SetRank = { Args = {"number", "number"}, RateLimit = {Max=10, Interval=5} },
            SearchPlayers = { Args = {"string"}, RateLimit = {Max=20, Interval=2} }
        }
    })
    ctx.Network:Bind("PermissionSystem", self)
    Players.PlayerAdded:Connect(function(p) self:OnJoin(p) end)
end

function Hub:Start()
    if Cfg.Provider == "HDAdmin" then
        task.spawn(function()
            local i = 0
            while not self.HD.Connect(self.Logger) and i < 5 do task.wait(2); i+=1 end
            for _, p in ipairs(Players:GetPlayers()) do self:Resolve(p) end
        end)
    end
end

function Hub:OnJoin(p)
    task.delay(1.5, function() if p.Parent then self:Resolve(p) end end)
end

function Hub:Resolve(p)
    local rawDB = self.DB.Get(p.UserId) or 0
    local rawHD = 0
    if Cfg.Provider == "HDAdmin" then rawHD = self.HD.GetRank(p) end
    local isOwnerConfig = (p.UserId == game.CreatorId and Cfg.Settings.OwnerIsSuperAdmin)
    
    local r, s = 0, "GUEST"
    if rawDB > r then r=rawDB; s="INTERNAL_DB" end
    if rawHD > r then r=rawHD; s="HD_ADMIN" end
    if isOwnerConfig then r=5; s="OWNER" end
    
    self._cache[p.UserId] = {Rank=r, Source=s}
    
    -- [FIX] Ini sekarang akan muncul sebagai [PERMISSION] di console
    self.Logger:Info("Identity", {
        User = p.Name,
        FinalRank = r,
        WinningSource = s,
        _Debug = string.format("[HD: %d] [DB: %d] [IsOwner: %s]", rawHD, rawDB, tostring(isOwnerConfig))
    })
end

function Hub:Check(p, req)
    local d = self._cache[p.UserId] or {Rank=0}
    local t = type(req)=="number" and req or 3
    return d.Rank >= t
end

function Hub:SearchPlayers(p, q)
    local res = {}
    local qs = string.lower(q or "")
    for _, v in ipairs(Players:GetPlayers()) do
        local match = (qs == "")
        if not match and (string.find(string.lower(v.Name), qs) or string.find(string.lower(v.DisplayName), qs)) then
            match = true
        end
        if match then
            local info = self._cache[v.UserId] or {Rank=0, Source="?"}
            table.insert(res, {Name=v.Name, UserId=v.UserId, CurrentRank=info.Rank, Source=info.Source})
        end
    end
    return {Success=true, Data=res}
end

function Hub:SetRank(p, tid, r)
    if not self:Check(p, 4) then return {Success=false, Msg="No Access"} end
    if self.DB.Set(tid, r, p.UserId) then
        local t = Players:GetPlayerByUserId(tid)
        if t then self:Resolve(t) end
        return {Success=true, Msg="Internal Rank Saved"}
    end
    return {Success=false, Msg="DB Write Error"}
end
return Hub
EOF

# 2. FIX TOPBAR ADAPTER LOGGING
# ------------------------------------------------------------------------------
# Biar gak nyampur ke USER_INTERFACE, kita kasih dia domain khusus TOPBAR
cat > "$SRC_DIR/StarterPlayer/StarterPlayerScripts/OVHL/Controllers/TopbarPlusAdapter.lua" << 'EOF'
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
EOF

# 3. UPDATE LOGGER CONFIG (MAPPING JELAS)
# ------------------------------------------------------------------------------
# Daftarkan UX, TOPBAR, dan UI agar punya nama cantik
cat > "$SRC_DIR/ReplicatedStorage/OVHL/Config/LoggerConfig.lua" << 'EOF'
return {
    DefaultLevel = "INFO",
    UseEmoji = true,
    UseColor = true,
    ShowTimestamp = true,

    Domains = {
        -- Core
        SYSTEM      = "⚙️ SYSTEM",
        NETWORK     = "🌐 NETWORK", 
        SECURITY    = "🔐 SECURITY",
        DATA        = "💾 DATA",
        
        -- Features
        INVENTORY   = "🎒 INVENTORY",
        SHOP        = "🏪 SHOP", 
        ADMIN       = "👑 ADMIN",
        PERMISSION  = "🔐 PERMISSION", -- [TARGET OPERASI KITA]
        
        -- UI Stuff
        UX             = "👆 UX",       -- Button clicks
        USER_INTERFACE = "🎨 UI",       -- General UI
        TOPBAR         = "🔘 TOPBAR",   -- Topbar specific
        
        -- Fallback
        DEFAULT     = "📦 GENERAL"
    },

    Levels = {
        DEBUG    = { Weight=1, Icon="🔍" },
        INFO     = { Weight=2, Icon="ℹ️" },
        WARN     = { Weight=3, Icon="⚠️" },
        ERROR    = { Weight=4, Icon="❌" },
        CRITICAL = { Weight=5, Icon="💀" }
    }
}
EOF

echo ">>> LOGGING DOMAINS FIXED."
echo "    - PermissionService now logs as [🔐 PERMISSION]"
echo "    - Topbar logs as [🔘 TOPBAR]"
echo "    - Buttons log as [👆 UX]"