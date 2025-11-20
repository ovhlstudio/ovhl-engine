--[[ @Component: NetworkBridge (Server - V2 Standardized) ]]
local RS = game:GetService("ReplicatedStorage")
local Guard = require(script.Parent.NetworkGuard)
local Bridge = {}
Bridge.__index = Bridge

function Bridge.New(ctx)
    local self = setmetatable({ _logger=ctx.Logger, _limit=ctx.RateLimiter }, Bridge)
    self._root = RS:FindFirstChild("OVHL_Remotes") or Instance.new("Folder", RS)
    self._root.Name = "OVHL_Remotes"
    self._services = {}
    return self
end

local function CheckTypes(args, schemas)
    if not schemas then return true end
    for i, schemaType in ipairs(schemas) do
        local val = args[i]
        local t = type(val)
        
        -- Robust check including "any" or "player" if needed
        if schemaType ~= "any" and t ~= schemaType then
             return false, "Arg #"..i.." expected "..schemaType..", got "..t 
        end
    end
    return true
end

function Bridge:Register(serviceName, netConfig)
    -- netConfig refer to config.Network
    local reqs = netConfig and netConfig.Requests or {}
    local routePrefix = netConfig.Route or serviceName
    
    for methodName, rules in pairs(reqs) do
        -- 1. Remote Construction
        -- Naming Scheme: Service_Method (Flattened)
        local remoteName = serviceName .. "_" .. methodName
        local rf = Instance.new("RemoteFunction", self._root)
        rf.Name = remoteName
        
        -- 2. Setup Rate Limit (Default to method name as Action Key)
        local limitKey = serviceName .. ":" .. methodName
        if rules.RateLimit then
            self._limit:SetRule(limitKey, rules.RateLimit.Max, rules.RateLimit.Interval)
        end
        
        -- 3. Bind Execution
        rf.OnServerInvoke = function(player, ...)
            -- A. Rate Limit Check
            if rules.RateLimit and not self._limit:Check(player, limitKey) then
                self._logger:Warn("NET", "Rate Limit Breached", {Plr=player.Name, Method=methodName})
                return {Success=false, Error="Rate Limit Exceeded", Code=429}
            end
            
            -- B. Sanitize Inbound (Deep Clean)
            local rawArgs = {...}
            local args = {}
            for i,v in ipairs(rawArgs) do args[i] = Guard.CleanIn(v) end
            
            -- C. Strict Type Checking
            if rules.Args then
                local ok, err = CheckTypes(args, rules.Args)
                if not ok then
                     self._logger:Warn("NET", "Type Guard Catch", {Plr=player.Name, Err=err})
                     return {Success=false, Error="Invalid Argument Type", Code=400}
                end
            end
            
            -- D. Execution
            local service = self._services[serviceName]
            if service and service[methodName] then
                -- Call Method: Service:Method(player, ...)
                -- Using pcall to prevent server crash from logic error
                local success, result1, result2 = pcall(service[methodName], service, player, table.unpack(args))
                
                if not success then
                    self._logger:Error("NET", "Execution Error", {Method=methodName, Err=result1})
                    return {Success=false, Error="Internal Server Error", Code=500}
                end
                
                -- E. Sanitize Outbound
                return Guard.SanitizeOutbound(result1) -- Single result return standard
            end
            
            return {Success=false, Error="Service Not Bound", Code=404}
        end
    end
end

function Bridge:Bind(name, srv) self._services[name] = srv end
return Bridge
