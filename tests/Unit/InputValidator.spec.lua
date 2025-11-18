--[[
OVHL Tests - InputValidator Unit Tests
Path: tests/Unit/InputValidator.spec.lua
--]]

return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local InputValidator = require(ReplicatedStorage.OVHL.Systems.Security.InputValidator)
    
    describe("InputValidator", function()
        local validator
        
        beforeAll(function()
            validator = InputValidator.new()
            validator:Initialize({Info=function() end, Debug=function() end, Warn=function() end})
            
            validator:AddSchema("TestSchema", {
                type = "table",
                fields = {
                    name = { type = "string", min = 3 },
                    age = { type = "number", min = 0, max = 100 },
                    meta = { type = "table", optional = true }
                }
            })
        end)
        
        it("should validate correct data", function()
            local valid, err = validator:Validate("TestSchema", {
                name = "John",
                age = 25
            })
            expect(valid).to.equal(true)
            expect(err).to.equal("Valid")
        end)
        
        it("should reject incorrect types", function()
            local valid, err = validator:Validate("TestSchema", {
                name = 123, -- Wrong type
                age = 25
            })
            expect(valid).to.equal(false)
        end)
        
        it("should reject values out of range", function()
            local valid, err = validator:Validate("TestSchema", {
                name = "John",
                age = 150 -- Too old
            })
            expect(valid).to.equal(false)
        end)
    end)
end
