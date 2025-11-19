--[[ @Component: FusionHelper (Trap-Free) ]]
local FusionHelper = {}

function FusionHelper.read(state)
    -- 1. Basic types check
    if type(state) ~= "table" and type(state) ~= "function" then
        return state
    end
    
    -- 2. Callable Check (The only safe way in Fusion 0.3)
    local mt = getmetatable(state)
    if mt and mt.__call then
        -- Ini adalah State Object (Computed, Value, dll)
        return state() 
    end
    
    -- 3. Function Check
    if type(state) == "function" then
        return state()
    end
    
    -- 4. Raw Table (Not a state)
    return state
end

return FusionHelper
