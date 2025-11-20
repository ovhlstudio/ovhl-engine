--[[ @Component: FusionHelper (Improved Trap-Free State Reading) ]]
local FusionHelper = {}

-- Safe read of state or value
function FusionHelper.read(state)
    -- 1. Nil check
    if state == nil then return nil end
    
    -- 2. Basic types - return as-is
    if type(state) ~= "table" and type(state) ~= "function" then
        return state
    end

    -- 3. Callable Check - State Object (Fusion Value, Computed, etc)
    local mt = getmetatable(state)
    if mt and mt.__call then
        -- This is a State Object - call it to get value
        return state()
    end

    -- 4. Function Check - Might be state if not detected above
    if type(state) == "function" then
        return state()
    end

    -- 5. Raw Table (Not a state object) - return as-is
    return state
end

-- Get value safely with nil default
function FusionHelper.readOr(state, default)
    local val = FusionHelper.read(state)
    return (val ~= nil) and val or default
end

-- Check if object is a state object
function FusionHelper.isState(obj)
    if type(obj) ~= "table" then return false end
    local mt = getmetatable(obj)
    return mt and mt.__call and true or false
end

return FusionHelper
