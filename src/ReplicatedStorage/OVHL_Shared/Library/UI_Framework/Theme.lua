-- [[ UI THEME ]]
return {
    Colors = {
        Primary = Color3.fromRGB(0, 120, 215),    -- Blue
        Secondary = Color3.fromRGB(60, 60, 60),   -- Dark Grey
        Background = Color3.fromRGB(30, 30, 30),  -- Black-ish
        Text = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(40, 200, 80),
        Danger = Color3.fromRGB(220, 60, 60),
        Warning = Color3.fromRGB(220, 180, 40)
    },
    Fonts = {
        Title = Enum.Font.GothamBold,
        Body = Enum.Font.GothamMedium
    },
    Radius = {
        Small = UDim.new(0, 4),
        Medium = UDim.new(0, 8),
        Large = UDim.new(0, 16)
    }
}
