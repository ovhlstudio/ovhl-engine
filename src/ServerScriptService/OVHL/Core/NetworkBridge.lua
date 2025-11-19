--[[ @Component: NetworkBridge (Server - Hardened) ]]
local RS = game:GetService("ReplicatedStorage")
-- ABSOLUTE REQUIRES
local Guard = require(game:GetService("ServerScriptService").OVHL.Core.NetworkGuard)
local Bridge = {}
Bridge.__index = Bridge

function Bridge.New(ctx)
    local self = setmetatable({ _logger=ctx.Logger, _limit=ctx.RateLimiter }, Bridge)
    self._root = RS:FindFirstChild("OVHL_Remotes") or Instance.new("Folder", RS)
    self._root.Name = "OVHL_Remotes"
    self._services = {}
    return self
end

-- STRICT TYPE CHECKER
local function CheckTypes(args, schemas)
    if not schemas then return true end
    for i, schemaType in ipairs(schemas) do
        local val = args[i]
        if type(val) ~= schemaType then return false, "Arg #"..i.." expected "..schemaType..", got "..type(val) end
    end
    return true
end

function Bridge:Register(name, config)
    self._logger:Debug("NET", "Bridging Service (Strict)", {Name=name})
    local rules = config and config.Requests or {}
    
    for method, rule in pairs(rules) do
        local rf = Instance.new("RemoteFunction", self._root)
        rf.Name = name .. "_" .. method -- Flattened Name
        
        if rule.RateLimit then
            self._limit:SetRule(rule.Action, rule.RateLimit.Max, rule.RateLimit.Interval)
        end
        
        rf.OnServerInvoke = function(player, ...)
            -- 1. Rate Limit
            if rule.RateLimit and not self._limit:Check(player, rule.Action) then
                return {Success=false, Error="Rate Limit Exceeded"}
            end
            
            -- 2. Guard Input (Sanitasi)
            local args = {...}
            for i,v in ipairs(args) do args[i] = Guard.CleanIn(v) end
            
            -- 3. STRICT TYPE VALIDATION (New Feature)
            if rule.Args then
                local ok, msg = CheckTypes(args, rule.Args)
                if not ok then 
                    self._logger:Warn("NET", "Type Mismatch", {Plr=player.Name, Err=msg})
                    return {Success=false, Error="Invalid Argument Type"} 
                end
            end
            
            -- 4. Call Service
            local srv = self._services[name]
            if srv and srv[method] then
                local result = {srv[method](srv, player, table.unpack(args))}
                -- Sanitize Output
                for i,v in ipairs(result) do result[i] = Guard.SanitizeOutbound(v) end
                return table.unpack(result)
            end
            return {Success=false, Error="Method 404"}
        end
    end
end

function Bridge:Bind(name, obj) self._services[name] = obj end
return Bridge
