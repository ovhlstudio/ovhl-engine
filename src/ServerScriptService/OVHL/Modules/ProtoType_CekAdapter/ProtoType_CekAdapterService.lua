--[[
OVHL ENGINE V1.0.1
@Component: ProtoType_CekAdapterService
@Path: ServerScriptService.OVHL.Modules.ProtoType_CekAdapter.ProtoType_CekAdapterService
@Refactor: Dot Notation Fix
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Service = Knit.CreateService {
    Name = "ProtoType_CekAdapterService",
    Client = {}
}

function Service:KnitInit()
    -- [FIX] Use Dot Notation
    self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
    self.Logger = self.OVHL.GetSystem("SmartLogger")
    self.InputValidator = self.OVHL.GetSystem("InputValidator")
    self.RateLimiter = self.OVHL.GetSystem("RateLimiter")
    self.PermissionCore = self.OVHL.GetSystem("PermissionCore")
    self.Config = self.OVHL.GetConfig("ProtoType_CekAdapter", nil, "Server")
    
    self:_registerSecurity()
    self.Logger:Info("SERVICE", "ProtoType_CekAdapter Service Initialized")
end

function Service:_registerSecurity()
    local sec = self.Config.Security
    if sec then
        if sec.ValidationSchemas then
            -- [FIX] Make sure InputValidator is ready
            if self.InputValidator then
                for k, v in pairs(sec.ValidationSchemas) do self.InputValidator:AddSchema(k, v) end
            end
        end
        if sec.RateLimits then
            if self.RateLimiter then
                for k, v in pairs(sec.RateLimits) do self.RateLimiter:SetLimit(k, v.max, v.window) end
            end
        end
    end
end

function Service:ProcessClick(player, btnName)
    if not self.RateLimiter:Check(player, "ClickAction") then
        return false, "🚫 Rate Limit Exceeded!"
    end

    local permNode = ""
    local successMsg = ""
    
    if btnName == "Btn_Creator" then
        permNode = "ProtoType_CekAdapter.CreatorAction"
        successMsg = "👑 Halo Sultan! Akses Diterima."
    elseif btnName == "Btn_Public" then
        permNode = "ProtoType_CekAdapter.PublicAction"
        successMsg = "🌍 Halo Warga! Akses Diterima."
    else
        return false, "Unknown button"
    end

    local allowed, reason = self.PermissionCore:Check(player, permNode)
    if not allowed then
        self.Logger:Warn("SECURITY", "Access Denied", {player=player.Name, btn=btnName})
        return false, "⛔ Akses Ditolak: " .. tostring(reason)
    end

    self.Logger:Info("BUSINESS", "Button Action Executed", {player=player.Name, btn=btnName})
    return true, successMsg
end

function Service.Client:RequestClick(player, btnName)
    return self.Server:ProcessClick(player, btnName)
end

return Service
