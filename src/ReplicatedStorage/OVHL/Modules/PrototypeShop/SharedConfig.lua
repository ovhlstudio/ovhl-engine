return {
    Permission = { Actions = { Buy=0, Admin=4 } },
    Topbar = { Enabled=true, Text="SHOP", Icon="rbxassetid://6031225837" },
    UI = {
        Native="ShopNativeUI",
        Defaults = { Title="WEAPON SHOP V2" },
        Components = { 
            Title="HeaderTitle", 
            BuyBtn={Name="Btn_Buy", Action="Buy"},
            CloseBtn={Name="Btn_Close"}
        }
    },
    Network = {
        Requests = {
            BuyItem = { 
                Args={"string"}, 
                Action="Buy",
                RateLimit={Max=5, Interval=2}
            }
        }
    }
}
