--[[
    OVHL ENGINE V1.2.2
    @Component: NetworkGuard (Middleware)
    @Purpose: 
      1. INBOUND: Memastikan argumen dari Client masuk akal (Type Safety).
      2. OUTBOUND: Mencegah kebocoran data sensitif (Data Loss Prevention).
--]]

local NetworkGuard = {}

-- [[ CONFIGURATION ]]
local BLACKLIST_KEYS = { "API_?KEY", "SECRET", "TOKEN", "WEBHOOK", "PASSWORD", "AUTH" }
local MAX_STRING_LEN = 1000 -- Cegah crash server karena string raksasa
local MAX_TABLE_DEPTH = 10  -- Cegah cyclic table attack

-- [[ HELPER: OUTBOUND SANITIZER (SERVER -> CLIENT) ]]
local function isSensitive(key)
    if type(key) ~= "string" then return false end
    local k = string.upper(key)
    for _, pattern in ipairs(BLACKLIST_KEYS) do
        if string.find(k, pattern) then return true end
    end
    return false
end

local function sanitizeOutbound(data, depth)
    if depth > MAX_TABLE_DEPTH then return nil end
    if type(data) ~= "table" then return data end

    local clean = {}
    for k, v in pairs(data) do
        if isSensitive(k) then
            clean[k] = "[REDACTED]"
            warn("🚨 [GUARD-OUT] Blocked sensitive key:", k)
        elseif type(v) == "table" then
            clean[k] = sanitizeOutbound(v, depth + 1)
        else
            clean[k] = v
        end
    end
    return clean
end

-- [[ HELPER: INBOUND SANITIZER (CLIENT -> SERVER) ]]
-- Tugas: Hapus Instance yang tidak relevan, potong string kepanjangan, cegah NaN/Inf
local function sanitizeInbound(data, depth)
    if depth > MAX_TABLE_DEPTH then return nil end
    
    local t = type(data)
    
    if t == "string" then
        if #data > MAX_STRING_LEN then
            return string.sub(data, 1, MAX_STRING_LEN) -- Potong string spam
        end
        return data
    elseif t == "number" then
        -- Cegah NaN (Not a Number) atau Infinity yang bisa ngerusak math server
        if data ~= data or data == math.huge or data == -math.huge then
            return 0 
        end
        return data
    elseif t == "table" then
        local clean = {}
        for k, v in pairs(data) do
            -- Key harus aman (string/number), Value disanitasi
            if type(k) == "string" or type(k) == "number" then
                clean[k] = sanitizeInbound(v, depth + 1)
            end
        end
        return clean
    elseif t == "function" or t == "thread" or t == "userdata" then
        -- Hapus tipe data yang tidak bisa/bahaya dikirim via network
        return nil
    end
    
    return data -- Boolean, Instance (valid), dll lolos
end

-- [[ KNIT MIDDLEWARES ]]

-- 1. Inbound: Dipasang di Client -> Server
function NetworkGuard.Inbound(nextFn)
    return function(player, ...)
        local args = {...}
        local cleanArgs = {}
        
        -- Loop semua argumen dan bersihkan
        for i, arg in ipairs(args) do
            cleanArgs[i] = sanitizeInbound(arg, 1)
        end
        
        return nextFn(player, table.unpack(cleanArgs))
    end
end

-- 2. Outbound: Dipasang di Server -> Client
function NetworkGuard.Outbound(nextFn)
    return function(player, ...)
        local results = {nextFn(player, ...)}
        local cleanResults = {}
        
        for i, res in ipairs(results) do
            cleanResults[i] = sanitizeOutbound(res, 1)
        end
        
        return table.unpack(cleanResults)
    end
end

return NetworkGuard
