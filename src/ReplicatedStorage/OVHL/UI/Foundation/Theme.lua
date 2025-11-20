local Theme = {
    Colors = {
        Background  = Color3.fromHex("0B1120"), -- Slate 950
        Panel       = Color3.fromHex("151F32"), -- Slate 900
        Surface     = Color3.fromHex("1E293B"), -- Slate 800
        Input       = Color3.fromHex("334155"), -- Slate 700
        
        -- [FIX] HEADER COLOR (INI YG BIKIN ITEM KALO GAK ADA)
        Header      = Color3.fromHex("1E293B"), -- Sama kayak Surface biar nyatu
        
        Primary     = Color3.fromHex("3B82F6"), -- Blue
        Danger      = Color3.fromHex("EF4444"), -- Red
        Success     = Color3.fromHex("10B981"), -- Green
        Warning     = Color3.fromHex("F59E0B"), -- Amber
        
        TextMain    = Color3.new(1, 1, 1),      -- Pure White
        TextSub     = Color3.fromHex("CBD5E1"), 
        TextMuted   = Color3.fromHex("64748B"),
        
        ModalTitle  = Color3.new(1, 1, 1), 
        
        Border      = Color3.fromHex("334155"),
        
        Rank = {
            [0] = Color3.fromHex("94A3B8"), [1] = Color3.fromHex("FCD34D"),
            [2] = Color3.fromHex("38BDF8"), [3] = Color3.fromHex("818CF8"),
            [4] = Color3.fromHex("C084FC"), [5] = Color3.fromHex("F43F5E")
        }
    },
    Fonts = {
        Title = Enum.Font.GothamBlack,
        Body  = Enum.Font.GothamBold,
        Small = Enum.Font.GothamMedium
    },
    Metrics = { 
        Radius = UDim.new(0, 8), 
        Padding = UDim.new(0, 16),
        ModalTitleSize = 32
    },
    ZIndex = { Window = 50, Modal = 200 }
}
return Theme
