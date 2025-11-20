
local RS = game:GetService("ReplicatedStorage")
local UI = require(RS.OVHL.UI.API)
local Fusion = UI.Fusion
local scoped, Children = Fusion.scoped, Fusion.Children

local UIService = {}
local Registry = {}
local scope = scoped(Fusion)
local Toasts = scope:Value({})

function UIService:Init(ctx)
    self.Logger = ctx.Logger
    
    -- TOAST LAYER (ZIndex Paling Tinggi)
    UI.API.Mount(scope, scope:New "ScreenGui" {
        Name = "OVHL_ToastLayer",
        DisplayOrder = 1000, -- Diatas segalanya
        [Children] = {
            scope:New "Frame" {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                [Children] = {
                    scope:New "UIListLayout" { 
                        VerticalAlignment = "Bottom", 
                        HorizontalAlignment = "Center", 
                        Padding = UDim.new(0, 10) 
                    },
                    scope:New "UIPadding" { PaddingBottom = UDim.new(0, 50) }, -- Naik dikit biar gak kena tombol loncat hp
                    scope:ForValues(Toasts, function(use, scope, t)
                        return UI.Toast(scope, { Message = t.Msg, Type = t.Type })
                    end)
                }
            }
        }
    })
end

function UIService:Register(n, v) 
    Registry[n] = v 
end

function UIService:Open(n) 
    if Registry[n] then 
        -- [FIX] PAKE TITIK DUA (:) BUKAN TITIK (.)
        Registry[n]:Toggle(true) 
    end 
end

function UIService:Close(n) 
    if Registry[n] then 
        -- [FIX] PAKE TITIK DUA (:) BUKAN TITIK (.)
        Registry[n]:Toggle(false) 
    end 
end

function UIService:ShowToast(msg, kind)
    local list = Fusion.peek(Toasts)
    local id = os.time() .. math.random()
    table.insert(list, { Id=id, Msg=msg, Type=kind or "Info" })
    Toasts:set(list)
    
    -- Auto close 3 detik
    task.delay(3, function()
        local curr = Fusion.peek(Toasts)
        local newList = {}
        for _, v in ipairs(curr) do 
            if v.Id ~= id then table.insert(newList, v) end 
        end
        Toasts:set(newList)
    end)
end

return UIService

