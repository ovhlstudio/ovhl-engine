--[[
    🛡️ ADAPTER: HD ADMIN (ISOLATED)
    @Responsibility: Handle connection to _G.HDAdminMain securely.
]]
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local HDAdminAdapter = {}
local _api = nil
local _scanning = false

-- Status Helper
function HDAdminAdapter.IsReady() return _api ~= nil end

-- SCANNING LOGIC (Dipindah dari Service)
function HDAdminAdapter.StartScan(logger)
    if _api or _scanning then return end
    _scanning = true
    
    local startTick = tick()
    local connection
    
    connection = RunService.Heartbeat:Connect(function()
        local now = tick()
        
        -- 1. Probe Global
        if _G.HDAdminMain then
            _api = _G.HDAdminMain
        end
        
        -- 2. Probe Module
        if not _api then
            local m = RS:FindFirstChild("HDAdminSetup")
            if m then
                 local s, lib = pcall(require, m)
                 if s and lib and lib.GetMain then 
                    pcall(function() _api = lib:GetMain() end) 
                 end
            end
        end
        
        -- SUCCESS
        if _api then
            logger:Info("Link", "🔗 CONNECTED to HD Admin API!")
            _scanning = false
            connection:Disconnect()
            return
        end
        
        -- TIMEOUT (10 Detik)
        if (now - startTick) > 10 then
            logger:Warn("Timeout", "⏳ HD Admin not responding (Adapter Gave Up).")
            _scanning = false
            connection:Disconnect()
        end
    end)
end

-- RESOLVER LOGIC
function HDAdminAdapter.GetRank(player)
    if not _api then return 0 end
    
    local s, cf = pcall(function() return _api:GetModule("cf") end)
    if s and cf then
        local raw = cf:GetRankId(player)
        if type(raw) == "number" then return raw end
    end
    
    return 0
end

return HDAdminAdapter
