--[[
OVHL Tests - RateLimiter Unit Tests
Path: tests/Unit/RateLimiter.spec.lua
--]]

return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RateLimiter = require(ReplicatedStorage.OVHL.Systems.Security.RateLimiter)
    
    describe("RateLimiter", function()
        local limiter
        local mockPlayer = { UserId = 12345, Name = "TestPlayer" }
        
        beforeAll(function()
            limiter = RateLimiter.new()
            limiter:Initialize({Info=function() end, Debug=function() end, Warn=function() end})
            limiter:SetLimit("SpamTest", 2, 60) -- Max 2 requests per 60s
        end)
        
        it("should allow requests within limit", function()
            expect(limiter:Check(mockPlayer, "SpamTest")).to.equal(true)
            expect(limiter:Check(mockPlayer, "SpamTest")).to.equal(true)
        end)
        
        it("should block requests exceeding limit", function()
            -- 3rd request should fail
            expect(limiter:Check(mockPlayer, "SpamTest")).to.equal(false)
        end)
    end)
end
