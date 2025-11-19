-- [[ SHOP MODULE CONFIG ]]
return {
    Items = {
        Sword = { Price = 10, MaxStack = 1 },
        Shield = { Price = 20, MaxStack = 1 },
        Potion = { Price = 5, MaxStack = 99 }
    },
    Limits = {
        BuyItem = { max = 3, window = 5 }
    }
}
