--[[ @Component: ErrorHandler (Centralized) ]]
local ErrorHandler = {}
local Stats = { total = 0, byCat = {} }

function ErrorHandler.Handle(category, err, context)
    Stats.total = Stats.total + 1
    Stats.byCat[category] = (Stats.byCat[category] or 0) + 1
    
    -- Formatting
    local msg = string.format("[OVHL-%s] %s | CTX: %s", category, tostring(err), tostring(context or "N/A"))
    
    -- In a real AAA game, you would send this to Sentry/PlayFab here
    warn(msg) 
    print(debug.traceback())
    
    return nil
end

function ErrorHandler.Wrap(category, func, context)
    return function(...)
        local s, r = pcall(func, ...)
        if not s then
            return ErrorHandler.Handle(category, r, context)
        end
        return r
    end
end

return ErrorHandler
