--[[ @Component: NetworkBridge (Client - Wally Promise) ]]
local RS = game:GetService("ReplicatedStorage")
-- WALLY REQUIRE
local Promise = require(RS.Packages.Promise) 

local Bridge = {}
Bridge.__index = Bridge

function Bridge.New() 
    return setmetatable({_f = RS:WaitForChild("OVHL_Remotes")}, Bridge) 
end

function Bridge:Get(srvName)
    return setmetatable({}, {
        __index = function(_, key)
            return function(this, ...)
                local args = {...}
                local remName = srvName .. "_" .. key
                local remote = self._f:WaitForChild(remName, 5)
                
                return Promise.new(function(resolve, reject)
                    if not remote then return reject("Remote Timeout: "..remName) end
                    local res = remote:InvokeServer(table.unpack(args))
                    -- Server V2 always returns wrapper table {Success, ...} logic handled by guard
                    -- Tapi NetworkBridge server V2 di FASE 6 mengembalikan RAW values hasil sanitize, 
                    -- bukan table wrapper Success=true. Mari kita perbaiki logic penerimaan.
                    -- Revisi: Code server fase 6 unpack(result).
                    resolve(res) 
                end)
            end
        end
    })
end
return Bridge
