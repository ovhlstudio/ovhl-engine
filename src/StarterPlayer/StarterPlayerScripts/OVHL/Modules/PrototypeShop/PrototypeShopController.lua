--[[
OVHL ENGINE V1.0.1
@Component: PrototypeShopController (Module)
@Path: StarterPlayer.StarterPlayerScripts.OVHL.Modules.PrototypeShop.PrototypeShopController
@Refactor: Dot Notation Fix
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local PrototypeShopController = Knit.CreateController { Name = "PrototypeShopController" }

function PrototypeShopController:KnitInit()
    -- [FIX] Use Dot Notation (.) for OVHL
    self.Logger = require(ReplicatedStorage.OVHL.Core.OVHL).GetSystem("SmartLogger")
    self.Logger:Info("CONTROLLER", "PrototypeShopController Initialized")
end

function PrototypeShopController:KnitStart()
    self.Service = Knit.GetService("PrototypeShopService")
    
    task.delay(5, function()
        self:TestTransaction("sword", 1)
    end)
end

function PrototypeShopController:TestTransaction(item, qty)
    self.Logger:Info("TEST", "Initiating Test Transaction...", {item=item, qty=qty})
    
    self.Service:RequestBuy({
        itemId = item,
        amount = qty
    }):andThen(function(success, msg)
        if success then
            self.Logger:Info("TEST", "✅ Transaction Result: SUCCESS", {msg=msg})
        else
            self.Logger:Warn("TEST", "❌ Transaction Result: FAILED", {msg=msg})
        end
    end):catch(function(err)
        self.Logger:Error("TEST", "Transaction Error", {error=tostring(err)})
    end)
end

return PrototypeShopController
