local Srv = {}
function Srv:Init(ctx) self.Log=ctx.Logger end
function Srv:Start() self.Log:Info("SHOP", "Server Ready") end

function Srv:BuyItem(player, item)
    self.Log:Info("SHOP", "Buying", {Plr=player.Name, Item=item})
    if item == "Sword" then return {Success=true, Msg="Purchased Sword"} end
    return {Success=false, Msg="Invalid Item"}
end
return Srv
