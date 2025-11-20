--[[ 
    @Component: NetworkBridge (Server - AAA Hybrid Security)
    Combines:
    1. NetworkGuard (Outbound Redaction) - From Snapshot
    2. TypeValidator (Inbound Validation) - From Refactor
]]
local RS = game:GetService('ReplicatedStorage')
local SS = game:GetService('ServerScriptService')

local Guard = require(SS.OVHL.Core.NetworkGuard) -- Redaction
local TypeValidator = require(RS.OVHL.Core.TypeValidator) -- Validation

local Bridge = {}
Bridge.__index = Bridge

function Bridge.New(ctx)
    -- Supports both Logger object or Factory
    local log = ctx.Logger
    if not log and ctx.LoggerFactory then log = ctx.LoggerFactory.Network() end

    local self = setmetatable({ 
        _logger = log, 
        _limit = ctx.RateLimiter 
    }, Bridge)
    
    self._root = RS:FindFirstChild('OVHL_Remotes') or Instance.new('Folder', RS)
    self._root.Name = 'OVHL_Remotes'
    self._services = {}
    return self
end

function Bridge:Register(serviceName, netConfig)
    local reqs = netConfig and netConfig.Requests or {}
    
    for methodName, rules in pairs(reqs) do
        local remoteName = serviceName .. '_' .. methodName
        local rf = Instance.new('RemoteFunction', self._root)
        rf.Name = remoteName
        
        local limitKey = serviceName .. ':' .. methodName
        if rules.RateLimit and self._limit then
            self._limit:SetRule(limitKey, rules.RateLimit.Max, rules.RateLimit.Interval)
        end
        
        rf.OnServerInvoke = function(player, ...)
            -- 1. Rate Limit
            if rules.RateLimit and self._limit and not self._limit:Check(player, limitKey) then
                self._logger:Warn('RateLimit', {Plr=player.Name, Method=methodName})
                return {Success=false, Error='Too Many Requests', Code=429}
            end
            
            -- 2. Inbound Cleaning & Type Validation
            local rawArgs = {...}
            -- Clean malicious strings/numbers
            local cleanArgs = {}
            for i,v in ipairs(rawArgs) do cleanArgs[i] = Guard.CleanIn(v) end
            
            -- Strict Type Check
            if rules.Args then
                local ok, err = TypeValidator.Validate(cleanArgs, rules.Args)
                if not ok then
                     self._logger:Warn('TypeFail', {Plr=player.Name, Err=err})
                     return {Success=false, Error='Invalid Arguments: '..err, Code=400}
                end
            end
            
            -- 3. Execution
            local service = self._services[serviceName]
            if service and service[methodName] then
                local success, res1 = pcall(service[methodName], service, player, table.unpack(cleanArgs))
                
                if not success then
                    self._logger:Error('ExecError', {Method=methodName, Err=res1})
                    return {Success=false, Error='Internal Server Error', Code=500}
                end
                
                -- 4. Outbound Redaction (Prevent leaking secrets)
                return Guard.SanitizeOutbound(res1)
            end
            
            return {Success=false, Error='Service Not Bound', Code=404}
        end
    end
end

function Bridge:Bind(name, srv) self._services[name] = srv end
return Bridge
