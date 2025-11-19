-- [[ OVHL V2 SIGNAL ]]
-- Lightweight Event System
local Signal = {}
Signal.__index = Signal

function Signal.new()
    return setmetatable({ _listeners = {} }, Signal)
end

function Signal:Connect(callback)
    local listener = { callback = callback, active = true }
    table.insert(self._listeners, listener)
    return {
        Disconnect = function()
            listener.active = false
        end
    }
end

function Signal:Fire(...)
    for _, listener in ipairs(self._listeners) do
        if listener.active then
            task.spawn(listener.callback, ...)
        end
    end
    -- Cleanup inactive listeners occasionally could be added here
end

function Signal:Destroy()
    self._listeners = {}
end

return Signal
