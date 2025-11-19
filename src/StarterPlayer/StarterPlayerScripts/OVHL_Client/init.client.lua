-- [[ CLIENT BOOT (ABSOLUTE) ]]
local OVHL = require(game:GetService("ReplicatedStorage").OVHL_Shared)
OVHL.Logger:Info("CLIENT", "🚀 Starting Client...")

local function Scan(p, ctx)
    if not p then return end
    for _, c in ipairs(p:GetDescendants()) do
        if c:IsA("ModuleScript") then
            require(c); OVHL.Logger:Debug("LOADER", "Loaded "..ctx..": "..c.Name)
        end
    end
end
Scan(script:WaitForChild("Systems", 10), "System")
Scan(script:WaitForChild("Modules", 10), "Module")
OVHL.Start()
