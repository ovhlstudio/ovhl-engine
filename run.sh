#!/bin/bash

echo "🚑 OVHL ENGINE V3.0.0 - PERMISSION UPGRADE (SCRIPT 19)"
echo "========================================================"
echo "Fixing: Double Register & Implementing HD Admin-style Permission Fallback"

TARGET_DIR="src"

# 1. FIX MINIMAL SERVICE (Remove SystemRegistry Registration)
echo "🛠️ Patching MinimalService.lua (Removing Double Registration)..."
cat > $TARGET_DIR/ServerScriptService/OVHL/Modules/MinimalModule/MinimalService.lua << 'EOF'
--[[
OVHL ENGINE V3.0.0 - MINIMALMODULE SERVER SERVICE (CLEAN)
Version: 3.0.5
Path: ServerScriptService.OVHL.Modules.MinimalModule.MinimalService
FIXES: Removed SystemRegistry call (Knit handles it)
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local MinimalService = Knit.CreateService {
    Name = "MinimalService",
    Client = {}
}

function MinimalService:KnitInit()
    self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
    self.Logger = self.OVHL:GetSystem("SmartLogger")
    self.Config = self.OVHL:GetConfig("MinimalModule", nil, "Server")
    
    self.InputValidator = self.OVHL:GetSystem("InputValidator")
    self.RateLimiter = self.OVHL:GetSystem("RateLimiter") 
    self.PermissionCore = self.OVHL:GetSystem("PermissionCore")
    
    -- FIX: Removed SystemRegistry registration to prevent double logging
    
    self.Logger:Info("SERVICE", "MinimalService initialized", {
        module = self.Config.ModuleName,
        security = (self.InputValidator ~= nil)
    })
end

function MinimalService:KnitStart()
    self.Logger:Info("SERVICE", "MinimalService started")
end

function MinimalService:ProcessAction(player, actionData)
    local startTime = os.clock()
    
    -- 1. Input Validation
    local valid, validationError = self.InputValidator:Validate("ActionData", actionData)
    if not valid then
        self.Logger:Warn("SECURITY", "Input validation failed", {player=player.Name, error=validationError})
        return false, validationError
    end
    
    -- 2. Rate Limiting
    if not self.RateLimiter:Check(player, "DoAction") then
        return false, "Rate limit exceeded"
    end
    
    -- 3. Permission Check (HD Admin Style)
    local permissionNode = "MinimalModule." .. actionData.action
    local hasPermission, permissionError = self.PermissionCore:Check(player, permissionNode)
    if not hasPermission then
        self.Logger:Warn("SECURITY", "Permission denied", {
            player = player.Name,
            permission = permissionNode,
            error = permissionError
        })
        return false, permissionError
    end
    
    -- 4. Business Logic
    local success, result = self:_executeBusinessLogic(player, actionData)
    
    self.Logger:Performance("TIMING", "Action processed", {
        action = actionData.action,
        duration = os.clock() - startTime,
        success = success
    })
    
    return success, result
end

function MinimalService:_executeBusinessLogic(player, actionData)
    if actionData.action == "test" then
        self.Logger:Debug("BUSINESS", "Test action executed", {player=player.Name})
        return true, "Test completed successfully"
    elseif actionData.action == "admin" then
        -- Admin specific logic logic
        return true, "Admin action completed"
    else
        return false, "Unknown action"
    end
end

function MinimalService:CheckPermission(player, action)
    -- Legacy wrapper using PermissionCore
    if self.PermissionCore then
        return self.PermissionCore:Check(player, "MinimalModule." .. action)
    end
    return false
end

function MinimalService.Client:DoAction(player, actionData)
    return self.Server:ProcessAction(player, actionData)
end

function MinimalService.Client:GetData(player)
    if not self.Server.RateLimiter:Check(player, "GetData") then return {success=false} end
    local clientConfig = self.Server.OVHL:GetClientConfig("MinimalModule")
    return {success=true, data={version=clientConfig.Version}}
end

return MinimalService
EOF

# 2. UPGRADE PERMISSION CORE (HD Admin Style)
echo "🛠️ Upgrading PermissionCore.lua (HD Admin Fallback Logic)..."
cat > $TARGET_DIR/ReplicatedStorage/OVHL/Systems/Security/PermissionCore.lua << 'EOF'
--[[
OVHL ENGINE V3.0.0 - PERMISSION CORE (HD ADMIN STYLE)
Version: 3.1.0
Path: ReplicatedStorage.OVHL.Systems.Security.PermissionCore
FEATURES:
- Mimics HD Admin Ranks (Owner, Admin, Mod, etc)
- Config-driven Rank mapping
--]]

local PermissionCore = {}
PermissionCore.__index = PermissionCore

-- HD Admin Standard Ranks
local RANKS = {
    Owner = 5,
    SuperAdmin = 4,
    Admin = 3,
    Mod = 2,
    VIP = 1,
    NonAdmin = 0
}

function PermissionCore.new()
    local self = setmetatable({}, PermissionCore)
    self._logger = nil
    self._providers = {}
    self._fallbackProvider = self:_createFallbackProvider()
    self._permissionCache = {}
    return self
end

function PermissionCore:Initialize(logger)
    self._logger = logger
    self._providers["Fallback"] = self._fallbackProvider
    self._logger:Info("PERMISSION", "Permission Core initialized (HD Admin Style)")
end

function PermissionCore:_createFallbackProvider()
    return {
        Name = "Fallback",
        Priority = 1,
        
        Check = function(player, permissionNode)
            local module, action = string.match(permissionNode, "^(%w+)%.(.+)$")
            if not module or not action then return false, "Invalid node" end
            
            -- Load Config dynamically
            local success, config = pcall(function()
                return require(game:GetService("ReplicatedStorage").OVHL.Core.OVHL):GetConfig(module)
            end)
            
            if not success or not config or not config.Permissions then 
                return false, "No config/rules found" 
            end
            
            local rule = config.Permissions[action]
            if not rule then return false, "No permission rule for action: " .. action end
            
            -- Check Ranks
            local playerRankId = self:_getPlayerRankId(player)
            local requiredRank = rule.Rank or RANKS.NonAdmin -- Default to 0
            
            -- Convert String Rank to ID if needed
            if type(requiredRank) == "string" then
                requiredRank = RANKS[requiredRank] or 999
            end
            
            if playerRankId >= requiredRank then
                return true
            end
            
            return false, "Rank too low (Required: " .. tostring(requiredRank) .. ", Got: " .. tostring(playerRankId) .. ")"
        end
    }
end

function PermissionCore:_getPlayerRankId(player)
    -- SIMULATE HD ADMIN LOGIC
    if player.UserId == game.CreatorId then return RANKS.Owner end
    -- Bisa ditambah logic check GroupRank disini nanti
    return RANKS.NonAdmin -- Default everyone is 0
end

function PermissionCore:Check(player, permissionNode)
    local provider = self._providers["Fallback"] -- Prioritize HD Admin later
    local allowed, reason = provider.Check(player, permissionNode)
    
    if allowed then
        self._logger:Debug("PERMISSION", "Access Granted", {player=player.Name, node=permissionNode})
    else
        self._logger:Warn("PERMISSION", "Access Denied", {player=player.Name, node=permissionNode, reason=reason})
    end
    
    return allowed, reason
end

return PermissionCore
EOF

# 3. UPDATE CONFIG (Using HD Admin Ranks)
echo "🛠️ Updating SharedConfig.lua with HD Admin Ranks..."
cat > $TARGET_DIR/ReplicatedStorage/OVHL/Shared/Modules/MinimalModule/SharedConfig.lua << 'EOF'
--[[
OVHL ENGINE V3.0.0 - MINIMALMODULE CONFIG (HD ADMIN STYLE)
Version: 3.1.0
Path: ReplicatedStorage.OVHL.Shared.Modules.MinimalModule.SharedConfig
--]]

return {
    ModuleName = "MinimalModule",
    Version = "3.0.0",
    Author = "OVHL Team",
    Enabled = true,
    
    UI = {
        DefaultMode = "AUTO",
        Screens = {
            MainUI = { Mode = "FUSION", NativePath = "MainUI", FallbackMode = "NATIVE" },
            Settings = { Mode = "FUSION", FallbackMode = "NATIVE" }
        },
        Topbar = { Enabled = true, Icon = "rbxassetid://1234567890", Text = "Minimal Module" }
    },
    
    -- HD ADMIN STYLE PERMISSIONS
    Permissions = {
        BasicAction = { Rank = "NonAdmin", Description = "Basic stuff" },
        AdminAction = { Rank = "Admin", Description = "Admin stuff" },
        
        -- TEST ACTION (Permission Rule Added)
        test = { 
            Rank = "NonAdmin", -- 0 (Everyone)
            Description = "Test button action" 
        }
    },
    
    Security = {
        RateLimits = {
            DoAction = { max = 10, window = 60 },
            GetData = { max = 5, window = 30 }
        },
        ValidationSchemas = {
            ActionData = {
                type = "table",
                fields = {
                    action = { type = "string" },
                    data = { type = "table", optional = true },
                    target = { type = "string", optional = true },
                    amount = { type = "number", optional = true }
                }
            }
        }
    }
}
EOF

echo "✅ PERMISSION SYSTEM UPGRADED & BUG FIXED."
echo "🚀 PLAY TEST NOW - HD ADMIN STYLE FALLBACK ACTIVE!"