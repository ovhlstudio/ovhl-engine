--[[ @Component: UIService (Standardized Section 8) ]]
local UIService = {}
local Registry = {} -- Holds Controller Views

-- Register a View Instance to manage
function UIService:Register(name, viewInstance)
    if Registry[name] then 
        warn("[UIService] Overwriting view:", name)
    end
    Registry[name] = viewInstance
end

function UIService:Get(name)
    return Registry[name]
end

function UIService:Open(name)
    local view = Registry[name]
    if view and view.Toggle then
        view.Toggle(true)
    elseif view and typeof(view) == "Instance" then
        view.Enabled = true -- Fallback for Native ScreenGuis
    end
end

function UIService:Close(name)
    local view = Registry[name]
    if view and view.Toggle then
        view.Toggle(false)
    elseif view and typeof(view) == "Instance" then
        view.Enabled = false
    end
end

return UIService
