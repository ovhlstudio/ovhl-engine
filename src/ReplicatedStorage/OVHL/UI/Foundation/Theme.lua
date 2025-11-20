local Theme = {
    Colors = {
        Primary = Color3.fromHex("007AFF"), Secondary = Color3.fromHex("95A5A6"),
        Success = Color3.fromHex("2ECC71"), Danger = Color3.fromHex("E74C3C"),
        Warning = Color3.fromHex("F1C40F"), Background = Color3.fromHex("121212"),
        Surface = Color3.fromHex("1F1F1F"), Border = Color3.fromHex("404040"),
        TextMain = Color3.fromHex("FFFFFF"), TextDim = Color3.fromHex("CCCCCC")
    },
    Metrics = {
        Padding = {Small=8, Medium=16}, 
        Radius = {Small=UDim.new(0,6), Medium=UDim.new(0,10)} 
    },
    Fonts = {
        Title = Enum.Font.GothamBlack, Body = Enum.Font.GothamMedium, Mono = Enum.Font.RobotoMono
    }
}
return Theme
