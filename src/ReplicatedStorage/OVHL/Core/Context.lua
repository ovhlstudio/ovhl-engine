--[[
    Framework Context - Dynamic Service Container (V7 Fixed)
    Supports strict checking + dynamic injection.
]]

local Context = {}
Context.__index = Context

function Context.New(services)
    local self = setmetatable({}, Context)
    
    -- 1. Dynamic Injection (Inject Adapters, Services, etc automatically)
    for key, value in pairs(services) do
        self[key] = value
    end

    -- 2. Hard Validation (Fundamental Systems)
    -- Ini wajib ada. Kalau gak ada, mending crash di awal daripada aneh2.
    assert(self.LoggerFactory, "[Context] Missing LoggerFactory")
    assert(self.ConfigLoader,  "[Context] Missing ConfigLoader")
    
    -- 3. Compatibility Shim (Legacy Logger)
    -- Buat module lama yang masih panggil ctx.Logger
    if not self.Logger then
        self.Logger = self.LoggerFactory.System()
    end

    return self
end

-- Helper Shortcut
function Context:GetLogger(domain)
    if domain then return self.LoggerFactory.Create(domain) end
    return self.Logger
end

return Context
