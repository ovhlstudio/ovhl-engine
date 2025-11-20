# Scopes

In Fusion, you create a lot of objects. These objects need to be destroyed when you're done with them.

Fusion has some coding conventions to make large quantities of objects easier to manage.

---

## Scopes[¶](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/scopes/#scopes "Permanent link")

When you create many objects at once, you often want to destroy them together later.

To make this easier, some people add their objects to an array. Arrays that group together objects like this are given a special name: *scopes*.

To create a new scope, create an empty array.

| `local Fusion = require(ReplicatedStorage.Fusion)local scope = {}` |
| ------------------------------------------------------------------ |

Later, when you create objects, they will ask for a scope as the first argument.

| `local Fusion = require(ReplicatedStorage.Fusion)local scope = {}local thing = Fusion.Value(scope, "i am a thing")` |
| ------------------------------------------------------------------------------------------------------------------- |

That object will add its `destroy()` function to the scope:

| `local Fusion = require(ReplicatedStorage.Fusion)local scope = {}local thing = Fusion.Value(scope, "i am a thing")print(scope[1]) --> function: 0x123456789abcdef` |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |

Repeat as many times as you like. Objects appear in order of creation.

| `local Fusion = require(ReplicatedStorage.Fusion)local scope = {}local thing1 = Fusion.Value(scope, "i am thing 1")local thing2 = Fusion.Value(scope, "i am thing 2")local thing3 = Fusion.Value(scope, "i am thing 3")` |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |

Later, destroy the scope by using the `doCleanup()` function. The contents are destroyed in reverse order.

| `` local Fusion = require(ReplicatedStorage.Fusion)local scope = {}local thing1 = Fusion.Value(scope, "i am thing 1")local thing2 = Fusion.Value(scope, "i am thing 2")local thing3 = Fusion.Value(scope, "i am thing 3")Fusion.doCleanup(scope)-- Using `doCleanup` is conceptually the same as:-- thing3:destroy()-- thing2:destroy()-- thing1:destroy() `` |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

Scopes passed to `doCleanup` can contain:

- Functions to be run (like those `destroy()` functions above)
- Roblox instances to destroy
- Roblox event connections to disconnect
- Your own objects with `:destroy()` or `:Destroy()` methods to be called
- Other nested scopes to be cleaned up

You can add these manually using `table.insert` if you need custom behaviour, or if you are working with objects that don't add themselves to scopes.

That's all there is to scopes. They are arrays of objects which later get passed to a cleanup function.

---

## Improved Scopes[¶](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/scopes/#improved-scopes "Permanent link")

This syntax is recommended

From now on, you'll see this syntax used throughout the tutorials.

Fusion can help manage your scopes for you. This unlocks convenient syntax, and allows Fusion to optimise your code.

You can call `scoped()` to obtain a new scope.

| `local Fusion = require(ReplicatedStorage.Fusion)local scoped = Fusion.scopedlocal scope = scoped()local thing1 = Fusion.Value(scope, "i am thing 1")local thing2 = Fusion.Value(scope, "i am thing 2")local thing3 = Fusion.Value(scope, "i am thing 3")Fusion.doCleanup(scope)` |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

Unlike `{}` (which always creates a new array), `scoped` can re-use old arrays. This helps keep your program running smoothly.

Beyond making your code more efficient, you can also use `scoped` for convenient syntax.

You can pass a table of functions into `scoped`:

| `local Fusion = require(ReplicatedStorage.Fusion)local scoped = Fusion.scopedlocal scope = scoped({    Value = Fusion.Value,    doCleanup = Fusion.doCleanup})local thing1 = Fusion.Value(scope, "i am thing 1")local thing2 = Fusion.Value(scope, "i am thing 2")local thing3 = Fusion.Value(scope, "i am thing 3")Fusion.doCleanup(scope)` |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

If those functions take `scope` as their first argument, you can use them as methods directly on the scope:

| `local Fusion = require(ReplicatedStorage.Fusion)local scoped = Fusion.scopedlocal scope = scoped({    Value = Fusion.Value,    doCleanup = Fusion.doCleanup})local thing1 = scope:Value("i am thing 1")local thing2 = scope:Value("i am thing 2")local thing3 = scope:Value("i am thing 3")scope:doCleanup()` |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

This makes it harder to mess up writing scopes. Your code reads more naturally, too.

### Adding Methods In Bulk[¶](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/scopes/#adding-methods-in-bulk "Permanent link")

Try passing `Fusion` to `scoped()` \- it's a table with functions, too.

```
`local scope = scoped(Fusion)
-- all still works!
local thing1 = scope:Value("i am thing 1")
local thing2 = scope:Value("i am thing 2")
local thing3 = scope:Value("i am thing 3")

scope:doCleanup()
`
```

This gives you access to all of Fusion's functions without having to import each one manually.

If you need to mix in other things, you can pass in another table.

```
`local scope = scoped(Fusion, {
    Foo = ...,
    Bar = ...
})
`
```

You can do this for as many tables as you need.

Conflicting names

If you pass in two tables that contain things with the same name, `scoped()` will error.

### Reusing Methods From Other Scopes[¶](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/scopes/#reusing-methods-from-other-scopes "Permanent link")

Sometimes, you'll want to make a new scope with the same methods as an existing scope.

```
`local foo = scoped({
    Foo = Foo,
    Bar = Bar,
    Baz = Baz
})

-- `bar` should have the same methods as `foo`
-- it'd be nice to define this once only...
local bar = scoped({
    Foo = Foo,
    Bar = Bar,
    Baz = Baz
})

print(foo.Baz == bar.Baz) --> true

bar:doCleanup()
foo:doCleanup()
`
```

To do this, Fusion provides a `deriveScope` function. It behaves like `scoped` but lets you skip defining the methods. Instead, you give it an example of what the scope should look like.

```
`local foo = scoped({
    Foo = Foo,
    Bar = Bar,
    Baz = Baz
})

-- `bar` should have the same methods as `foo`
-- now, it's only defined once!
local bar = foo:deriveScope()
print(foo.Baz == bar.Baz) --> true

bar:doCleanup()
foo:doCleanup()
`
```

*Deriving* scopes like this is highly efficient because Fusion can re-use the same information for both scopes. It also helps keep your definitions all in one place.

You can also add more method tables if you'd like to.

```
`local foo = scoped({
    Foo = Foo,
    Bar = Bar,
    Baz = Baz
})

-- `bar` should have the same methods as `foo`
-- now, it's only defined once!
local bar = foo:deriveScope({
    Garb = Garb
})

print(bar.Garb) --> function: 0x123456789abcdef
print(foo.Garb) --> nil
`
```

### Inner Scopes[¶](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/scopes/#inner-scopes "Permanent link")

The main reason you would want to create a new scope is to create things that get destroyed at different times.

For example, imagine you're creating a dropdown menu. You create a new scope for the menu, which you clean up when the menu is closed.

```
`local uiScope = scoped(Fusion)

-- ... create the ui ...

table.insert(
    uiScope,
    dropdownOpened:Connect(function()
        local dropdownScope = uiScope:deriveScope()

        -- ... create the dropdown ...

        table.insert(
            dropdownScope,
            dropdownClosed:Connect(function()
                dropdownScope:doCleanup()
            end)
        )
    end)
)
`
```

This ordinarily works just fine; when the dropdown is opened, the new scope is created, and when the dropdown is closed, the new scope is destroyed.

However, what if the UI gets cleaned up while the dropdown is open? The `uiScope` will get cleaned up, but the `dropdownScope` will not.

To help with this, Fusion provides an `innerScope` method. It works just like `deriveScope`, but it adds in extra logic:

- When the original scope is cleaned up, the 'inner scope' is cleaned up too
- You can still call `doCleanup()` to clean the inner scope up early

```
`local uiScope = scoped(Fusion)

-- ... create the ui ...

table.insert(
    uiScope,
    dropdownOpened:Connect(function()
        local dropdownScope = uiScope:innerScope()
        -- ... create the dropdown ...

        table.insert(
            dropdownScope,
            dropdownClosed:Connect(function()
                dropdownScope:doCleanup()
            end)
        )
    end)
)
`
```

Now, the dropdown scope is guaranteed to be cleaned up if the UI it came from is cleaned up. This strictly limits how long the dropdown can exist for.

Inner scopes are often the safest choice for creating new scopes. They let you call `doCleanup` whenever you like, but guarantee that they won't stick around beyond the rest of the code they're in.

---

## When You'll Use This[¶](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/scopes/#when-youll-use-this "Permanent link")

Scopes might sound like a lot of upfront work. However, you'll find in practice that Fusion manages a lot of this for you, and it makes your code much more resilient to memory leaks and other kinds of memory management issues.

You'll need to create and destroy your own scopes manually sometimes. For example, you'll need to create a scope in your main code file to start using Fusion, and you might want to make a few more in other parts of your code.

However, Fusion manages most of your scopes for you, so for large parts of your codebase, you won't have to consider scopes and destruction at all.
Values
======

Now that you understand how Fusion works with objects, you can create Fusion's simplest object.

Values are objects which store single values. You can write to them with their `:set()` method, and read from them with the `peek()` function.

```
`local health = scope:Value(100)

print(peek(health)) --> 100
health:set(25)
print(peek(health)) --> 25
`
```

---

## Usage[¶](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/values/#usage "Permanent link")

To create a new value object, call `scope:Value()` and give it a value you want to store.

| `local Fusion = require(ReplicatedStorage.Fusion)local doCleanup, scoped = Fusion.doCleanup, Fusion.scopedlocal scope = scoped(Fusion)local health = scope:Value(5)` |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

Fusion provides a global `peek()` function. It will read the value of whatever you give it. You'll use `peek()` to read the value of lots of things; for now, it's useful for printing `health` back out.

| `local Fusion = require(ReplicatedStorage.Fusion)local doCleanup, scoped = Fusion.doCleanup, Fusion.scopedlocal peek = Fusion.peeklocal scope = scoped(Fusion)local health = scope:Value(5)print(peek(health)) --> 5` |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

You can change the value using the `:set()` method. Unlike `peek()`, this is specific to value objects, so it's done on the object itself.

| `local scope = scoped(Fusion)local health = scope:Value(5)print(peek(health)) --> 5health:set(25)print(peek(health)) --> 25` |
| ---------------------------------------------------------------------------------------------------------------------------- |

`:set()` returns the value you give it

You can use `:set()` in the middle of calculations:

```
`local myNumber = scope:Value(0)
local computation = 10 + myNumber:set(2 + 2)
print(computation) --> 14
print(peek(myNumber)) --> 4
`
```

This is useful when building complex expressions. On a later page, you'll see one such use case.

Generally though, it's better to keep your expressions simple.

Value objects are Fusion's simplest 'state object'. State objects contain a single value - their *state*, you might say - and that single value can be read out at any time using `peek()`.

Later on, you'll discover more advanced state objects that can calculate their value in more interesting ways.

# Observers

When you're working with state objects, it can be useful to detect various changes that happen to them.

Observers allow you to detect those changes. Create one with a state object to 'watch', then connect code to run using `:onChange()` or `:onBind()`.

```
`local observer = scope:Observer(health)
local disconnect = observer:onChange(function()
    print("The new value is: ", peek(health))
end)
task.wait(5)
disconnect()
`
```

---

## Usage[¶](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/observers/#usage "Permanent link")

To create a new observer object, call `scope:Observer()` and give it a state object you want to detect changes on.

| `local scope = scoped(Fusion)local health = scope:Value(5)local observer = scope:Observer(health)` |
| -------------------------------------------------------------------------------------------------- |

The observer will watch the state object for changes until it's destroyed. You can take advantage of this by connecting your own code using the observer's different methods.

The first method is `:onChange()`, which runs your code when the state object changes value.

Luau codeOutput

| `local observer = scope:Observer(health)print("...connecting...")observer:onChange(function()    print("Observed a change to: ", peek(health))end)print("...setting health to 25...")health:set(25)` |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

By default, the `:onChange()` connection is disconnected when the observer object is destroyed. However, if you want to disconnect it earlier, the `:onChange()` method returns an optional disconnect function. Calling it will disconnect that specific `:onChange()` handler early.

| `local disconnect = observer:onChange(function()    print("The new value is: ", peek(health))end)-- disconnect the above handler after 5 secondstask.wait(5)disconnect()` |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

The second method is `:onBind()`. It works identically to `:onChange()`, but it also runs your code right away, which can often be useful.

Luau codeOutput

| `local observer = scope:Observer(health)print("...connecting...")observer:onBind(function()    print("Observed a change to: ", peek(health))end)print("...setting health to 25...")health:set(25)` |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

---

## What Counts As A Change?[¶](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/observers/#what-counts-as-a-change "Permanent link")

If you set the `health` to the same value multiple times in a row, you might notice your observer only runs the first time.

Luau codeOutput

| `local observer = scope:Observer(health)observer:onChange(function()    print("Observed a change to: ", peek(health))end)print("...setting health to 25 three times...")health:set(25)health:set(25)health:set(25)` |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

This is because the `health` object sees that it isn't actually changing value, so it doesn't broadcast any updates. Therefore, our observer doesn't run.

This leads to improved performance because your code runs less often. Fusion applies these kinds of optimisations generously throughout your program.

# Computeds

Computeds are state objects that immediately process values from other state objects.

You pass in a callback to define a calculation. Then, you can use `peek()` to read the result of the calculation at any time.

```
`local numCoins = scope:Value(50)
local itemPrice = scope:Value(10)

local finalCoins = scope:Computed(function(use, scope)
    return use(numCoins) - use(itemPrice)
end)

print(peek(finalCoins)) --> 40

numCoins:set(25)
itemPrice:set(15)
print(peek(finalCoins)) --> 10
`
```

---

## Usage[¶](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/computeds/#usage "Permanent link")

To create a new computed object, call `scope:Computed()` and give it a function that performs your calculation. It takes two parameters which will be explained later; for the first part of this tutorial, they'll be left unnamed.

| `local scope = scoped(Fusion)local hardMaths = scope:Computed(function(_, _)    return 1 + 1end)` |
| ------------------------------------------------------------------------------------------------- |

The value the callback returns will be stored as the computed's value. You can get the computed's current value using `peek()`:

| `local scope = scoped(Fusion)local hardMaths = scope:Computed(function(_, _)    return 1 + 1end)print(peek(hardMaths)) --> 2` |
| ----------------------------------------------------------------------------------------------------------------------------- |

The calculation should be *immediate* \- that is, it should never delay. That means you should not use computed objects when you need to wait for something to occur (e.g. waiting for a server to respond to a request).

---

## Using State Objects[¶](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/computeds/#using-state-objects "Permanent link")

The calculation is only run once by default. If you try to `peek()` at state objects inside the calculation, your code breaks quickly:

| `local scope = scoped(Fusion)local number = scope:Value(2)local double = scope:Computed(function(_, _)    return peek(number) * 2end)print(peek(number), peek(double)) --> 2 4-- The calculation won't re-run! Oh no!number:set(10)print(peek(number), peek(double)) --> 10 4` |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |

Instead, the computed object provides a `use` function as the first argument. As your logic runs, you can call this function with different state objects. If any of them changes, then the computed throws everything away and recalculates.

| `` local scope = scoped(Fusion)local number = scope:Value(2)local double = scope:Computed(function(use, _)    use(number) -- the calculation will re-run when `number` changes value    return peek(number) * 2end)print(peek(number), peek(double)) --> 2 4-- Now it re-runs!number:set(10)print(peek(number), peek(double)) --> 10 20 `` |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |

For convenience, `use()` will also read the value, just like `peek()`, so you can easily replace `peek()` calls with `use()` calls. This keeps your logic concise, readable and easily copyable.

| `local scope = scoped(Fusion)local number = scope:Value(2)local double = scope:Computed(function(use, _)    return use(number) * 2end)print(peek(number), peek(double)) --> 2 4number:set(10)print(peek(number), peek(double)) --> 10 20` |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

It's recommended you always give the first parameter the name `use`, even if it already exists. This helps prevent you from using the wrong parameter if you have multiple computed objects at the same time.

```
`scope:Computed(function(use, _)
    -- ...
    scope:Computed(function(use, _)
        -- ...
        scope:Computed(function(use, _)
            return use(number) * 2
        end)
        -- ...
    end)
    -- ...
end)
`
```

Help! Using the same name gives me a warning.

Depending on your setup, Luau might be configured to warn when you use the same variable name multiple times.

In many cases, using the same variable name can be a mistake, but in this case we actually find it useful. So, to turn off the warning, try adding `--!nolint LocalShadow` to the top of your file.

Keep in mind that Fusion sometimes applies optimisations; recalculations might be postponed or cancelled if the value of the computed isn't being used. This is why you should not use computed objects for things like playing sound effects.

[You will learn more about how Fusion does this later.](https://elttob.uk/Fusion/0.3/tutorials/best-practices/optimisation/#similarity)

---

## Inner Scopes[¶](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/computeds/#inner-scopes "Permanent link")

Sometimes, you'll need to create things inside computed objects temporarily. In these cases, you want the temporary things to be destroyed when you're done.

You might try and reuse the scope you already have, to construct objects and add cleanup tasks.

Luau codeOutput

| `local scope = scoped(Fusion)local number = scope:Value(5)local double = scope:Computed(function(use, _)    local current = use(number)    print("Creating", current)    -- suppose we want to run some cleanup code for stuff in here    table.insert(scope, function()        print("Destroying", current)    end)    return current * 2end)print("...setting to 25...")number:set(25)print("...setting to 2...")number:set(2)print("...cleaning up...")doCleanup(scope)` |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

However, this doesn't work the way you'd want it to. All of the tasks pile up at the end of the program, instead of being thrown away with the rest of the calculation.

That's why the second argument is a different scope for you to use while inside the computed object. This scope argument is automatically cleaned up for you when the computed object recalculates.

Luau codeOutput

| `local scope = scoped(Fusion)local number = scope:Value(5)local double = scope:Computed(function(use, myBrandNewScope)    local current = use(number)    print("Creating", current)    table.insert(myBrandNewScope, function()        print("Destroying", current)    end)    return current * 2end)print("...setting to 25...")number:set(25)print("...setting to 2...")number:set(2)print("...cleaning up...")doCleanup(scope)` |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

When using this new 'inner' scope, the tasks no longer pile up at the end of the program. Instead, they're cleaned up as soon as possible, when the computed object throws away the old calculation.

It can help to give this parameter the same name as the original scope. This stops you from accidentally using the original scope inside the computed, and makes your code more easily copyable and movable.

```
`local scope = scoped(Fusion)
scope:Computed(function(use, scope)
    -- ...
    scope:Computed(function(use, scope)
        -- ...
        scope:Computed(function(use, scope)
            local innerValue = scope:Value(5)
        end)
        -- ...
    end)
    -- ...
end)
`
```

Help! Using the same name gives me a warning.

Depending on your setup, Luau might be configured to warn when you use the same variable name multiple times.

In many cases, using the same variable name can be a mistake, but in this case we actually find it useful. So, to turn off the warning, try adding `--!nolint LocalShadow` to the top of your file.

Once you understand computeds, as well as the previously discussed scopes, values and observers, you're well positioned to explore the rest of Fusion.

# ForValues

`ForValues` is a state object that processes values from another table.

It supports both constants and state objects.

```
`local numbers = {1, 2, 3, 4, 5}
local multiplier = scope:Value(2)

local multiplied = scope:ForValues(numbers, function(use, scope, num)
    return num * use(multiplier)
end)

print(peek(multiplied)) --> {2, 4, 6, 8, 10}

multiplier:set(10)
print(peek(multiplied)) --> {10, 20, 30, 40, 50}
`
```

---

## Usage[¶](https://elttob.uk/Fusion/0.3/tutorials/tables/forvalues/#usage "Permanent link")

To create a new `ForValues` object, call the constructor with an input table and a processor function. The first two arguments are `use` and `scope`, just like [computed objects](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/computeds). The third argument is one of the values read from the input table.

```
`local numbers = {1, 2, 3, 4, 5}
local doubled = scope:ForValues(numbers, function(use, scope, num)
    return num * 2
end)
`
```

You can read the table of processed values using `peek()`:

```
`local numbers = {1, 2, 3, 4, 5}
local doubled = scope:ForValues(numbers, function(use, scope, num)
    return num * 2
end)

print(peek(doubled)) --> {2, 4, 6, 8, 10}
`
```

The input table can be a state object. When the input table changes, the output will update.

```
`local numbers = scope:Value({})
local doubled = scope:ForValues(numbers, function(use, scope, num)
    return num * 2
end)

numbers:set({1, 2, 3, 4, 5})
print(peek(doubled)) --> {2, 4, 6, 8, 10}

numbers:set({5, 15, 25})
print(peek(doubled)) --> {10, 30, 50}
`
```

You can also `use()` state objects in your calculations, just like a computed.

```
`local numbers = {1, 2, 3, 4, 5}
local factor = scope:Value(2)
local multiplied = scope:ForValues(numbers, function(use, scope, num)
    return num * use(factor)
end)

print(peek(multiplied)) --> {2, 4, 6, 8, 10}

factor:set(10)
print(peek(multiplied)) --> {10, 20, 30, 40, 50}
`
```

Anything added to the `scope` is cleaned up for you when the processed value is removed.

```
`local names = scope:Value({"Jodi", "Amber", "Umair"})
local shoutingNames = scope:ForValues(names, function(use, scope, name)
    table.insert(scope, function()
        print("Goodbye, " .. name .. "!")
    end)
    return string.upper(name)
end)

names:set({"Amber", "Umair"}) --> Goodbye, Jodi!`
```

# ForKeys

`ForKeys` is a state object that processes keys from another table.

It supports both constants and state objects.

```
`local data = {Red = "foo", Blue = "bar"}
local prefix = scope:Value("Key_")

local renamed = scope:ForKeys(data, function(use, scope, key)
    return use(prefix) .. key
end)

print(peek(renamed)) --> {Key_Red = "foo", Key_Blue = "bar"}

prefix:set("colour")
print(peek(renamed)) --> {colourRed = "foo", colourBlue = "bar"}
`
```

---

## Usage[¶](https://elttob.uk/Fusion/0.3/tutorials/tables/forkeys/#usage "Permanent link")

To create a new `ForKeys` object, call the constructor with an input table and a processor function. The first two arguments are `use` and `scope`, just like [computed objects](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/computeds). The third argument is one of the keys read from the input table.

```
`local data = {red = "foo", blue = "bar"}
local renamed = scope:ForKeys(data, function(use, scope, key)
    return string.upper(key)
end)
`
```

You can read the table of processed keys using `peek()`:

```
`local data = {red = "foo", blue = "bar"}
local renamed = scope:ForKeys(data, function(use, scope, key)
    return string.upper(key)
end)

print(peek(renamed)) --> {RED = "foo", BLUE = "bar"}
`
```

The input table can be a state object. When the input table changes, the output will update.

```
`local foodSet = scope:Value({})

local prefixes = { pie = "tasty", chocolate = "yummy", broccoli = "gross" }
local renamedFoodSet = scope:ForKeys(foodSet, function(use, scope, food)
    return prefixes[food] .. food
end)

foodSet:set({ pie = true })
print(peek(renamedFoodSet)) --> { tasty_pie = true }

foodSet:set({ broccoli = true, chocolate = true })
print(peek(renamedFoodSet)) --> { gross_broccoli = true, yummy_chocolate = true }
`
```

You can also `use()` state objects in your calculations, just like a computed.

```
`local foodSet = scope:Value({ broccoli = true, chocolate = true })

local prefixes = { chocolate = "yummy", broccoli = scope:Value("gross") }
local renamedFoodSet = scope:ForKeys(foodSet, function(use, scope, food)
    return use(prefixes[food]) .. food
end)

print(peek(renamedFoodSet)) --> { gross_broccoli = true, yummy_chocolate = true }

prefixes.broccoli:set("scrumptious")
print(peek(renamedFoodSet)) --> { scrumptious_broccoli = true, yummy_chocolate = true }
`
```

Anything added to the `scope` is cleaned up for you when the processed key is removed.

```
`local foodSet = scope:Value({ broccoli = true, chocolate = true })

local shoutingFoodSet = scope:ForKeys(names, function(use, scope, food)
    table.insert(scope, function()
        print("I ate the " .. food .. "!")
    end)
    return string.upper(food)
end)

names:set({ chocolate = true }) --> I ate the broccoli!`
```

# ForPairs

`ForPairs` is like `ForValues` and `ForKeys` in one object. It can process pairs of keys and values at the same time.

It supports both constants and state objects.

```
`local itemColours = { shoes = "red", socks = "blue" }
local owner = scope:Value("Janet")

local manipulated = scope:ForPairs(itemColours, function(use, scope, thing, colour)
    local newKey = colour
    local newValue = use(owner) .. "'s " .. thing
    return newKey, newValue
end)

print(peek(manipulated)) --> {red = "Janet's shoes", blue = "Janet's socks"}

owner:set("April")
print(peek(manipulated)) --> {red = "April's shoes", blue = "April's socks"}
`
```

---

## Usage[¶](https://elttob.uk/Fusion/0.3/tutorials/tables/forpairs/#usage "Permanent link")

To create a new `ForPairs` object, call the constructor with an input table and a processor function. The first two arguments are `use` and `scope`, just like [computed objects](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/computeds). The third and fourth arguments are one of the key-value pairs read from the input table.

```
`local itemColours = { shoes = "red", socks = "blue" }
local swapped = scope:ForPairs(data, function(use, scope, item, colour)
    return colour, item
end)
`
```

You can read the processed table using `peek()`:

```
`local itemColours = { shoes = "red", socks = "blue" }
local swapped = scope:ForPairs(data, function(use, scope, item, colour)
    return colour, item
end)

print(peek(swapped)) --> { red = "shoes", blue = "socks" }
`
```

The input table can be a state object. When the input table changes, the output will update.

```
`local itemColours = scope:Value({ shoes = "red", socks = "blue" })
local swapped = scope:ForPairs(data, function(use, scope, item, colour)
    return colour, item
end)

print(peek(swapped)) --> { red = "shoes", blue = "socks" }

itemColours:set({ sandals = "red", socks = "green" })
print(peek(swapped)) --> { red = "sandals", green = "socks" }
`
```

You can also `use()` state objects in your calculations, just like a computed.

```
`local itemColours = { shoes = "red", socks = "blue" }

local shouldSwap = scope:Value(false)
local swapped = scope:ForPairs(data, function(use, scope, item, colour)
    if use(shouldSwap) then
        return colour, item
    else
        return item, colour
    end
end)

print(peek(swapped)) --> { shoes = "red", socks = "blue" }

shouldSwap:set(true)
print(peek(swapped)) --> { red = "shoes", blue = "socks" }
`
```

Anything added to the `scope` is cleaned up for you when either the processed key or the processed value is removed.

```
`local itemColours = scope:Value({ shoes = "red", socks = "blue" })
local swapped = scope:ForPairs(data, function(use, scope, item, colour)
    table.insert(scope, function()
        print("No longer wearing " .. colour .. " " .. item)
    end)
    return colour, item
end)

itemColours:set({ shoes = "red", socks = "green" }) --> No longer wearing blue socks`
```

# Tweens

![Animation and graph showing basic tween response.](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/Step-Basic-Dark.png#only-dark)

Tweens follow the value of other state objects using a pre-made animation curve. This can be used for basic, predictable animations.

---

## Usage[¶](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/#usage "Permanent link")

To create a new tween object, call `scope:Tween()` and pass it a state object to move towards:

```
`local goal = scope:Value(0)
local animated = scope:Tween(goal)
`
```

The tween will smoothly follow the 'goal' state object over time.

As with other state objects, you can `peek()` at its value at any time:

```
`print(peek(animated)) --> 0.26425...
`
```

To configure how the tween moves, you can provide a TweenInfo to change the shape of the animation curve. It's optional, and it can be a state object if desired:

```
`local goal = scope:Value(0)
local style = TweenInfo.new(0.5, Enum.EasingStyle.Quad)
local animated = scope:Tween(goal, style)
`
```

You can use many different kinds of values with tweens, not just numbers. Vectors, CFrames, Color3s, UDim2s and other number-based types are supported; each number inside the type is animated individually.

```
`local goalPosition = scope:Value(UDim2.new(0.5, 0, 0, 0))
local animated = scope:Tween(goalPosition, TweenInfo.new(0.5, Enum.EasingStyle.Quad))
`
```

---

## Time[¶](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/#time "Permanent link")

The first parameter of `TweenInfo` is time. This specifies how long it should take for the value to animate to the goal, in seconds.

![Animation and graph showing varying TweenInfo time.](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/Time-Dark.png#only-dark)

---

## Easing Style[¶](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/#easing-style "Permanent link")

The second parameter of `TweenInfo` is easing style. By setting this to various `Enum.EasingStyle` values, you can select different pre-made animation curves.

![Animation and graph showing some easing styles.](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/Easing-Style-Dark.png#only-dark)

---

## Easing Direction[¶](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/#easing-direction "Permanent link")

The third parameter of `TweenInfo` is easing direction. This can be set to one of three values to control how the tween starts and stops:

- `Enum.EasingDirection.Out` makes the tween animate out smoothly.
- `Enum.EasingDirection.In` makes the tween animate in smoothly.
- `Enum.EasingDirection.InOut` makes the tween animate in *and* out smoothly.

![Animation and graph showing some easing directions.](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/Easing-Direction-Dark.png#only-dark)

---

## Repeats[¶](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/#repeats "Permanent link")

The fourth parameter of `TweenInfo` is repeat count. This can be used to loop the animation a number of times.

Setting the repeat count to a negative number causes it to loop infinitely. This is not generally useful for transition animations.

![Animation and graph showing various repeat counts.](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/Repeats-Dark.png#only-dark)

---

## Reversing[¶](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/#reversing "Permanent link")

The fifth parameter of `TweenInfo` is a reversing option. When enabled, the animation will include a reverse motion, before snapping to the goal at the end.

This is not typically useful.

![Animation and graph toggling reversing on and off.](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/Reversing-Dark.png#only-dark)

---

## Delay[¶](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/#delay "Permanent link")

The sixth and final parameter of `TweenInfo` is delay. Increasing this delay adds empty space before the beginning of the animation curve.

It's important to note this is *not* the same as a true delay. This option does not delay the input signal - it only makes the tween animation longer.

![Animation and graph showing varying delay values.](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/Delay-Dark.png#only-dark)

---

## Interruption[¶](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/#interruption "Permanent link")

Because tweens are built from pre-made, fixed animation curves, you should avoid interrupting those animation curves before they're finished.

Interrupting a tween halfway through leads to abrupt changes in velocity, which can cause your animation to feel janky:

![Animation and graph showing a tween getting interrupted.](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/Interrupted-Dark.png#only-dark)

Tweens also can't track constantly changing targets very well. That's because the tween is always getting interrupted as it gets started, so it never has time to play out much of its animation.

![Animation and graph showing a tween failing to follow a moving target.](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens/Follow-Failure-Dark.png#only-dark)

These issues arise because tweens don't 'remember' their previous velocity when they start animating towards a new goal. If you need velocity to be remembered, it's a much better idea to use springs, which can preserve their momentum.

# Springs

![Animation and graph showing basic spring response.](https://elttob.uk/Fusion/0.3/tutorials/animation/springs/Step-Basic-Dark.png#only-dark)

Springs follow the value of other state objects using a physical spring simulation. This can be used for 'springy' effects, or for smoothing out movement naturally without abrupt changes in direction.

---

## Usage[¶](https://elttob.uk/Fusion/0.3/tutorials/animation/springs/#usage "Permanent link")

To create a new spring object, call `scope:Spring()` and pass it a state object to move towards:

```
`local goal = scope:Value(0)
local animated = scope:Spring(goal)
`
```

The spring will smoothly follow the 'goal' state object over time.

As with other state objects, you can `peek()` at its value at any time:

```
`print(peek(animated)) --> 0.26425...
`
```

To configure how the spring moves, you can provide a speed and damping ratio to use. Both are optional, and both can be state objects if desired:

```
`local goal = scope:Value(0)
local speed = 25
local damping = scope:Value(0.5)
local animated = scope:Spring(goal, speed, damping)
`
```

You can also set the position and velocity of the spring at any time.

```
`animated:setPosition(5) -- teleport the spring to 5
animated:setVelocity(2) -- from here, move 2 units/second
`
```

You can use many different kinds of values with springs, not just numbers. Vectors, CFrames, Color3s, UDim2s and other number-based types are supported; each number inside the type is animated individually.

```
`local goalPosition = scope:Value(UDim2.new(0.5, 0, 0, 0))
local animated = scope:Spring(goalPosition, 25, 0.5)
`
```

---

## Damping Ratio[¶](https://elttob.uk/Fusion/0.3/tutorials/animation/springs/#damping-ratio "Permanent link")

The damping ratio (a.k.a damping) of the spring changes the friction in the physics simulation. Lower values allow the spring to move freely and oscillate up and down, while higher values restrict movement.

### Zero damping[¶](https://elttob.uk/Fusion/0.3/tutorials/animation/springs/#zero-damping "Permanent link")

![Animation and graph showing zero damping.](https://elttob.uk/Fusion/0.3/tutorials/animation/springs/Damping-Zero-Dark.png#only-dark)

Zero damping means no friction is applied, so the spring will oscillate forever without losing energy. This is generally not useful.

### Underdamping[¶](https://elttob.uk/Fusion/0.3/tutorials/animation/springs/#underdamping "Permanent link")

![Animation and graph showing underdamping.](https://elttob.uk/Fusion/0.3/tutorials/animation/springs/Damping-Under-Dark.png#only-dark)

A damping between 0 and 1 means some friction is applied. The spring will still oscillate, but it will lose energy and eventually settle at the goal.

### Critical damping[¶](https://elttob.uk/Fusion/0.3/tutorials/animation/springs/#critical-damping "Permanent link")

![Animation and graph showing critical damping.](https://elttob.uk/Fusion/0.3/tutorials/animation/springs/Damping-Critical-Dark.png#only-dark)

A damping of exactly 1 means just enough friction is applied to stop the spring from oscillating. It reaches its goal as quickly as possible without going past.

This is also commonly known as critical damping.

### Overdamping[¶](https://elttob.uk/Fusion/0.3/tutorials/animation/springs/#overdamping "Permanent link")

![Animation and graph showing overdamping.](https://elttob.uk/Fusion/0.3/tutorials/animation/springs/Damping-Over-Dark.png#only-dark)

A damping above 1 applies excessive friction to the spring. The spring behaves like it's moving through honey, glue or some other viscous fluid.

Overdamping reduces the effect of velocity changes, and makes movement more rigid.

---

## Speed[¶](https://elttob.uk/Fusion/0.3/tutorials/animation/springs/#speed "Permanent link")

The speed of the spring scales how much time it takes for the spring to move. Doubling the speed makes it move twice as fast; halving the speed makes it move twice as slow.

![Animation and graph showing speed changes.](https://elttob.uk/Fusion/0.3/tutorials/animation/springs/Speed-Dark.png#only-dark)

---

## Interruption[¶](https://elttob.uk/Fusion/0.3/tutorials/animation/springs/#interruption "Permanent link")

Springs do not share the same interruption problems as tweens. When the goal changes, springs are guaranteed to preserve both position and velocity, reducing jank:

![Animation and graph showing a spring getting interrupted.](https://elttob.uk/Fusion/0.3/tutorials/animation/springs/Interrupted-Dark.png#only-dark)

This also means springs are suitable for following rapidly changing values:

![Animation and graph showing a spring following a moving target.](https://elttob.uk/Fusion/0.3/tutorials/animation/springs/Following-Dark.png#only-dark)

# Hydration

Intent to replace

While the contents of this page still apply (and are useful for explaining other features), `Hydrate` itself will be replaced by other primitives in the near future. [See this issue on GitHub for further details.](https://github.com/dphfox/Fusion/issues/206)

The process of connecting your scripts to a pre-made UI template is known as *hydration*. This is where logic in your scripts translate into UI effects, for example setting a message inside a TextLabel, moving menus around, or showing and hiding buttons.

![A diagram showing hydration - an 'ammo' variable is sent from the script and placed inside various UI and game elements.](https://elttob.uk/Fusion/0.3/tutorials/roblox/hydration/Hydration-Basic-Dark.svg#only-dark)

Screenshot: GameUIDatabase (Halo Infinite)

Fusion provides a `Hydrate` function for hydrating an instance using a table of properties. If you pass in Fusion objects, changes will be applied immediately:

```
`local showUI = scope:Value(false)

local ui = scope:Hydrate(StarterGui.Template:Clone()) {
    Name = "MainGui",
    Enabled = showUI
}

print(ui.Name) --> MainGui
print(ui.Enabled) --> false

showUI:set(true)
task.wait() -- important: changes are applied on the next frame!
print(ui.Enabled) --> true
`
```

---

## Usage[¶](https://elttob.uk/Fusion/0.3/tutorials/roblox/hydration/#usage "Permanent link")

The `Hydrate` function is called in two parts. First, call the function with the instance you want to hydrate, then pass in the property table:

```
`local instance = workspace.Part

scope:Hydrate(instance)({
    Color = Color3.new(1, 0, 0)
})
`
```

If you're using curly braces `{}` to pass your properties in, the extra parentheses `()` are optional:

```
`local instance = workspace.Part

-- This only works when you're using curly braces {}!
scope:Hydrate(instance) {
    Color = Color3.new(1, 0, 0)
}
`
```

`Hydrate` returns the instance you give it, so you can use it in declarations:

```
`local instance = scope:Hydrate(workspace.Part) {
    Color = Color3.new(1, 0, 0)
}
`
```

If you pass in constant values for properties, they'll be applied to the instance directly. However, if you pass in a Fusion object (like `Value`), then changes will be applied immediately:

```
`local message = scope:Value("Loading...")

scope:Hydrate(PlayerGui.LoadingText) {
    Text = message
}

print(PlayerGui.Message.Text) --> Loading...

message:set("All done!")
task.wait() -- important: changes are applied on the next frame!
print(PlayerGui.Message.Text) --> All done!`
```

# New Instances

Fusion provides a `New` function when you're hydrating newly-made instances. It creates a new instance, applies some default properties, then hydrates it with a property table.

```
`local message = scope:Value("Hello there!")

local ui = scope:New "TextLabel" {
    Name = "Greeting",
    Parent = PlayerGui.ScreenGui,

    Text = message
}

print(ui.Name) --> Greeting
print(ui.Text) --> Hello there!

message:set("Goodbye friend!")
task.wait() -- important: changes are applied on the next frame!
print(ui.Text) --> Goodbye friend!
`
```

---

## Usage[¶](https://elttob.uk/Fusion/0.3/tutorials/roblox/new-instances/#usage "Permanent link")

The `New` function is called in two parts. First, call the function with the type of instance, then pass in the property table:

```
`local instance = scope:New("Part")({
    Parent = workspace,
    Color = Color3.new(1, 0, 0)
})
`
```

If you're using curly braces `{}` for your properties, and quotes `'' ""` for your class type, the extra parentheses `()` are optional:

```
`-- This only works when you're using curly braces {} and quotes '' ""!
local instance = scope:New "Part" {
    Parent = workspace,
    Color = Color3.new(1, 0, 0)
}
`
```

By design, `New` works just like `Hydrate` \- it will apply properties the same way. [See the Hydrate tutorial to learn more.](https://elttob.uk/Fusion/0.3/tutorials/roblox/hydration)

---

## Default Properties[¶](https://elttob.uk/Fusion/0.3/tutorials/roblox/new-instances/#default-properties "Permanent link")

When you create an instance using `Instance.new()`, Roblox will give it some default properties. However, these tend to be outdated and aren't useful for most people, leading to repetitive boilerplate needed to disable features that nobody wants to use.

The `New` function will apply some of it's own default properties to fix this. For example, by default borders on UI are disabled, automatic colouring is turned off and default content is removed.

![Showing the difference between a text label made with Instance.new and Fusion's New function.](https://elttob.uk/Fusion/0.3/tutorials/roblox/new-instances/Default-Props-Dark.svg#only-dark)

For a complete list, [take a look at Fusion's default properties file.](https://github.com/Elttob/Fusion/blob/main/src/Instances/defaultProps.luau)

# Parenting

The `[Children]` key allows you to add children when hydrating or creating an instance.

It accepts instances, arrays of children, and state objects containing children or `nil`.

```
`local folder = scope:New "Folder" {
    [Children] = {
        New "Part" {
            Name = "Gregory",
            Color = Color3.new(1, 0, 0)
        },
        New "Part" {
            Name = "Sammy",
            Material = "Glass"
        }
    }
}
`
```

---

## Usage[¶](https://elttob.uk/Fusion/0.3/tutorials/roblox/parenting/#usage "Permanent link")

`Children` doesn't need a scope - import it into your code from Fusion directly.

```
`local Children = Fusion.Children
`
```

When using `New` or `Hydrate`, you can use `[Children]` as a key in the property table. Any instance you pass in will be parented:

```
`local folder = scope:New "Folder" {
    -- The part will be moved inside of the folder
    [Children] = workspace.Part
}
`
```

Since `New` and `Hydrate` both return their instances, you can nest them:

```
`-- Makes a Folder, containing a part called Gregory
local folder = scope:New "Folder" {
    [Children] = scope:New "Part" {
        Name = "Gregory",
        Color = Color3.new(1, 0, 0)
    }
}
`
```

If you need to parent multiple children, arrays of children are accepted:

```
`-- Makes a Folder, containing parts called Gregory and Sammy
local folder = scope:New "Folder" {
    [Children] = {
        scope:New "Part" {
            Name = "Gregory",
            Color = Color3.new(1, 0, 0)
        },
        scope:New "Part" {
            Name = "Sammy",
            Material = "Glass"
        }
    }
}
`
```

Arrays can be nested to any depth; all children will still be parented:

```
`local folder = scope:New "Folder" {
    [Children] = {
        {
            {
                {
                    scope:New "Part" {
                        Name = "Gregory",
                        Color = Color3.new(1, 0, 0)
                    }
                }
            }
        }
    }
}
`
```

State objects containing children or `nil` are also allowed:

```
`local value = scope:Value()

local folder = scope:New "Folder" {
    [Children] = value
}

value:set(
    scope:New "Part" {
        Name = "Clyde",
        Transparency = 0.5
    }
)
`
```

You may use any combination of these to parent whichever children you need:

```
`local modelChildren = workspace.Model:GetChildren()
local includeModel = scope:Value(true)

local folder = scope:New "Folder" {
    -- array of children
    [Children] = {
        -- single instance
        scope:New "Part" {
            Name = "Gregory",
            Color = Color3.new(1, 0, 0)
        },
        -- state object containing children (or nil)
        scope:Computed(function(use)
            return if use(includeModel)
                then modelChildren:GetChildren() -- array of children
                else nil
        end)
    }
}
`
```

Tip

If you're using strictly typed Luau, you might incorrectly see type errors when mixing different kinds of value in arrays. This commonly causes problems when listing out children.

If you're seeing type errors, try importing the [`Child` function](https://elttob.uk/Fusion/0.3/api-reference/roblox/members/child) and using it when listing out children:

```
`local Child = Fusion.Child
-- ... later ...

local folder = scope:New "Folder" {
    [Children] = Child {
        scope:New "Part" {
            Name = "Gregory",
            Color = Color3.new(1, 0, 0)
        },
        scope:Computed(function(use)
            return if use(includeModel)
                then modelChildren:GetChildren() -- array of children
                else nil
        end)
    }
}
`
```

The `Child` function doesn't do any processing, but instead encourages the Luau type system to infer a more useful type and avoid the problem.

# Events

`OnEvent` is a function that returns keys to use when hydrating or creating an instance. Those keys let you connect functions to events on the instance.

```
`local button = scope:New "TextButton" {
    [OnEvent "Activated"] = function(_, numClicks)
        print("The button was pressed", numClicks, "time(s)!")
    end
}
`
```

---

## Usage[¶](https://elttob.uk/Fusion/0.3/tutorials/roblox/events/#usage "Permanent link")

`OnEvent` doesn't need a scope - import it into your code from Fusion directly.

```
`local OnEvent = Fusion.OnEvent
`
```

When you call `OnEvent` with an event name, it will return a special key:

```
`local key = OnEvent("Activated")
`
```

When that key is used in a property table, you can pass in a handler and it will be connected to the event for you:

```
`local button = scope:New "TextButton" {
    [OnEvent("Activated")] = function(_, numClicks)
        print("The button was pressed", numClicks, "time(s)!")
    end
}
`
```

If you're using quotes `'' ""` for the event name, the extra parentheses `()` are optional:

```
`local button = scope:New "TextButton" {
    [OnEvent "Activated"] = function(_, numClicks)
        print("The button was pressed", numClicks, "time(s)!")
    end
}`
```

# Change Events

`OnChange` is a function that returns keys to use when hydrating or creating an instance. Those keys let you connect functions to property changed events on the instance.

```
`local input = scope:New "TextBox" {
    [OnChange "Text"] = function(newText)
        print("You typed:", newText)
    end
}
`
```

---

## Usage[¶](https://elttob.uk/Fusion/0.3/tutorials/roblox/change-events/#usage "Permanent link")

`OnChange` doesn't need a scope - import it into your code from Fusion directly.

```
`local OnChange = Fusion.OnChange
`
```

When you call `OnChange` with a property name, it will return a special key:

```
`local key = OnChange("Text")
`
```

When used in a property table, you can pass in a handler and it will be run when that property changes.

Arguments are different to Roblox API

Normally in the Roblox API, when using `:GetPropertyChangedSignal()` on an instance, the callback will not receive any arguments.

To make working with change events easier, `OnChange` will pass the new value of the property to the callback.

```
`local input = scope:New "TextBox" {
    [OnChange("Text")] = function(newText)
        print("You typed:", newText)
    end
}
`
```

If you're using quotes `'' ""` for the event name, the extra parentheses `()` are optional:

```
`local input = scope:New "TextBox" {
    [OnChange "Text"] = function(newText)
        print("You typed:", newText)
    end
}`
```

# Outputs

`Out` is a function that returns keys to use when hydrating or creating an instance. Those keys let you output a property's value to a `Value` object.

```
`local name = scope:Value()

local thing = scope:New "Part" {
    [Out "Name"] = name
}

print(peek(name)) --> Part

thing.Name = "Jimmy"
print(peek(name)) --> Jimmy
`
```

---

## Usage[¶](https://elttob.uk/Fusion/0.3/tutorials/roblox/outputs/#usage "Permanent link")

`Out` doesn't need a scope - import it into your code from Fusion directly.

```
`local Out = Fusion.Out
`
```

When you call `Out` with a property name, it will return a special key:

```
`local key = Out("Activated")
`
```

When used in a property table, you can pass in a `Value` object. It will be set to the value of the property, and when the property changes, it will be set to the new value:

```
`local name = scope:Value()

local thing = scope:New "Part" {
    [Out("Name")] = name
}

print(peek(name)) --> Part

thing.Name = "Jimmy"
print(peek(name)) --> Jimmy
`
```

If you're using quotes `'' ""` for the event name, the extra parentheses `()` are optional:

```
`local thing = scope:New "Part" {
    [Out "Name"] = name
}
`
```

---

## Two-Way Binding[¶](https://elttob.uk/Fusion/0.3/tutorials/roblox/outputs/#two-way-binding "Permanent link")

By default, `Out` only *outputs* changes to the property. If you set the value to something else, the property remains the same:

```
`local name = scope:Value()

local thing = scope:New "Part" {
    [Out "Name"] = name -- When `thing.Name` changes, set `name`
}

print(thing.Name, peek(name)) --> Part Part
name:set("NewName")
task.wait()
print(thing.Name, peek(name)) --> Part NewName
`
```

If you want the value to both *change* and *be changed* by the property, you need to explicitly say so:

```
`local name = scope:Value()

local thing = scope:New "Part" {
    Name = name -- When `name` changes, set `thing.Name`
    [Out "Name"] = name -- When `thing.Name` changes, set `name`
}

print(thing.Name, peek(name)) --> Part Part
name:set("NewName")
task.wait()
print(thing.Name, peek(name)) --> NewName NewName
`
```

This is known as two-way binding. Most of the time you won't need it, but it can come in handy when working with some kinds of UI - for example, a text box that users can write into, but which can also be modified by your scripts.

# Components

You can use functions to create self-contained, reusable blocks of code. In the world of UI, you may think of them as *components* \- though they can be used for much more than just UI.

For example, consider this function, which generates a button based on some `props` the user passes in:

```
`type UsedAs<T> = Fusion.UsedAs<T>

local function Button(
    scope: Fusion.Scope,
    props: {
        Position: UsedAs<UDim2>?,
        AnchorPoint: UsedAs<Vector2>?,
        Size: UsedAs<UDim2>?,
        LayoutOrder: UsedAs<number>?,
        ButtonText: UsedAs<string>
    }
)
    return scope:New "TextButton" {
        BackgroundColor3 = Color3.new(0, 0.25, 1),
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,
        Size = props.Size,
        LayoutOrder = props.LayoutOrder,

        Text = props.ButtonText,
        TextSize = 28,
        TextColor3 = Color3.new(1, 1, 1),

        [Children] = UICorner { CornerRadius = UDim2.new(0, 8) }
    }
end
`
```

You can call this function later to generate as many buttons as you need.

```
`local helloBtn = Button(scope, {
    ButtonText = "Hello",
    Size = UDim2.fromOffset(200, 50)
})

helloBtn.Parent = Players.LocalPlayer.PlayerGui.ScreenGui
`
```

Since the `scope` is the first parameter, it can even be used with `scoped()` syntax.

```
`local scope = scoped(Fusion, {
    Button = Button
})

local helloBtn = scope:Button {
    ButtonText = "Hello",
    Size = UDim2.fromOffset(200, 50)
}

helloBtn.Parent = Players.LocalPlayer.PlayerGui.ScreenGui
`
```

This is the primary way of writing components in Fusion. You create functions that accept `scope` and `props`, then return some content from them.

---

## Properties[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/components/#properties "Permanent link")

If you don't say what `props` should contain, it might be hard to figure out how to use it.

You can specify your list of properties by adding a type to `props`, which gives you useful autocomplete and type checking.

```
`local function Cake(
    -- ... some stuff here ...
    props: {
        Size: Vector3,
        Colour: Color3,
        IsTasty: boolean
    }
)
    -- ... some other stuff here ...
end
`
```

Note that the above code only accepts constant values, not state objects. If you want to accept *either* a constant or a state object, you can use the `UsedAs` type.

```
`type UsedAs<T> = Fusion.UsedAs<T>

local function Cake(
    -- ... some stuff here ...
    props: {
        Size: UsedAs<Vector3>,
        Colour: UsedAs<Color3>,
        IsTasty: UsedAs<boolean>
    }
)
    -- ... some other stuff here ...
end
`
```

This is usually what you want, because it means the user can easily switch a property to dynamically change over time, while still writing properties normally when they don't change over time. You can mostly treat `UsedAs` properties like they're state objects, because functions like `peek()` and `use()` automatically choose the right behaviour for you.

You can use the rest of Luau's type checking features to do more complex things, like making certain properties optional, or restricting that values are valid for a given property. Go wild!

Be mindful of the angle brackets

Remember that, when working with `UsedAs`, you should be mindful of whether you're putting things inside the angled brackets, or outside of them. Putting some things inside of the angle brackets can change their meaning, compared to putting them outside of the angle brackets.

Consider these two type definitions carefully:

```
`-- A Vector3, or a state object storing Vector3, or nil.
UsedAs<Vector3>?

-- A Vector3?, or a state object storing Vector3?
UsedAs<Vector3?>
`
```

The first type is best for *optional properties*, where you provide a default value if it isn't specified by the user. If the user *does* specify it, they're forced to always give a valid value for it.

The second type is best if the property understands `nil` as a valid value. This means the user can set it to `nil` at any time.

---

## Scopes[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/components/#scopes "Permanent link")

In addition to `props`, you should also ask for a `scope`. The `scope` parameter should come first, so that your users can use `scoped()` syntax to create it.

```
`-- barebones syntax
local thing = Component(scope, {
    -- ... some properties here ...
})

-- scoped() syntax
local thing = scope:Component {
    -- ... some properties here ...
}
`
```

It's a good idea to provide a type for `scope`. This lets you specify what methods you need the scope to have.

```
`scope: Fusion.Scope<YourMethodsHere>
`
```

If you don't know what methods to ask for, consider these two strategies.

1.  If you use common methods (like Fusion's constructors) then it's a safe assumption that the user will also have those methods. You can ask for a scope with those methods pre-defined.

    ```
    `local function Component(
        scope: Fusion.Scope,
        props: {}
    )
        return scope:New "Thing" {
            -- ... rest of code here ...
        }
    end
    `
    ```

2.  If you need more specific or niche things that the user likely won't have (for example, components you use internally), then you should not ask for those. Instead, create a new inner scope with the methods you need.

    ```
    `local function Component(
        scope: Fusion.Scope,
        props: {}
    )
        local scope = scope:innerScope {
            SpecialThing1 = require(script.SpecialThing1),
            SpecialThing2 = require(script.SpecialThing2),
        }
        return scope:SpecialThing1 {
            -- ... rest of code here ...
        }
    end
    `
    ```

If you're not sure which strategy to pick, the second is always a safe fallback, because it assumes less about your users and helps hide implementation details.

---

## Modules[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/components/#modules "Permanent link")

It's common to save different components inside of different files. There's a number of advantages to this:

- it's easier to find the source code for a specific component
- it keep each file shorter and simpler
- it makes sure components are properly independent, and can't interfere
- it encourages reusing components everywhere, not just in one file

Here's an example of how you could split up some components into modules:

Main filePopUpMessageButton

| `local Fusion = require(game:GetService("ReplicatedStorage").Fusion)local scoped, doCleanup = Fusion.scoped, Fusion.doCleanuplocal scope = scoped(Fusion, {    PopUp = require(script.Parent.PopUp)})local ui = scope:New "ScreenGui" {    -- ...some properties...    [Children] = scope:PopUp {        Message = "Hello, world!",        DismissText = "Close"    }}` |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

local Fusion = require(game:GetService("ReplicatedStorage").Fusion)
type UsedAs<T> = Fusion.UsedAs<T>

local function PopUp(
scope: Fusion.Scope,
props: {
Message: UsedAs<string>,
DismissText: UsedAs<string>
}
)
local scope = scope:innerScope {
Message = require(script.Parent.Message),
Button = require(script.Parent.Button)
}

    return scope:New "Frame" {
        -- ...some properties...

        [Children] = {
            scope:Message {
                Text = props.Message
            }
            scope:Button {
                Text = props.DismissText
            }
        }
    }

end

return PopUp

local Fusion = require(game:GetService("ReplicatedStorage").Fusion)
type UsedAs<T> = Fusion.UsedAs<T>

local function Message(
scope: Fusion.Scope,
props: {
Text: UsedAs<string>
}
)
return scope:New "TextLabel" {
AutomaticSize = "XY",
BackgroundTransparency = 1,

         -- ...some properties...

        Text = props.Text
    }

end

return Message

local Fusion = require(game:GetService("ReplicatedStorage").Fusion)
type UsedAs<T> = Fusion.UsedAs<T>

local function Button(
scope: Fusion.Scope,
props: {
Text: UsedAs<string>
}
)
return scope:New "TextButton" {
BackgroundColor3 = Color3.new(0.25, 0.5, 1),
AutoButtonColor = true,

         -- ...some properties...

        Text = props.Text
    }

end

return Button

# Instance Handling

Components are a good fit for Roblox instances. You can assemble complex groups of instances by combining simpler, self-contained parts.

To ensure maximum compatibility, there are a few best practices to consider.

---

## Returns[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/instance-handling/#returns "Permanent link")

Anything you return from a component should be supported by [`[Children]`](https://elttob.uk/Fusion/0.3/tutorials/roblox/parenting/).

```
`-- returns an instance
return scope:New "Frame" {}

-- returns an array of instances
return {
    scope:New "Frame" {},
    scope:New "Frame" {},
    scope:New "Frame" {}
}

-- returns a state object containing instances
return scope:ForValues({1, 2, 3}, function(use, scope, number)
    return scope:New "Frame" {}
end)

-- mix of arrays, instances and state objects
return {
    scope:New "Frame" {},
    {
        scope:New "Frame" {},
        scope:ForValues( ... )
    }
    scope:ForValues( ... )
}
`
```

Returning multiple values is fragile

Don't return multiple values directly from your function. When a function returns multiple values directly, the extra returned values can easily get lost.

```
`local function BadThing(scope, props)
    -- returns *multiple* instances (not surrounded by curly braces!)
    return
        scope:New "Frame" {},
        scope:New "Frame" {},
        scope:New "Frame" {}
end

local things = {
    -- Luau doesn't let you add multiple returns to a list like this.
    -- Only the first Frame will be added.
    scope:BadThing {},
    scope:New "TextButton" {}
}
print(things) --> { Frame, TextButton }
`
```

Instead, you should return them inside of an array. Because the array is a single return value, it won't get lost.

If your returns are compatible with `[Children]` like above, you can insert a component anywhere you'd normally insert an instance.

You can pass in one component on its own...

```
`local ui = scope:New "ScreenGui" {
    [Children] = scope:Button {
        Text = "Hello, world!"
    }
}
`
```

...you can include components as part of an array..

```
`local ui = scope:New "ScreenGui" {
    [Children] = {
        scope:New "UIListLayout" {},

        scope:Button {
            Text = "Hello, world!"
        },
        scope:Button {
            Text = "Hello, again!"
        }
    }
}
`
```

...and you can return them from state objects, too.

```
`local stuff = {"Hello", "world", "from", "Fusion"}

local ui = scope:New "ScreenGui" {
    [Children] = {
        scope:New "UIListLayout" {},

        scope:ForValues(stuff, function(use, scope, text)
            return scope:Button {
                Text = text
            }
        end)
    }
}
`
```

---

## Containers[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/instance-handling/#containers "Permanent link")

Some components, for example pop-ups, might contain lots of different content:

![Examples of pop-ups with different content.](https://elttob.uk/Fusion/0.3/tutorials/best-practices/instance-handling/Popups-Dark.svg#only-dark)

Ideally, you would be able to reuse the pop-up 'container', while placing your own content inside.

![Separating the pop-up container from the pop-up contents.](https://elttob.uk/Fusion/0.3/tutorials/best-practices/instance-handling/Popup-Exploded-Dark.svg#only-dark)

The simplest way to do this is to pass instances through to `[Children]`. For example, if you accept a table of `props`, you can add a `[Children]` key:

```
`local function PopUp(
    scope: Fusion.Scope,
    props: {
        [typeof(Children)]: Fusion.Children
    }
)
    return scope:New "Frame" {
        [Children] = props[Children]
    }
end
`
```

Accepting multiple instances

If you have multiple 'slots' where you want to pass through instances, you can make other properties and give them the `Fusion.Children` type.

Later on, when a pop-up is created, instances can now be parented into that pop-up:

```
`scope:PopUp {
    [Children] = {
        scope:Label {
            Text = "New item collected"
        },
        scope:ItemPreview {
            Item = Items.BRICK
        },
        scope:Button {
            Text = "Add to inventory"
        }
    }
}
`
```

If you need to add other instances, you can still use arrays and state objects as normal. You can include instances you're given, in exactly the same way you would include any other instances.

```
`scope:New "Frame" {
    -- ... some other properties ...

    [Children] = {
        -- the component provides some children here
        scope:New "UICorner" {
            CornerRadius = UDim.new(0, 8)
        },

        -- include children from outside the component here
        props[Children]
    }
}`
```

# References

At some point, you might need to refer to another part of the UI. There are various techniques that can let you do this.

```
`local ui = scope:New "Folder" {
    [Children] = {
        scope:New "SelectionBox" {
            -- the box should adorn to the part, but how do you reference it?
            Adornee = ???,
        },
        scope:New "Part" {
            Name = "Selection Target",
        }
    }
}
`
```

---

## Constants[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/references/#constants "Permanent link")

The first technique is simple - instead of creating the UI all at once, you can extract part of the UI that you want to reference later.

In practice, that means you'll move some of the creation code into a new `local` constant, so that you can refer to it later by name.

```
`-- the part is now constructed first, whereas before it was constructed second
local selectionTarget = scope:New "Part" {
    Name = "Selection Target",
}

local ui = scope:New "Folder" {
    [Children] = {
        scope:New "SelectionBox" {
            Adornee = selectionTarget
        },
        selectionTarget
    }
}
`
```

While this is a simple and robust technique, it has some disadvantages:

- By moving parts of your UI code into different local variables, your UI will be constructed in a different order based on which local variables come first
- Refactoring code in this way can be bothersome and inelegant, disrupting the structure of the code
- You can't have two pieces of UI refer to each other cyclically

Constants work well for trivial examples, but you should consider a more flexible technique if those disadvantages are relevant.

---

## Value Objects[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/references/#value-objects "Permanent link")

Where it's impossible or inelegant to use named constants, you can use [value objects](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/values) to easily set up references.

Because their `:set()` method returns the value that's passed in, you can use `:set()` to reference part of your code without disrupting its structure:

```
`-- `selectionTarget` will show as `nil` to all code trying to use it, until the
-- `:set()` method is called later on.
local selectionTarget: Fusion.Value<Part?> = scope:Value(nil)

local ui = scope:New "Folder" {
    [Children] = {
        scope:New "SelectionBox" {
            Adornee = selectionTarget
        },
        selectionTarget:set(
            scope:New "Part" {
                Name = "Selection Target",
            }
        )
    }
}
`
```

It's important to note that the value object will briefly be `nil` (or whichever default value you provide in the constructor). This is because it takes time to reach the `:set()` call, so any in-between code will see the `nil`.

In the above example, the `Adornee` is briefly set to `nil`, but because `selectionTarget` is a value object, it will change to the part instance when the `:set()` method is called.

While dealing with the brief `nil` value can be annoying, it is also useful, because this lets you refer to parts of your UI that haven't yet been created. In particular, this lets you create cyclic references.

```
`local aliceRef: Fusion.Value<Instance?> = scope:Value(nil)
local bobRef: Fusion.Value<Instance?> = scope:Value(nil)

-- These two `ObjectValue` instances will refer to each other once the code has
-- finished running.
local alice = aliceRef:set(
    scope:New "ObjectValue" {
        Value = bobRef
    }
)
local bob = bobRef:set(
    scope:New "ObjectValue" {
        Value = aliceRef
    }
)
`
```

Value objects are generally easier to work with than named constants, so they're often used as the primary way of referencing UI, but feel free to mix both techniques based on what your code needs.

# Callbacks

Normally, components are controlled by the code creating them. This is called top-down control, and is the primary flow of control in Fusion.

![Diagram of top-down control in an inventory UI.](https://elttob.uk/Fusion/0.3/tutorials/best-practices/callbacks/Top-Down-Control-Dark.svg#only-dark)

However, sometimes components need to talk back to their controlling code, for example to report when button clicks occur.

---

## In Luau[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/callbacks/#in-luau "Permanent link")

Callbacks are functions which you pass into other functions. They're useful because they allow the function to 'call back' into your code, so your code can do something in response:

```
`local function printMessage()
    print("Hello, world!")
end

-- Here, we're passing `printMessage` as a callback
-- `task.delay` will call it after 5 seconds
task.delay(5, printMessage)
`
```

If your function accepts a callback, then you can call it like any other function. Luau will execute the function, then return to your code.

In this example, the `fiveTimes` function calls a callback five times:

Luau codeOutput

```
`local function fiveTimes(
    callback: (number) -> ()
)
    for x=1, 5 do
        callback(x)
    end
end

fiveTimes(function(num)
    print("The number is", num)
end)
`
```

---

## In Fusion[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/callbacks/#in-fusion "Permanent link")

Components can use callbacks the same way. Consider this button component; when the button is clicked, the button needs to run some external code:

```
`local function Button(
    scope: Fusion.Scope,
    props: {
        Position: UsedAs<UDim2>?,
        Size: UsedAs<UDim2>?,
        Text: UsedAs<string>?
    }
)
    return scope:New "TextButton" {
        BackgroundColor3 = Color3.new(0.25, 0.5, 1),
        Position = props.Position,
        Size = props.Size,

        Text = props.Text,
        TextColor3 = Color3.new(1, 1, 1),

        [OnEvent "Activated"] = -- ???
    }
end
`
```

It can ask the controlling code to provide an `OnClick` callback in `props`.

```
`local button = scope:Button {
    Text = "Hello, world!",
    OnClick = function()
        print("The button was clicked")
    end
}
`
```

Assuming that callback is passed in, the callback can be passed directly into `[OnEvent]`, because `[OnEvent]` accepts functions. It can even be optional - Luau won't add the key to the table if the value is `nil`.

```
`local function Button(
    scope: Fusion.Scope,
    props: {
        Position: UsedAs<UDim2>?,
        Size: UsedAs<UDim2>?,
        Text: UsedAs<string>?,
        OnClick: (() -> ())?
    }
)
    return scope:New "TextButton" {
        BackgroundColor3 = Color3.new(0.25, 0.5, 1),
        Position = props.Position,
        Size = props.Size,

        Text = props.Text,
        TextColor3 = Color3.new(1, 1, 1),

        [OnEvent "Activated"] = props.OnClick
    }
end
`
```

Alternatively, we can call `props.OnClick` manually, which is useful if you want to do your own processing first:

```
`local function Button(
    scope: Fusion.Scope,
    props: {
        Position: UsedAs<UDim2>?,
        Size: UsedAs<UDim2>?,
        Text: UsedAs<string>?,
        Disabled: UsedAs<boolean>?,
        OnClick: (() -> ())?
    }
)
    return scope:New "TextButton" {
        BackgroundColor3 = Color3.new(0.25, 0.5, 1),
        Position = props.Position,
        Size = props.Size,

        Text = props.Text,
        TextColor3 = Color3.new(1, 1, 1),

        [OnEvent "Activated"] = function()
            if props.OnClick ~= nil and not peek(props.Disabled) then
                props.OnClick()
            end
        end
    }
end
`
```

This is the primary way components talk to their controlling code in Fusion.

---

## Children Callbacks[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/callbacks/#children-callbacks "Permanent link")

There's a special kind of callback that's often used when you need more control over the children you're putting inside of a component.

When your component asks for `[Children]`, the controlling code will construct some children for you ahead of time, and pass it into that `[Children]` key. You don't have any control over what that process looks like.

```
`-- This snippet...
local dialog = scope:Dialog {
    [Children] = {
        scope:Button {
            Text = "Hello, world!"
        },
        scope:Text {
            Text = "I am pre-fabricated!"
        }
    }
}

-- ...is equivalent to this code.
local children = {
    scope:Button {
        Text = "Hello, world!"
    },
    scope:Text {
        Text = "I am pre-fabricated!"
    }
}

local dialog = scope:Dialog {
    [Children] = children
}
`
```

However, if your component asks for a callback instead, you can create those children on demand, as many times as you'd like, with whatever parameters you want to pass in.

This callback should be given a descriptive name like `Build`, `Render`, or whatever terminology fits your code base. Try and be consistent across all of your components.

```
`local dialog = scope:Dialog {
    -- Use a `scope` parameter here so that the component can change when these
    -- children are destroyed if it needs to. This is especially important for
    -- components that create multiple sets of children over time.
    Build = function(scope)
        return {
            scope:Button {
                Text = "Hello, world!"
            },
            scope:Text {
                Text = "I am created on the fly!"
            }
        }
    end
}
`
```

Warning

Don't use `[Children]` to store a function. In general, avoid using special keys unless you're actually passing the values through, because changing how a special key appears to behave can make code confusing to follow.

In this case, using a dedicated naming convention like `Build` ensures that users understand that their children are not being created ahead of time.

Children callbacks are especially useful if the controlling code needs more information to build the rest of the UI. For example, you might want to share some layout information so children can fit into the component more neatly.

```
`local dialog = scope:Dialog {
    Build = function(scope, textSize)
        return {
            scope:Button {
                Text = "Hello, world!",
                TextSize = textSize
            },
            scope:Text {
                Text = "I am created on the fly!",
                TextSize = textSize
            }
        }
    end
}
`
```

This is also useful for [sharing values to all children](https://elttob.uk/Fusion/0.3/tutorials/best-practices/sharing-values), which will be covered on a later page.

# State

Components can hold their own data privately using state objects. This can be useful, but you should be careful when adding state.

---

## Creation[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/state/#creation "Permanent link")

You can create state objects inside components as you would anywhere else.

```
`local HOVER_COLOUR = Color3.new(0.5, 0.75, 1)
local REST_COLOUR = Color3.new(0.25, 0.5, 1)

local function Button(
    scope: Fusion.Scope,
    props: {
        -- ... some properties ...
    }
)
    local isHovering = scope:Value(false)
    return scope:New "TextButton" {
        BackgroundColor3 = scope:Computed(function(use)
            return if use(isHovering) then HOVER_COLOUR else REST_COLOUR
        end),
        -- ... ... some more code ...
    }
end
`
```

Because these state objects are made with the same `scope` as the rest of the component, they're destroyed alongside the rest of the component.

---

## Top-Down Control[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/state/#top-down-control "Permanent link")

Remember that Fusion mainly works with a top-down flow of control. It's a good idea to keep that in mind when adding state to components.

When you're making reusable components, it's more flexible if your component can be controlled externally. Components that control themselves entirely are hard to use and customise.

Consider the example of a check box. Each check box often reflects a state object under the hood:

![Showing check boxes connected to Value objects.](https://elttob.uk/Fusion/0.3/tutorials/best-practices/state/Check-Boxes-Dark.svg#only-dark)

It might *seem* logical to store the state object inside the check box, but this causes a few problems:

- because the state is hidden, it's awkward to read and write from outside
- often, the user already has a state object representing the same setting, so now there's two state objects where one would have sufficed

```
`local function CheckBox(
    scope: Fusion.Scope,
    props: {
        -- ... some properties ...
    }
)
    local isChecked = scope:Value(false) -- problematic
    return scope:New "ImageButton" {
        [OnEvent "Activated"] = function()
            isChecked:set(not peek(isChecked))
        end,

        -- ... some more code ...
    }
end
`
```

A *slightly better* solution is to pass the state object in. This ensures the controlling code has easy access to the state if it needs it. However, this is not a complete solution:

- the user is forced to store the state in a `Value` object, but they might be computing the value dynamically with other state objects instead
- the behaviour of clicking the check box is hardcoded; the user cannot intercept the click or toggle a different state

```
`local function CheckBox(
    scope: Fusion.Scope,
    props: {
        IsChecked: Fusion.Value<boolean> -- slightly better
    }
)
    return scope:New "ImageButton" {
        [OnEvent "Activated"] = function()
            props.IsChecked:set(not peek(props.IsChecked))
        end,

        -- ... some more code ...
    }
end
`
```

That's why the *best* solution is to use `UsedAs` to create read-only properties, and add callbacks for signalling actions and events.

- because `UsedAs` is read-only, it lets the user plug in any data source, including dynamic computations
- because the callback is provided by the user, the behaviour of clicking the check box is completely customisable

```
`local function CheckBox(
    scope: Fusion.Scope,
    props: {
        IsChecked: UsedAs<boolean>, -- best
        OnClick: () -> ()
    }
)
    return scope:New "ImageButton" {
        [OnEvent "Activated"] = function()
            props.OnClick()
        end,

        -- ... some more code ...
    }
end
`
```

The control is always top-down here; the check box's appearance is fully controlled by the creator. The creator of the check box *decides* to switch the setting when the check box is clicked.

### In Practice[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/state/#in-practice "Permanent link")

Setting up your components in this way makes extending their behaviour incredibly straightforward.

Consider a scenario where you wish to group multiple options under a 'main' check box, so you can turn them all on/off at once.

![Showing check boxes connected to Value objects.](https://elttob.uk/Fusion/0.3/tutorials/best-practices/state/Master-Check-Box-Dark.svg#only-dark)

The appearance of that check box would not be controlled by a single state, but instead reflects the combination of multiple states. Because the code uses `UsedAs`, you can represent this with a `Computed` object.

```
`local playMusic = scope:Value(true)
local playSFX = scope:Value(false)
local playNarration = scope:Value(true)

local checkBox = scope:CheckBox {
    Text = "Play sounds",
    IsChecked = scope:Computed(function(use)
        local anyChecked = use(playMusic) or use(playSFX) or use(playNarration)
        local allChecked = use(playMusic) and use(playSFX) and use(playNarration)
        if not anyChecked then
            return "unchecked"
        elseif not allChecked then
            return "partially-checked"
        else
            return "checked"
        end
    end)
}
`
```

You can then implement the 'check all'/'uncheck all' behaviour inside `OnClick`:

```
`local playMusic = scope:Value(true)
local playSFX = scope:Value(false)
local playNarration = scope:Value(true)

local checkBox = scope:CheckBox {
    -- ... same properties as before ...
    OnClick = function()
        local allChecked = peek(playMusic) and peek(playSFX) and peek(playNarration)
        playMusic:set(not allChecked)
        playSFX:set(not allChecked)
        playNarration:set(not allChecked)
    end
}
`
```

Because the check box was written to be flexible, it can handle complex usage easily.

---

## Best Practices[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/state/#best-practices "Permanent link")

Those examples lead us to the golden rule of reusable components:

Golden Rule

Reusable components should *reflect* program state. They should not *control* program state.

At the bottom of the chain of control, components shouldn't be massively responsible. At these levels, reflective components are easier to work with.

As you go up the chain of control, components get broader in scope and less reusable; those places are often suitable for controlling components.

A well-balanced codebase places controlling components at key, strategic locations. They allow higher-up components to operate without special knowledge about what goes on below.

At first, this might be difficult to do well, but with experience you'll have a better intuition for it. Remember that you can always rewrite your code if it becomes a problem!

# Sharing Values

Sometimes values are used in far-away parts of the codebase. For example, many UI elements might share theme colours for light and dark theme.

---

## Globals[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/sharing-values/#globals "Permanent link")

Typically, values are shared by placing them in modules. These modules can be required from anywhere in the codebase, and their values can be imported into any code.

Values shared in this way are known as *globals*.

Theme.luauSomewhere else

| `local Theme = {}Theme.colours = {    background = Color3.fromHex("FFFFFF"),    text = Color3.fromHex("222222"),    -- etc.}return Theme` |
| ----------------------------------------------------------------------------------------------------------------------------------------- |

In particular, you can share state objects this way, and every part of the codebase will be able to see and interact with those state objects.

Theme.luauSomewhere else

| `local Fusion = require("path/to/Fusion.luau")local Theme = {}Theme.colours = {    background = {        light = Color3.fromHex("FFFFFF"),        dark = Color3.fromHex("222222")    },    text = {        light = Color3.fromHex("FFFFFF"),        dark = Color3.fromHex("222222")    },    -- etc.}function Theme.init(    scope: Fusion.Scope)    Theme.currentTheme = scope:Value("light")endreturn Theme` |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

Globals are very straightforward to implement and can be useful, but they can quickly cause problems if not used carefully.

### Hidden dependencies[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/sharing-values/#hidden-dependencies "Permanent link")

When you use a global inside a block of reusable code such as a component, you are making your code dependent on another code file without declaring it to the outside world.

To some extent, this is entirely why using globals is desirable. While it's more 'correct' to accept the `Theme` via the parameters of your function, it often means the `Theme` has to be passed down through multiple layers of functions. This is known as [prop drilling](https://kentcdodds.com/blog/prop-drilling) and is widely considered bad practice, because it clutters up unrelated code with parameters that are only passed through functions.

To avoid prop drilling, globals are often used, which 'hides' the dependency on that external code file. You no longer have to pass it down through parameters. However, relying too heavily on these hidden dependencies can cause your code to behave in surprising, unintuitive ways, or it can obscure what functionality is available to developers using your code.

### Hard-to-locate writes[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/sharing-values/#hard-to-locate-writes "Permanent link")

If you write into globals from deep inside your code base, it becomes very hard to figure out where the global is being changed from, which significantly hurts debugging.

Generally, it's best to treat globals as *read-only*. If you're writing to a global, it should be coming from a single well-signposted, easy-to-find place.

You should also keep the principles of [top-down control](https://elttob.uk/Fusion/0.3/tutorials/best-practices/callbacks) in mind; think of globals as 'flowing down' from the root of the program. Globals are best managed from high up in the program, because they have widespread effects, so consider using callbacks to pass control up the chain, rather than managing globals directly from every part of the code base.

### Memory management[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/sharing-values/#memory-management "Permanent link")

In addition, globals can complicate memory management. Because every part of your code base can access them, you can't destroy globals until the very end of your program.

In the above example, this is solved with an `init()` method which passes the main scope to `Theme`. Because `init()` is called before anything else that uses `Theme`, the objects that `Theme` creates will be added to the scope first.

When the main scope is cleaned up, `doCleanup()` will destroy things in reverse order. This means the `Theme` objects will be cleaned up last, after everything else in the program has been cleaned up.

This only works if you know that the main script is the only entry point in your program. If you have two scripts running concurrently which try to `init()` the `Theme` module, they will overwrite each other.

### Non-replaceable for testing[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/sharing-values/#non-replaceable-for-testing "Permanent link")

When your code uses a global, you're hard-coding a connection between your code and that specific global.

This is problematic for testing; unless you're using an advanced testing framework with code injection, it's pretty much impossible to separate your code from that global code, which makes it impossible to replace global values for testing purposes.

For example, if you wanted to write automated tests that verify light theme and dark theme are correctly applied throughout your UI, you can't replace any values stored in `Theme`.

You might be able to write to the `Theme` by going through the normal process, but this fundamentally limits how you can test. For example, you couldn't run a test for light theme and dark theme at the same time.

---

## Contextuals[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/sharing-values/#contextuals "Permanent link")

The main drawback of globals is that they hold one value for all code. To solve this, Fusion introduces *contextual values*, which can be temporarily changed for the duration of a code block.

To create a contextual, call the `Contextual` function from Fusion. It asks for a default value.

```
`local myContextual = Contextual("foo")
`
```

At any time, you can query its current value using the `:now()` method.

```
`local myContextual = Contextual("foo")
print(myContextual:now()) --> foo
`
```

You can override the value for a limited span of time using `:is():during()`. Pass the temporary value to `:is()`, and pass a callback to `:during()`.

While the callback is running, the contextual will adopt the temporary value.

```
`local myContextual = Contextual("foo")
print(myContextual:now()) --> foo

myContextual:is("bar"):during(function()
    print(myContextual:now()) --> bar
end)

print(myContextual:now()) --> foo
`
```

By storing widely-used values inside contextuals, you can isolate different code paths from each other, while retaining the easy, hidden referencing that globals offer. This makes testing and memory management significantly easier, and helps you locate which code is modifying any shared values.

To demonstrate, the `Theme` example can be rewritten to use contextuals.

Theme.luauSomewhere else

| `local Fusion = require("path/to/Fusion.luau")local Contextual = Fusion.Contextuallocal Theme = {}Theme.colours = {    background = {        light = Color3.fromHex("FFFFFF"),        dark = Color3.fromHex("222222")    },    text = {        light = Color3.fromHex("FFFFFF"),        dark = Color3.fromHex("222222")    },    -- etc.}Theme.currentTheme = Contextual("light")return Theme` |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

In this rewritten example, `Theme` no longer requires an `init()` function, because - instead of defining a state object globally - `Theme` only defines `"light"` as the default value.

You're expected to replace the default value with a state object when you want to make the theme dynamic. This has a number of benefits:

- Because the override is time-limited to one span of your code, you can have multiple scripts running at the same time with completely different overrides.

- It also explicitly places your code in charge of memory management, because you're creating the object yourself.

- It's easy to locate where changes are coming from, because you can look for the nearest `:is():during()` call. Optionally, you could share a limited, read-only version of the value, while retaining private access to write to the value wherever you're overriding the contextual from.

- Testing becomes much simpler; you can override the contextual for different parts of your testing, without ever having to inject code, and without altering how you read and override the contextual in your production code.

It's still possible to run into issues with contextuals, though.

- You're still hiding a dependency of your code, which can still lead to confusion and obscuring available features, just the same as globals.
- Unlike globals, contextuals are time-limited. If you connect to an event or start a delayed task, you won't be able to access the value anymore. Instead, capture the value at the start of the code block, so you can use it in delayed tasks.

# Error Safety

Code can fail unexpectedly for many reasons. While Fusion tries to prevent many errors by design, Fusion can't stop you from trying to access data that doesn't exist, or taking actions that don't make sense to the computer.

So, you need to be able to deal with errors that happen while your program is running.

---

## Fatality[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/error-safety/#fatality "Permanent link")

An error can be either *fatal* or *non-fatal*:

- fatal errors aren't handled by anything, so they crash your program
- non-fatal errors are handled by Fusion and let your program continue

You're likely familiar with fatal errors. You can create them with `error()`:

Luau codeOutput

```
`print("before")
print("before")
print("before")

error("Kaboom!")

print("after")
print("after")
print("after")
`
```

You can make it non-fatal by protecting the call, with `pcall()`:

Luau codeOutput

```
`print("before")
print("before")
print("before")

pcall(function()
    error("Kaboom!")
end)

print("after")
print("after")
print("after")
`
```

### Example[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/error-safety/#example "Permanent link")

To demonstrate the difference, consider how Fusion handles errors in state objects.

State objects always run your code in a safe environment, to ensure that an error doesn't leave your state objects in a broken configuration.

This means you can broadly do whatever you like inside of them, and they won't cause a fatal error that stops your program from running.

Luau codeOutput

```
`print("before")
print("before")
print("before")

scope:Computed(function()
    error("Kaboom!")
end)

print("after")
print("after")
print("after")
`
```

These are *non-fatal* errors. You don't *have* to handle them, because Fusion will take all the necessary steps to ensure your program keeps running. In this case, the `Computed` object tries to roll back to the last value it had, if any.

```
`local number = scope:Value(1)
local double = scope:Computed(function(use)
    local number = use(number)
    assert(number ~= 3, "I don't like the number 3")
    return number * 2
end)

print("number:", peek(number), "double:", peek(double))
    --> number: 1 double: 2

number:set(2)
print("number:", peek(number), "double:", peek(double))
    --> number: 2 double: 4

number:set(3)
print("number:", peek(number), "double:", peek(double))
    --> number: 3 double: 4
number:set(4)
print("number:", peek(number), "double:", peek(double))
    --> number: 4 double: 8
`
```

### Be Careful[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/error-safety/#be-careful "Permanent link")

Just because your program continues running, doesn't mean that it will behave the way you expect it to. In the above example, the roll back gave us a nonsense answer:

```
`--> number: 3 double: 4
`
```

This is why it's still important to practice good error safety. If you expect an error to occur, you should always handle the error explicitly, and define what should be done about it.

```
`local number = scope:Value(1)
local double = scope:Computed(function(use)
    local number = use(number)
    local ok, result = pcall(function()
        assert(number ~= 3, "I don't like the number 3")
        return number * 2
    end)
    if ok then
        return result
    else
        return "failed: " .. err
    end
end)
`
```

Now when the computation fails, it fails more helpfully:

```
`--> number: 3 double: failed: I don't like the number 3
`
```

As a general rule, your program should never error in a way that prints red text to the output.

---

## Safe Expressions[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/error-safety/#safe-expressions "Permanent link")

Functions like `pcall` and `xpcall` can be useful for catching errors. However, they can often make a lot of code clunkier, like the code above.

To help with this, Fusion introduces [safe expressions](https://elttob.uk/Fusion/0.3/api-reference/general/members/safe). They let you try and run a calculation, and fall back to another calculation if it fails.

```
`Safe {
    try = function()
        return -- a value that might error during calculation
    end,
    fallback = function(theError)
        return -- a fallback value if an error does occur
    end
}
`
```

To see how `Safe` improves the readability and conciseness of your code, consider this next snippet. You can write it using `Safe`, `xpcall` and `pcall` \- here's how each one looks:

pcallxpcallSafe

```
`local double = scope:Computed(function(use)
    local ok, result = pcall(function()
        local number = use(number)
        assert(number ~= 3, "I don't like the number 3")
        return number * 2
    end)
    if ok then
        return result
    else
        return "failed: " .. err
    end
end)
`
```

`pcall` is the simplest way to safely handle errors. It's not entirely convenient because you have to check the `ok` boolean before you know whether the calculation was successful, which makes it difficult to use as part of a larger expression.

`xpcall` is an improvement over `pcall`, because it lets you define the fallback value as a second function, and uses its return value as the result of the calculation whenever an error occurs. However, it still returns the `ok` boolean, which has to be explicitly discarded.

`Safe` is an improvement over `xpcall`, because it does away with the `ok` boolean altogether, and *only* returns the result. It also clearly labels the `try` and `fallback` functions so you can easily tell which one handles which case.

As a result of its design, `Safe` can be used widely throughout Fusion to catch fatal errors. For example, you can use it to conditionally render error components directly as part of a larger UI:

```
`[Children] = Safe {
    try = function()
        return scope:FormattedForumPost {
            -- ... properties ...
        }
    end,
    fallback = function(err)
        return scope:ErrorPage {
            title = "An error occurred while showing this forum post",
            errorMessage = tostring(err)
        }
    end
}
`
```

### Non-Fatal Errors[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/error-safety/#non-fatal-errors "Permanent link")

As before, note that *non-fatal* errors aren't caught by `Safe`, because they do not cause the computation in `try()` to crash.

```
`-- The `Safe` is outside the `Computed`.
-- It will not catch the error, because the `Computed` handles the error.
local result = Safe {
    try = function()
        scope:Computed(function()
            error("Kaboom!")
        end)
        return "success"
    end,
    fallback = function(err)
        return "fail"
    end
}

print(result) --> success
`
```

You must move the `Safe` closer to the source of the error, as discussed before.

```
`-- The `Safe` and the the `Computed` have swapped places.
-- The error is now caught by the `Safe` instead of the `Computed`.
local result = scope:Computed(function()
    return Safe {
        try = function()
            error("Kaboom!")
            return "success"
        end,
        fallback = function(err)
            return "fail"
        end
    }
end)

print(peek(result)) --> fail`
```

# Optimisation

Fusion tries to handle your code in the smartest way it can. To help achieve the best performance, you can give Fusion more information about what you're trying to do, or avoid a few problematic scenarios that slow Fusion down.

---

## Update Skipping[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/optimisation/#update-skipping "Permanent link")

Fusion tries to skip updates when they result in 'meaningless changes'.

TL;DR

When your computations return values that aren't meaningfully different, Fusion doesn't bother to perform further updates.

However, Fusion can't automatically do this for tables. So, you should freeze every table you create, unless you need to change what's inside the table later (for example, if it's a list that changes over time).

This allows Fusion to apply more aggressive optimisations for free.

### Example[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/optimisation/#example "Permanent link")

Imagine you have a number, and you're using a computed to calculate whether it's even or odd.

An observer is used to see how often this results in other code being run.

Luau codeOutput

```
`local number = scope:Value(1)
local isEven = scope:Computed(function(use)
    return use(number) % 2 == 0
end)
scope:Observer(isEven):onChange(function()
    print("-> isEven has changed to " .. peek(isEven))
end)

print("Number becomes 2")
number:set(2)
print("Number becomes 3")
number:set(3)
print("Number becomes 13")
number:set(13)
print("Number becomes 14")
number:set(14)
print("Number becomes 24")
number:set(24)
`
```

Notice that the observer only runs when `isEven` returns a meaningfully different value:

- When the number changed from 2 to 3, `isEven` returned `false`. This is meaningfully different from the previous value of `isEven`, which was `true`. As a result, the observer is run and the printed message is seen.

- When the number changed from 3 to 13, `isEven` returned `false`. This is *not* meaningfully different from the previous value of `isEven`, which was `false`. As a result, the observer does not run, and no printed message is seen.

### Similarity[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/optimisation/#similarity "Permanent link")

When trying to determine if a change is 'meaningless', Fusion compares the old and new values, using what's called the *similarity test*.

The similarity test is a fast, approximate test that Fusion uses to guess which updates it can safely discard. If two values pass the similarity test, then you should be able to use them interchangeably without affecting most Luau code.

In Fusion's case, if the values before and after a change are similar, then Fusion won't continue updating other code beyond that change, because those updates aren't likely to have an effect on the outcome of computations.

Here's what the similarity test looks for:

- Different types:
  - Two values of different types are never similar to each other.
- Tables:
  - Frozen tables are similar to other values when they're `==` to each other.
  - Tables with a metatable are similar to other values when when they're `==` to each other.
  - Other kinds of table are never similar to anything.
- Userdatas:
  - Userdatas are similar to other values when they're `==` to each other.
- NaN:
  - If each value does not `==` itself, then the two values are similar to each other.
  - _This doesn't apply to tables or userdatas._
- Any other values:
  - Two values are similar to each other when they're `==` to each other.

Roblox data types

Roblox data types are not considered to be userdatas. Instead, the similarity test follows `typeof()` rules when determining type.

### Optimising For Similarity[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/optimisation/#optimising-for-similarity "Permanent link")

With this knowledge about the similarity test, you can experiment with how Fusion optimises different changes, and what breaks that optimisation.

#### Tables[¶](https://elttob.uk/Fusion/0.3/tutorials/best-practices/optimisation/#tables "Permanent link")

Imagine you're setting a value object to a table of theme colours. You attach an observer object to see when Fusion thinks the theme meaningfully changed.

Luau codeOutput

```
`local LIGHT_THEME = {
    name = "light",
    -- imagine theme colours in here
}
local DARK_THEME = {
    name = "dark",
    -- imagine theme colours in here
}
local currentTheme = scope:Value(LIGHT_THEME)
scope:Observer(currentTheme):onChange(function()
    print("-> currentTheme changed to " .. peek(currentTheme).name)
end)

print("Set to DARK_THEME")
currentTheme:set(DARK_THEME)
print("Set to DARK_THEME")
currentTheme:set(DARK_THEME)
print("Set to LIGHT_THEME")
currentTheme:set(LIGHT_THEME)
print("Set to LIGHT_THEME")
currentTheme:set(LIGHT_THEME)
`
```

Because the `LIGHT_THEME` and `DARK_THEME` tables aren't frozen, and they don't have any metatables, Fusion will never skip over updates that change to or from those values.

Why won't Fusion skip those updates?

In Fusion, it's common to update arrays without creating a new array. This is known as *mutating* the array.

```
`local drinks = scope:Value({"beer", "pepsi"})

do -- add tea
    local array = peek(drinks)
    table.insert(array, "tea") -- mutation occurs here
    drinks:set(array) -- still the same array, so it's ==
end
`
```

If Fusion skipped updates when the old and new values were `==`, then these mutating changes wouldn't cause an update.

For that reason, Fusion doesn't skip updates for tables unless you do one of two things:

- You disable the ability to mutate the table (via `table.freeze`).
- You indicate to Fusion that this isn't plain data by adding a metatable.
  - Metatables are almost always used for OOP, where `==` is a sensible way of determining if two objects are similar.
  - You can also use metatables to define how equality should work, which Fusion will respect - though Fusion expects it to be symmetric.

According to the similarity test (and the question section above), one way to skip these updates is by freezing the original tables.

Luau codeOutput

```
`local LIGHT_THEME = table.freeze {
    name = "light",
    -- imagine theme colours in here
}
local DARK_THEME = table.freeze {
    name = "dark",
    -- imagine theme colours in here
}
local currentTheme = scope:Value(LIGHT_THEME)
scope:Observer(currentTheme):onChange(function()
    print("-> currentTheme changed to " .. peek(currentTheme).name)
end)

print("Set to DARK_THEME")
currentTheme:set(DARK_THEME)
print("Set to DARK_THEME")
currentTheme:set(DARK_THEME)
print("Set to LIGHT_THEME")
currentTheme:set(LIGHT_THEME)
print("Set to LIGHT_THEME")
currentTheme:set(LIGHT_THEME)
`
```

Now, Fusion is confident enough to skip over the updates.

In general, you should freeze all of your tables when working with Fusion, unless you have a reason for modifying them later on. There's almost zero cost to freezing a table, making this modification essentially free. Plus, this lets Fusion optimise your updates more aggressively, which means you spend less time running computations on average.

# Examples[¶](https://elttob.uk/Fusion/0.3/examples/#examples "Permanent link")

Welcome to the Examples section! Here, you can find various open-source examples and projects, so you can see how Fusion works in a real setting.

---

## The Cookbook[¶](https://elttob.uk/Fusion/0.3/examples/#the-cookbook "Permanent link")

Oftentimes, you might be stuck on a small problem. You want to create something specific, but don't know how to do it with Fusion's tools.

The cookbook can help with that! It's a collection of snippets which show you how to do various small tasks with Fusion, like processing arrays, applying animations and responding to different events.

[Visit the cookbook to see what's available.](https://elttob.uk/Fusion/0.3/examples/cookbook)

---

## Open-Source Projects[¶](https://elttob.uk/Fusion/0.3/examples/#open-source-projects "Permanent link")

### Fusion Wordle (for Fusion 0.2)[¶](https://elttob.uk/Fusion/0.3/examples/#fusion-wordle-for-fusion-02 "Permanent link")

![A photo taken in Fusion Wordle, showing a completed game board](https://elttob.uk/Fusion/0.3/examples/place-thumbnails/Fusion-Wordle.jpg)

See how Fusion can be used to build a mobile-first UI-centric game, with server validation, spring animations and sounds.

[Play and edit the game on Roblox.](https://www.roblox.com/games/12178127791/)

### Fusion Obby (for Fusion 0.1)[¶](https://elttob.uk/Fusion/0.3/examples/#fusion-obby-for-fusion-01 "Permanent link")

![A photo taken in Fusion Obby, showing the counter and confetti](https://elttob.uk/Fusion/0.3/examples/place-thumbnails/Fusion-Obby.jpg)

See how Fusion can be used to build a minimal interface for an obby, with an animated checkpoint counter and simulated confetti.

[Play and edit the game on Roblox.](https://www.roblox.com/games/7262692194/Fusion-Obby)

# Cookbook[¶](https://elttob.uk/Fusion/0.3/examples/cookbook/#cookbook "Permanent link")

Oftentimes, you might be stuck on a small problem. You want to create something specific, but don't know how to do it with Fusion's tools.

The cookbook can help with that! It's a collection of snippets which show you how to do various small tasks with Fusion, like processing arrays, applying animations and responding to different events.

---

## Navigation[¶](https://elttob.uk/Fusion/0.3/examples/cookbook/#navigation "Permanent link")

Using the sidebar to the left, you can browse all of the cookbook examples by name.

# Player List

This shows how to use Fusion's Roblox API to create a simple, dynamically updating player list.

---

## Overview[¶](https://elttob.uk/Fusion/0.3/examples/cookbook/player-list/#overview "Permanent link")

| `` local Players = game:GetService("Players")local Fusion = -- initialise Fusion here however you please!local scoped = Fusion.scopedlocal Children = Fusion.Childrentype UsedAs<T> = Fusion.UsedAs<T>local function PlayerList(    scope: Fusion.Scope,    props: {        Players: UsedAs<{Player}>    }): Fusion.Child    return scope:New "Frame" {        Name = "PlayerList",        Position = UDim2.fromScale(1, 0),        AnchorPoint = Vector2.new(1, 0),        Size = UDim2.fromOffset(300, 0),        AutomaticSize = "Y",        BackgroundTransparency = 0.5,        BackgroundColor3 = Color3.new(0, 0, 0),        [Children] = {            scope:New "UICorner" {                CornerRadius = UDim.new(0, 8)            },            scope:New "UIListLayout" {                SortOrder = "Name",                FillDirection = "Vertical"            },            scope:ForValues(props.Players, function(use, scope, player)                return scope:New "TextLabel" {                    Name = "PlayerListRow: " .. player.DisplayName,                    Size = UDim2.new(1, 0, 0, 25),                    BackgroundTransparency = 1,                    Text = player.DisplayName,                    TextColor3 = Color3.new(1, 1, 1),                    Font = Enum.Font.GothamMedium,                    TextSize = 16,                    TextXAlignment = "Right",                    TextTruncate = "AtEnd",                    [Children] = scope:New "UIPadding" {                        PaddingLeft = UDim.new(0, 10),                        PaddingRight = UDim.new(0, 10)                    }                }            end)        }    }end-- Don't forget to pass this to `doCleanup` if you disable the script.local scope = scoped(Fusion, {    PlayerList = PlayerList})local players = scope:Value(Players:GetPlayers())local function updatePlayers()    players:set(Players:GetPlayers())endtable.insert(scope, {    Players.PlayerAdded:Connect(updatePlayers),    Players.PlayerRemoving:Connect(updatePlayers)})local gui = scope:New "ScreenGui" {    Name = "PlayerListGui",    Parent = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui"),    [Children] = scope:PlayerList {        Players = players    }} `` |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

---

## Explanation[¶](https://elttob.uk/Fusion/0.3/examples/cookbook/player-list/#explanation "Permanent link")

The `PlayerList` component is designed to be simple and self-contained. The only thing it needs is a `Players` list - it handles everything else, including its position, size, appearance and behaviour.

```
`local function PlayerList(
    scope: Fusion.Scope,
    props: {
        Players: UsedAs<{Player}>
    }
): Fusion.Child
`
```

After creating a vertically expanding Frame with some style and layout added, it turns the `Players` into a series of text labels using `ForValues`, which will automatically create and remove them as the `Players` list changes.

```
`            scope:ForValues(props.Players, function(use, scope, player)
                return scope:New "TextLabel" {
                    Name = "PlayerListRow: " .. player.DisplayName,

                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundTransparency = 1,

                    Text = player.DisplayName,
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.GothamMedium,
                    TextSize = 16,
                    TextXAlignment = "Right",
                    TextTruncate = "AtEnd",

                    [Children] = scope:New "UIPadding" {
                        PaddingLeft = UDim.new(0, 10),
                        PaddingRight = UDim.new(0, 10)
                    }
                }
            end)
`
```

That's all that the `PlayerList` component has to do.

Later on, the code creates a `Value` object to store a list of players, and update it every time a player joins or leaves the game.

```
`local players = scope:Value(Players:GetPlayers())
local function updatePlayers()
    players:set(Players:GetPlayers())
end
table.insert(scope, {
    Players.PlayerAdded:Connect(updatePlayers),
    Players.PlayerRemoving:Connect(updatePlayers)
})
`
```

That object can then be passed in as `Players` when creating the `PlayerList`.

```
`local gui = scope:New "ScreenGui" {
    Name = "PlayerListGui",
    Parent = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui"),

    [Children] = scope:PlayerList {
        Players = players
    }
}`
```

# Animated Computed

This example shows you how to animate a single value with an animation curve of your preference.

For demonstration, the example uses Roblox API members.

---

## Overview[¶](https://elttob.uk/Fusion/0.3/examples/cookbook/animated-computed/#overview "Permanent link")

| `` local Players = game:GetService("Players")local Fusion = -- initialise Fusion here however you please!local scoped = Fusion.scopedlocal Children = Fusion.Childrenlocal TWEEN_INFO = TweenInfo.new(    0.5,    Enum.EasingStyle.Sine,    Enum.EasingDirection.InOut)-- Don't forget to pass this to `doCleanup` if you disable the script.local scope = scoped(Fusion)-- You can set this at any time to indicate where The Thing should be.local showTheThing = scope:Value(false)local exampleUI = scope:New "ScreenGui" {    Parent = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui"),    Name = "Example UI",    [Children] = scope:New "Frame" {        Name = "The Thing",        Position = scope:Tween(            scope:Computed(function(use)                local CENTRE = UDim2.fromScale(0.5, 0.5)                local OFFSCREEN = UDim2.fromScale(-0.5, 0.5)                return if use(showTheThing) then CENTRE else OFFSCREEN            end),            TWEEN_INFO        ),        Size = UDim2.fromOffset(200, 200)    }}-- Without toggling the value, you won't see it animate.task.defer(function()    while true do        task.wait(1)        showTheThing:set(not peek(showTheThing))    endend) `` |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

---

## Explanation[¶](https://elttob.uk/Fusion/0.3/examples/cookbook/animated-computed/#explanation "Permanent link")

There's three key components to the above code snippet.

Firstly, there's `showTheThing`. When this is `true`, The Thing should be in the centre of the screen. Otherwise, The Thing should be off-screen.

```
`-- You can set this at any time to indicate where The Thing should be.
local showTheThing = scope:Value(false)
`
```

Next, there's the computed object on line 26. This takes that boolean value, and turns it into a UDim2 position for The Thing to use. You can imagine this as the 'non-animated' version of what you want The Thing to do, if it were to instantly teleport around.

```
`            scope:Computed(function(use)
                local CENTRE = UDim2.fromScale(0.5, 0.5)
                local OFFSCREEN = UDim2.fromScale(-0.5, 0.5)
                return if use(showTheThing) then CENTRE else OFFSCREEN
            end),
`
```

Finally, there's the tween object that the computed is being passed into. The tween object will smoothly move towards the computed over time. If needed, you could separate the computed into a dedicated variable to access it independently.

```
`        Position = scope:Tween(
            scope:Computed(function(use)
                local CENTRE = UDim2.fromScale(0.5, 0.5)
                local OFFSCREEN = UDim2.fromScale(-0.5, 0.5)
                return if use(showTheThing) then CENTRE else OFFSCREEN
            end),
            TWEEN_INFO
        ),
`
```

The 'shape' of the animation is saved in a `TWEEN_INFO` constant defined earlier in the code. [The Tween tutorial](https://elttob.uk/Fusion/0.3/tutorials/animation/tweens) explains how each parameter shapes the motion.

```
`local TWEEN_INFO = TweenInfo.new(
    0.5,
    Enum.EasingStyle.Sine,
    Enum.EasingDirection.InOut
)
`
```

Fluid animations with springs

For extra smooth animation shapes that preserve velocity, consider trying [spring objects](https://elttob.uk/Fusion/0.3/tutorials/animation/springs). They're very similar in usage and can help improve the responsiveness of the motion.

# Fetch Data From Server

This code shows how to deal with yielding/blocking code, such as fetching data from a server.

Because these tasks don't complete immediately, they can't be directly run inside of a `Computed`, so this example provides a robust framework for handling this in a way that doesn't corrupt your code.

This example assumes the presence of a Roblox-like `task` scheduler.

---

## Overview[¶](https://elttob.uk/Fusion/0.3/examples/cookbook/fetch-data-from-server/#overview "Permanent link")

| `` local Fusion = -- initialise Fusion here however you please!local scoped = Fusion.scopedlocal function fetchUserBio(    userID: number): string    -- pretend this calls out to a server somewhere, causing this code to yield    task.wait(1)    return "This is the bio for user " .. userID .. "!"end-- Don't forget to pass this to `doCleanup` if you disable the script.local scope = scoped(Fusion)-- This doesn't have to be a `Value` - any kind of state object works too.local currentUserID = scope:Value(1670764)-- While the bio is loading, this is `nil` instead of a string.local currentUserBio: Fusion.Value<string?> = scope:Value(nil)do    local fetchInProgress = nil    local function performFetch()        local userID = peek(currentUserID)        currentUserBio:set(nil)        if fetchInProgress ~= nil then            task.cancel(fetchInProgress)        end        fetchInProgress = task.spawn(function()            currentUserBio:set(fetchUserBio())            fetchInProgress = nil        end)    end    scope:Observer(currentUserID):onBind(performFetch)endscope:Observer(currentUserBio):onBind(function()    local bio = peek(currentUserBio)    if bio == nil then        print("User bio is loading...")    else        print("Loaded user bio:", bio)    endend) `` |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

---

## Explanation[¶](https://elttob.uk/Fusion/0.3/examples/cookbook/fetch-data-from-server/#explanation "Permanent link")

If you yield or wait inside of a `Computed`, you can easily corrupt your entire program.

However, this example has a function, `fetchUserBio`, that yields.

```
`local function fetchUserBio(
    userID: number
): string
    -- pretend this calls out to a server somewhere, causing this code to yield
    task.wait(1)
    return "This is the bio for user " .. userID .. "!"
end
`
```

It also has some arbitrary state object, `currentUserID`, that it needs to convert into a bio somehow.

```
`-- This doesn't have to be a `Value` - any kind of state object works too.
local currentUserID = scope:Value(1670764)
`
```

Because `Computed` can't yield, this code has to manually manage a `currentUserBio` object, which will store the output of the code in a way that can be used by other Fusion objects later.

Notice that the 'loading' state is explicitly documented. It's a good idea to be clear and honest when you have no data to show, because it allows other code to respond to that case flexibly.

```
`-- While the bio is loading, this is `nil` instead of a string.
local currentUserBio: Fusion.Value<string?> = scope:Value(nil)
`
```

To perform the actual fetch, a simple function can be written which calls `fetchUserBio` in a separate task. Once it returns a bio, the `currentUserBio` can be updated.

To avoid two fetches overwriting each other, any existing fetch task is canceled before the new task is created.

```
`    local fetchInProgress = nil
    local function performFetch()
        local userID = peek(currentUserID)
        currentUserBio:set(nil)
        if fetchInProgress ~= nil then
            task.cancel(fetchInProgress)
        end
        fetchInProgress = task.spawn(function()
            currentUserBio:set(fetchUserBio())
            fetchInProgress = nil
        end)
    end
`
```

Finally, to run this function when the `currentUserID` changes, `performFetch` can be added to an `Observer`.

The `onBind` method also runs `performFetch` once at the start of the program, so the request is sent out automatically.

```
`scope:Observer(currentUserID):onBind(performFetch)
`
```

That's all you need - now, any other Fusion code can read and depend upon `currentUserBio` as if it were any other kind of state object. Just remember to handle the 'loading' state as well as the successful state.

```
`scope:Observer(currentUserBio):onBind(function()
    local bio = peek(currentUserBio)
    if bio == nil then
        print("User bio is loading...")
    else
        print("Loaded user bio:", bio)
    end
end)
`
```

You may wish to expand this code with error handling if `fetchUserBio()` can throw errors.

# Light & Dark Theme

This example demonstrates how to create dynamic theme colours using Fusion's state objects.

---

## Overview[¶](https://elttob.uk/Fusion/0.3/examples/cookbook/light-and-dark-theme/#overview "Permanent link")

| `` local Fusion = --initialise Fusion here however you please!local scoped = Fusion.scopedlocal Theme = {}Theme.colours = {    background = {        light = Color3.fromHex("FFFFFF"),        dark = Color3.fromHex("222222")    },    text = {        light = Color3.fromHex("222222"),        dark = Color3.fromHex("FFFFFF")    }}-- Don't forget to pass this to `doCleanup` if you disable the script.local scope = scoped(Fusion)Theme.current = scope:Value("light")Theme.dynamic = {}for colour, variants in Theme.colours do    Theme.dynamic[colour] = scope:Computed(function(use)        return variants[use(Theme.current)]    end)endTheme.current:set("light")print(peek(Theme.dynamic.background)) --> 255, 255, 255Theme.current:set("dark")print(peek(Theme.dynamic.background)) --> 34, 34, 34 `` |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

---

## Explanation[¶](https://elttob.uk/Fusion/0.3/examples/cookbook/light-and-dark-theme/#explanation "Permanent link")

To begin, this example defines a set of colours with light and dark variants.

```
`Theme.colours = {
    background = {
        light = Color3.fromHex("FFFFFF"),
        dark = Color3.fromHex("222222")
    },
    text = {
        light = Color3.fromHex("222222"),
        dark = Color3.fromHex("FFFFFF")
    }
}
`
```

A `Value` object stores which variant is in use right now.

```
`Theme.current = scope:Value("light")
`
```

Finally, each colour is turned into a `Computed`, which dynamically pulls the desired variant from the list.

```
`Theme.dynamic = {}
for colour, variants in Theme.colours do
    Theme.dynamic[colour] = scope:Computed(function(use)
        return variants[use(Theme.current)]
    end)
end
`
```

This allows other code to easily access theme colours from `Theme.dynamic`.

```
`Theme.current:set("light")
print(peek(Theme.dynamic.background)) --> 255, 255, 255

Theme.current:set("dark")
print(peek(Theme.dynamic.background)) --> 34, 34, 34`
```

# Button Component

This example is a relatively complete button component implemented using Fusion's Roblox API. It handles many common interactions such as hovering and clicking.

This should be a generally useful template for assembling components of your own. For further ideas and best practices for building components, see [the Components tutorial](https://elttob.uk/Fusion/0.3/tutorials/components/components).

---

## Overview[¶](https://elttob.uk/Fusion/0.3/examples/cookbook/button-component/#overview "Permanent link")

| `` local Fusion = -- initialise Fusion here however you please!local scoped = Fusion.scopedlocal Children, OnEvent = Fusion.Children, Fusion.OnEventtype UsedAs<T> = Fusion.UsedAs<T>local COLOUR_BLACK = Color3.new(0, 0, 0)local COLOUR_WHITE = Color3.new(1, 1, 1)local COLOUR_TEXT = COLOUR_WHITElocal COLOUR_BG_REST = Color3.fromHex("0085FF")local COLOUR_BG_HOVER = COLOUR_BG_REST:Lerp(COLOUR_WHITE, 0.25)local COLOUR_BG_HELD = COLOUR_BG_REST:Lerp(COLOUR_BLACK, 0.25)local COLOUR_BG_DISABLED = Color3.fromHex("CCCCCC")local BG_FADE_SPEED = 20 -- spring speed unitslocal ROUNDED_CORNERS = UDim.new(0, 4)local PADDING = UDim2.fromOffset(6, 4)local function Button(    scope: Fusion.Scope,    props: {        Name: UsedAs<string>?,        Layout: {            LayoutOrder: UsedAs<number>?,            Position: UsedAs<UDim2>?,            AnchorPoint: UsedAs<Vector2>?,            ZIndex: UsedAs<number>?,            Size: UsedAs<UDim2>?,            AutomaticSize: UsedAs<Enum.AutomaticSize>?        },        Text: UsedAs<string>?,        Disabled: UsedAs<boolean>?,        OnClick: (() -> ())?    }): Fusion.Child    local isHovering = scope:Value(false)    local isHeldDown = scope:Value(false)    return scope:New "TextButton" {        Name = props.Name,        LayoutOrder = props.Layout.LayoutOrder,        Position = props.Layout.Position,        AnchorPoint = props.Layout.AnchorPoint,        ZIndex = props.Layout.ZIndex,        Size = props.Layout.Size,        AutomaticSize = props.Layout.AutomaticSize,        Text = props.Text,        TextColor3 = COLOUR_TEXT,        BackgroundColor3 = scope:Spring(            scope:Computed(function(use)                -- The order of conditions matter here; it defines which states                -- visually override other states, with earlier states being                -- more important.                return                    if use(props.Disabled) then COLOUR_BG_DISABLED                    elseif use(isHeldDown) then COLOUR_BG_HELD                    elseif use(isHovering) then COLOUR_BG_HOVER                    else return COLOUR_BG_REST                end            end),             BG_FADE_SPEED        ),        [OnEvent "Activated"] = function()            if props.OnClick ~= nil and not peek(props.Disabled) then                -- Explicitly called with no arguments to match the typedef.                 -- If passed straight to `OnEvent`, the function might receive                -- arguments from the event. If the function secretly *does*                -- take arguments (despite the type) this would cause problems.                props.OnClick()            end        end,        [OnEvent "MouseButton1Down"] = function()            isHeldDown:set(true)        end,        [OnEvent "MouseButton1Up"] = function()            isHeldDown:set(false)        end,        [OnEvent "MouseEnter"] = function()            -- Roblox calls this event even if the button is being covered by            -- other UI. For simplicity, this does not account for that.            isHovering:set(true)        end,        [OnEvent "MouseLeave"] = function()            -- If the button is being held down, but the cursor moves off the            -- button, then we won't receive the mouse up event. To make sure            -- the button doesn't get stuck held down, we'll release it if the            -- cursor leaves the button.            isHeldDown:set(false)            isHovering:set(false)        end,        [Children] = {            New "UICorner" {                CornerRadius = ROUNDED_CORNERS            },            New "UIPadding" {                PaddingTop = PADDING.Y,                PaddingBottom = PADDING.Y,                PaddingLeft = PADDING.X,                PaddingRight = PADDING.X            }        }    }endreturn Button `` |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

---

## Explanation[¶](https://elttob.uk/Fusion/0.3/examples/cookbook/button-component/#explanation "Permanent link")

The main part of note is the function signature. It's highly recommended that you statically type the function signature for components, because it not only improves autocomplete and error checking, but also acts as up-to-date, machine readable documentation.

```
`local function Button(
    scope: Fusion.Scope,
    props: {
        Name: UsedAs<string>?,
        Layout: {
            LayoutOrder: UsedAs<number>?,
            Position: UsedAs<UDim2>?,
            AnchorPoint: UsedAs<Vector2>?,
            ZIndex: UsedAs<number>?,
            Size: UsedAs<UDim2>?,
            AutomaticSize: UsedAs<Enum.AutomaticSize>?
        },
        Text: UsedAs<string>?,
        Disabled: UsedAs<boolean>?,
        OnClick: (() -> ())?
    }
): Fusion.Child
`
```

The `scope` parameter specifies that the component depends on Fusion's methods. If you're not sure how to write type definitions for scopes, [the 'Scopes' section of the Components tutorial](https://elttob.uk/Fusion/0.3/tutorials/components/components/#scopes) goes into further detail.

The property table is laid out with each property on a new line, so it's easy to scan the list and see what properties are available. Most are typed with [`UsedAs`](https://elttob.uk/Fusion/0.3/api-reference/state/types/usedas), which allows the user to use state objects if they desire. They're also `?` (optional), which can reduce boilerplate when using the component. Not all properties have to be that way, but usually it's better to have the flexibility.

Property grouping

You can group properties together in nested tables, like the `Layout` table above, to avoid long mixed lists of properties. In addition to being more readable, this can sometimes help with passing around lots of properties at once, because you can pass the whole nested table as one value if you'd like to.

The return type of the function is `Fusion.Child`, which tells the user that the component is compatible with Fusion's `[Children]` API, without exposing what children it's returning specifically. This helps ensure the user doesn't accidentally depend on the internal structure of the component.

# Loading Spinner

This example implements a procedural spinning animation using Fusion's Roblox APIs.

---

## Overview[¶](https://elttob.uk/Fusion/0.3/examples/cookbook/loading-spinner/#overview "Permanent link")

| `` local RunService = game:GetService("RunService")local Fusion = -- initialise Fusion here however you please!local scoped = Fusion.scopedlocal Children = Fusion.Childrentype UsedAs<T> = Fusion.UsedAs<T>local SPIN_DEGREES_PER_SECOND = 180local SPIN_SIZE = 50local function Spinner(    scope: Fusion.Scope,    props: {        Layout: {            LayoutOrder: UsedAs<number>?,            Position: UsedAs<UDim2>?,            AnchorPoint: UsedAs<Vector2>?,            ZIndex: UsedAs<number>?        },        CurrentTime: UsedAs<number>,    }): Fusion.Child    return scope:New "ImageLabel" {        Name = "Spinner",        LayoutOrder = props.Layout.LayoutOrder,        Position = props.Layout.Position,        AnchorPoint = props.Layout.AnchorPoint,        ZIndex = props.Layout.ZIndex,        Size = UDim2.fromOffset(SPIN_SIZE, SPIN_SIZE),        BackgroundTransparency = 1,        Image = "rbxassetid://your-loading-spinner-image", -- replace this!        Rotation = scope:Computed(function(use)            return (use(props.CurrentTime) * SPIN_DEGREES_PER_SECOND) % 360        end)    }end-- Don't forget to pass this to `doCleanup` if you disable the script.local scope = scoped(Fusion, {    Spinner = Spinner})local currentTime = scope:Value(os.clock())table.insert(scope,    RunService.RenderStepped:Connect(function()        currentTime:set(os.clock())    end))local spinner = scope:Spinner {    Layout = {        Position = UDim2.fromScale(0.5, 0.5),        AnchorPoint = Vector2.new(0.5, 0.5),        Size = UDim2.fromOffset(50, 50)    },    CurrentTime = currentTime} `` |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

---

## Explanation[¶](https://elttob.uk/Fusion/0.3/examples/cookbook/loading-spinner/#explanation "Permanent link")

The `Spinner` components implements the animation for the loading spinner. It's largely a standard Fusion component definition.

The main thing to note is that it asks for a `CurrentTime` property.

```
`local function Spinner(
    scope: Fusion.Scope,
    props: {
        Layout: {
            LayoutOrder: UsedAs<number>?,
            Position: UsedAs<UDim2>?,
            AnchorPoint: UsedAs<Vector2>?,
            ZIndex: UsedAs<number>?
        },
        CurrentTime: UsedAs<number>,
    }
): Fusion.Child
`
```

The `CurrentTime` is used to drive the rotation of the loading spinner.

```
`        Rotation = scope:Computed(function(use)
            return (use(props.CurrentTime) * SPIN_DEGREES_PER_SECOND) % 360
        end)
`
```

That's all that's required for the `Spinner` component.

Later on, the example creates a `Value` object that will store the current time, and starts a process to keep it up to date.

```
`local currentTime = scope:Value(os.clock())
table.insert(scope,
    RunService.RenderStepped:Connect(function()
        currentTime:set(os.clock())
    end)
)
`
```

This can then be passed in as `CurrentTime` when the `Spinner` is created.

```
`local spinner = scope:Spinner {
    Layout = {
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(50, 50)
    },
    CurrentTime = currentTime
}`
```

# Drag & Drop

This example shows a full drag-and-drop implementation for mouse input only, using Fusion's Roblox API.

To ensure best accessibility, any interactions you implement shouldn't force you to hold the mouse button down. Either allow drag-and-drop with single clicks, or provide a non-dragging alternative. This ensures people with reduced motor ability aren't locked out of UI functions.

| `` local Players = game:GetService("Players")local UserInputService = game:GetService("UserInputService")local Fusion = -- initialise Fusion here however you please!local scoped = Fusion.scopedlocal Children, OnEvent = Fusion.Children, Fusion.OnEventtype UsedAs<T> = Fusion.UsedAs<T>type DragInfo = {    id: string,    mouseOffset: Vector2 -- relative to the dragged item}local function Draggable(    scope: Fusion.Scope,    props: {        ID: string,        Name: UsedAs<string>?,        Parent: UsedAs<Instance?>,        Layout: {            LayoutOrder: UsedAs<number>?,            Position: UsedAs<UDim2>?,            AnchorPoint: UsedAs<Vector2>?,            ZIndex: UsedAs<number>?,            Size: UsedAs<UDim2>?,            OutAbsolutePosition: Fusion.Value<Vector2>?,        },        Dragging: {            MousePosition: UsedAs<Vector2>,            SelfDragInfo: UsedAs<DragInfo?>,            OverlayFrame: UsedAs<Instance?>        }        [typeof(Children)]: Fusion.Child    }): Fusion.Child    -- When `nil`, the parent can't be measured for some reason.    local parentSize = scope:Value(nil)    do        local function measureParentNow()            local parent = peek(props.Parent)            parentSize:set(                if parent ~= nil and parent:IsA("GuiObject")                then parent.AbsoluteSize                else nil            )        end        local resizeConn = nil        local function stopMeasuring()            if resizeConn ~= nil then                resizeConn:Disconnect()                resizeConn = nil            end        end        scope:Observer(props.Parent):onBind(function()            stopMeasuring()            measureParentNow()            if peek(parentSize) ~= nil then                resizeConn = parent:GetPropertyChangedSignal("AbsoluteSize")                    :Connect(measureParentNow)            end        end)        table.insert(scope, stopMeasuring)    end    return New "Frame" {        Name = props.Name or "Draggable",        Parent = scope:Computed(function(use)            return                if use(props.Dragging.SelfDragInfo) ~= nil                then use(props.Dragging.OverlayFrame)                else use(props.Parent)        end),        LayoutOrder = props.Layout.LayoutOrder,        AnchorPoint = props.Layout.AnchorPoint,        ZIndex = props.Layout.ZIndex,        AutomaticSize = props.Layout.AutomaticSize,        BackgroundTransparency = 1,        Position = scope:Computed(function(use)            local dragInfo = use(props.Dragging.SelfDragInfo)            if dragInfo == nil then                return use(props.Layout.Position) or UDim2.fromOffset(0, 0)            else                local mousePos = use(props.Dragging.MousePosition)                local topLeftCorner = mousePos - dragInfo.mouseOffset                return UDim2.fromOffset(topLeftCorner.X, topLeftCorner.Y)            end        end),        -- Calculated manually so the Scale can be set relative to        -- `props.Parent` at all times, rather than the `Parent` of this Frame.        Size = scope:Computed(function(use)            local udim2 = use(props.Layout.Size) or UDim2.fromOffset(0, 0)            local parentSize = use(parentSize) or Vector2.zero            return UDim2.fromOffset(                udim2.X.Scale * parentSize.X + udim2.X.Offset,                udim2.Y.Scale * parentSize.Y + udim2.Y.Offset            )        end),        [Out "AbsolutePosition"] = props.OutAbsolutePosition,        [Children] = props[Children]    }endlocal COLOUR_COMPLETED = Color3.new(0, 1, 0)local COLOUR_NOT_COMPLETED = Color3.new(1, 1, 1)local TODO_ITEM_SIZE = UDim2.new(1, 0, 0, 50)local function newUniqueID()    -- You can replace this with a better method for generating unique IDs.    return game:GetService("HttpService"):GenerateGUID()endtype TodoItem = {    id: string,    text: string,    completed: Fusion.Value<boolean>}local todoItems: Fusion.Value<TodoItem> = {    {        id = newUniqueID(),        text = "Wake up today",        completed = Value(true)    },    {        id = newUniqueID(),        text = "Read the Fusion docs",        completed = Value(true)    },    {        id = newUniqueID(),        text = "Take over the universe",        completed = Value(false)    }}local function getTodoItemForID(    id: string): TodoItem?    for _, item in todoItems do        if item.id == id then            return item        end    end    return nilendlocal function TodoEntry(    scope: Fusion.Scope,    props: {        Item: TodoItem,        Parent: UsedAs<Instance?>,        Layout: {            LayoutOrder: UsedAs<number>?,            Position: UsedAs<UDim2>?,            AnchorPoint: UsedAs<Vector2>?,            ZIndex: UsedAs<number>?,            Size: UsedAs<UDim2>?,            OutAbsolutePosition: Fusion.Value<Vector2>?,        },        Dragging: {            MousePosition: UsedAs<Vector2>,            SelfDragInfo: UsedAs<CurrentlyDragging?>,            OverlayFrame: UsedAs<Instance>?        },        OnMouseDown: () -> ()?    }): Fusion.Child    local scope = scope:innerScope {        Draggable = Draggable    }    local itemPosition = scope:Value(nil)    local itemIsDragging = scope:Computed(function(use)        local dragInfo = use(props.CurrentlyDragging)        return dragInfo ~= nil and dragInfo.id == props.Item.id    end)    return scope:Draggable {        ID = props.Item.id,        Name = props.Item.text,        Parent = props.Parent,        Layout = props.Layout,        Dragging = props.Dragging,        [Children] = scope:New "TextButton" {            Name = "TodoEntry",            Size = UDim2.fromScale(1, 1),            BackgroundColor3 = scope:Computed(function(use)                return                    if use(props.Item.completed)                    then COLOUR_COMPLETED                    else COLOUR_NOT_COMPLETED                end            end),            Text = props.Item.text,            TextSize = 28,            [OnEvent "MouseButton1Down"] = props.OnMouseDown            -- Don't detect mouse up here, because in some rare cases, the event            -- could be missed due to lag between the item's position and the            -- cursor position.        }    }end-- Don't forget to pass this to `doCleanup` if you disable the script.local scope = scoped(Fusion)local mousePos = scope:Value(UserInputService:GetMouseLocation())table.insert(scope,     UserInputService.InputChanged:Connect(function(inputObject)        if inputObject.UserInputType == Enum.UserInputType.MouseMovement then            -- If this code did not read coordinates from the same method, it            -- might inconsistently handle UI insets. So, keep it simple!            mousePos:set(UserInputService:GetMouseLocation())        end    end))local dropAction = scope:Value(nil)local taskLists = scope:ForPairs(    {        incomplete = "mark-as-incomplete",        completed = "mark-as-completed"     },    function(use, scope, listName, listDropAction)        return             listName,             scope:New "ScrollingFrame" {                Name = `TaskList ({listName})`,                Position = UDim2.fromScale(0.1, 0.1),                Size = UDim2.fromScale(0.35, 0.9),                BackgroundTransparency = 0.75,                BackgroundColor3 = Color3.new(1, 0, 0),                [OnEvent "MouseEnter"] = function()                    dropAction:set(listDropAction)                end,                [OnEvent "MouseLeave"] = function()                    -- A different item might have overwritten this already.                    if peek(dropAction) == listDropAction then                        dropAction:set(nil)                    end                end,                [Children] = {                    New "UIListLayout" {                        SortOrder = "Name",                        Padding = UDim.new(0, 5)                    }                }            }    end)local overlayFrame = scope:New "Frame" {    Size = UDim2.fromScale(1, 1),    ZIndex = 10,    BackgroundTransparency = 1}local currentlyDragging: Fusion.Value<DragInfo?> = scope:Value(nil)local allEntries = scope:ForValues(    todoItems,     function(use, scope, item)        local itemPosition = scope:Value(nil)        return scope:TodoEntry {            Item = item,            Parent = scope:Computed(function(use)                return                    if use(item.completed)                    then use(taskLists).completed                    else use(taskLists).incomplete            end),            Layout = {                Size = TODO_ITEM_SIZE,                OutAbsolutePosition = itemPosition            },            Dragging = {                MousePosition = mousePos,                SelfDragInfo = scope:Computed(function(use)                    local dragInfo = use(currentlyDragging)                    return                         if dragInfo == nil or dragInfo.id ~= item.id                        then nil                        else dragInfo                end)                OverlayFrame = overlayFrame            },            OnMouseDown = function()                if peek(currentlyDragging) == nil then                    local itemPos = peek(itemPosition) or Vector2.zero                    local mouseOffset = peek(mousePos) - itemPos                    currentlyDragging:set({                        id = item.id,                        mouseOffset = mouseOffset                    })                end            end        }    end)table.insert(scope,    UserInputService.InputEnded:Connect(function(inputObject)        if inputObject.UserInputType ~= Enum.UserInputType.MouseButton1 then            return        end        local dragInfo = peek(currentlyDragging)        if dragInfo == nil then            return        end        local item = getTodoItemForID(dragInfo.id)        local action = peek(dropAction)        if item ~= nil then            if action == "mark-as-incomplete" then                item.completed:set(false)            elseif action == "mark-as-completed" then                item.completed:set(true)            end        end        currentlyDragging:set(nil)    end))local ui = scope:New "ScreenGui" {    Parent = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")    [Children] = {        overlayFrame,        taskLists,        -- Don't pass `allEntries` in here - they manage their own parent!    }} `` |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

---

## Explanation[¶](https://elttob.uk/Fusion/0.3/examples/cookbook/drag-and-drop/#explanation "Permanent link")

The basic idea is to create a container which stores the UI you want to drag. This container then reparents itself as it gets dragged around between different containers.

The `Draggable` component implements everything necessary to make a seamlessly re-parentable container.

```
`type DragInfo = {
    id: string,
    mouseOffset: Vector2 -- relative to the dragged item
}

local function Draggable(
    scope: Fusion.Scope,
    props: {
        ID: string,
        Name: UsedAs<string>?,
        Parent: UsedAs<Instance?>,
        Layout: {
            LayoutOrder: UsedAs<number>?,
            Position: UsedAs<UDim2>?,
            AnchorPoint: UsedAs<Vector2>?,
            ZIndex: UsedAs<number>?,
            Size: UsedAs<UDim2>?,
            OutAbsolutePosition: Fusion.Value<Vector2>?,
        },
        Dragging: {
            MousePosition: UsedAs<Vector2>,
            SelfDragInfo: UsedAs<DragInfo?>,
            OverlayFrame: UsedAs<Instance?>
        }
        [typeof(Children)]: Fusion.Child
    }
): Fusion.Child
`
```

By default, `Draggable` behaves like a regular Frame, parenting itself to the `Parent` property and applying its `Layout` properties.

It only behaves specially when `Dragging.SelfDragInfo` is provided. Firstly, it reparents itself to `Dragging.OverlayFrame`, so it can be seen in front of other UI.

```
`        Parent = scope:Computed(function(use)
            return
                if use(props.Dragging.SelfDragInfo) ~= nil
                then use(props.Dragging.OverlayFrame)
                else use(props.Parent)
        end),
`
```

Because of this reparenting, `Draggable` has to do some extra work to keep the size consistent; it manually calculates the size based on the size of `Parent`, so it doesn't change size when moved to `Dragging.OverlayFrame`.

```
`        -- Calculated manually so the Scale can be set relative to
        -- `props.Parent` at all times, rather than the `Parent` of this Frame.
        Size = scope:Computed(function(use)
            local udim2 = use(props.Layout.Size) or UDim2.fromOffset(0, 0)
            local parentSize = use(parentSize) or Vector2.zero
            return UDim2.fromOffset(
                udim2.X.Scale * parentSize.X + udim2.X.Offset,
                udim2.Y.Scale * parentSize.Y + udim2.Y.Offset
            )
        end),
`
```

The `Draggable` also needs to snap to the mouse cursor, so it can be moved by the user. Ideally, the mouse would stay fixed in position relative to the `Draggable`, so there are no abrupt changes in the position of any elements.

As part of `Dragging.SelfDragInfo`, a `mouseOffset` is provided, which describes how far the mouse should stay from the top-left corner. So, when setting the position of the `Draggable`, that offset can be applied to keep the UI fixed in position relative to the mouse.

```
`        Position = scope:Computed(function(use)
            local dragInfo = use(props.Dragging.SelfDragInfo)
            if dragInfo == nil then
                return use(props.Layout.Position) or UDim2.fromOffset(0, 0)
            else
                local mousePos = use(props.Dragging.MousePosition)
                local topLeftCorner = mousePos - dragInfo.mouseOffset
                return UDim2.fromOffset(topLeftCorner.X, topLeftCorner.Y)
            end
        end),
`
```

This is all that's needed to make a generic container that can seamlessly move between distinct parts of the UI. The rest of the example demonstrates how this can be integrated into real world UI.

The example creates a list of `TodoItem` objects, each with a unique ID, text message, and completion status. Because we don't expect the ID or text to change, they're just constant values. However, the completion status *is* expected to change, so that's specified to be a `Value` object.

```
`type TodoItem = {
    id: string,
    text: string,
    completed: Fusion.Value<boolean>
}
local todoItems: Fusion.Value<TodoItem> = {
    {
        id = newUniqueID(),
        text = "Wake up today",
        completed = Value(true)
    },
    {
        id = newUniqueID(),
        text = "Read the Fusion docs",
        completed = Value(true)
    },
    {
        id = newUniqueID(),
        text = "Take over the universe",
        completed = Value(false)
    }
}
`
```

The `TodoEntry` component is meant to represent one individual `TodoItem`.

```
`local function TodoEntry(
    scope: Fusion.Scope,
    props: {
        Item: TodoItem,
        Parent: UsedAs<Instance?>,
        Layout: {
            LayoutOrder: UsedAs<number>?,
            Position: UsedAs<UDim2>?,
            AnchorPoint: UsedAs<Vector2>?,
            ZIndex: UsedAs<number>?,
            Size: UsedAs<UDim2>?,
            OutAbsolutePosition: Fusion.Value<Vector2>?,
        },
        Dragging: {
            MousePosition: UsedAs<Vector2>,
            SelfDragInfo: UsedAs<CurrentlyDragging?>,
            OverlayFrame: UsedAs<Instance>?
        },
        OnMouseDown: () -> ()?
    }
): Fusion.Child
`
```

Notice that it shares many of the same property groups as `Draggable` \- these can be passed directly through.

```
`    return scope:Draggable {
        ID = props.Item.id,
        Name = props.Item.text,
        Parent = props.Parent,
        Layout = props.Layout,
        Dragging = props.Dragging,
`
```

It also provides an `OnMouseDown` callback, which can be used to pick up the entry if the mouse is pressed down above the entry. Note the comment about why it is *not* desirable to detect mouse-up here; the UI should unconditionally respond to mouse-up, even if the mouse happens to briefly leave this element.

```
`            [OnEvent "MouseButton1Down"] = props.OnMouseDown

            -- Don't detect mouse up here, because in some rare cases, the event
            -- could be missed due to lag between the item's position and the
            -- cursor position.
`
```

Now, the destinations for these entries can be created. To help decide where to drop items later, the `dropAction` tracks which destination the mouse is hovered over.

```
`local dropAction = scope:Value(nil)

local taskLists = scope:ForPairs(
    {
        incomplete = "mark-as-incomplete",
        completed = "mark-as-completed"
    },
    function(use, scope, listName, listDropAction)
        return
            listName,
            scope:New "ScrollingFrame" {
                Name = `TaskList ({listName})`,
                Position = UDim2.fromScale(0.1, 0.1),
                Size = UDim2.fromScale(0.35, 0.9),

                BackgroundTransparency = 0.75,
                BackgroundColor3 = Color3.new(1, 0, 0),

                [OnEvent "MouseEnter"] = function()
                    dropAction:set(listDropAction)
                end,

                [OnEvent "MouseLeave"] = function()
                    -- A different item might have overwritten this already.
                    if peek(dropAction) == listDropAction then
                        dropAction:set(nil)
                    end
                end,

                [Children] = {
                    New "UIListLayout" {
                        SortOrder = "Name",
                        Padding = UDim.new(0, 5)
                    }
                }
            }
    end
)
`
```

This is also where the 'overlay frame' is created, which gives currently-dragged UI a dedicated layer above all other UI to freely move around.

```
`local overlayFrame = scope:New "Frame" {
    Size = UDim2.fromScale(1, 1),
    ZIndex = 10,
    BackgroundTransparency = 1
}
`
```

Finally, each `TodoItem` is created as a `TodoEntry`. Some state is also created to track which entry is being dragged at the moment.

```
`local currentlyDragging: Fusion.Value<DragInfo?> = scope:Value(nil)

local allEntries = scope:ForValues(
    todoItems,
    function(use, scope, item)
        local itemPosition = scope:Value(nil)
        return scope:TodoEntry {
            Item = item,
`
```

Each entry dynamically picks one of the two destinations based on its completion status.

```
`            Parent = scope:Computed(function(use)
                return
                    if use(item.completed)
                    then use(taskLists).completed
                    else use(taskLists).incomplete
            end),
`
```

It also provides the information needed by the `Draggable`.

Note that the current drag information is filtered from the `currentlyDragging` state so the `Draggable` won't see information about other entries being dragged.

```
`            Dragging = {
                MousePosition = mousePos,
                SelfDragInfo = scope:Computed(function(use)
                    local dragInfo = use(currentlyDragging)
                    return
                        if dragInfo == nil or dragInfo.id ~= item.id
                        then nil
                        else dragInfo
                end)
                OverlayFrame = overlayFrame
            },
`
```

Now it's time to handle starting and stopping the drag.

To begin the drag, this code makes use of the `OnMouseDown` callback. If nothing else is being dragged right now, the position of the mouse relative to the item is captured. Then, that `mouseOffset` and the `id` of the item are passed into the `currentlyDragging` state to indicate this entry is being dragged.

```
`            OnMouseDown = function()
                if peek(currentlyDragging) == nil then
                    local itemPos = peek(itemPosition) or Vector2.zero
                    local mouseOffset = peek(mousePos) - itemPos
                    currentlyDragging:set({
                        id = item.id,
                        mouseOffset = mouseOffset
                    })
                end
            end
`
```

To end the drag, a global `InputEnded` listener is created, which should reliably fire no matter where or when the event occurs.

If there's a `dropAction` to take, for example `mark-as-completed`, then that action is executed here.

In all cases, `currentlyDragging` is cleared, so the entry is no longer dragged.

```
`table.insert(scope,
    UserInputService.InputEnded:Connect(function(inputObject)
        if inputObject.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end
        local dragInfo = peek(currentlyDragging)
        if dragInfo == nil then
            return
        end
        local item = getTodoItemForID(dragInfo.id)
        local action = peek(dropAction)
        if item ~= nil then
            if action == "mark-as-incomplete" then
                item.completed:set(false)
            elseif action == "mark-as-completed" then
                item.completed:set(true)
            end
        end
        currentlyDragging:set(nil)
    end)
)
`
```

All that remains is to parent the task lists and overlay frames to a UI, so they can be seen. Because the `TodoEntry` component manages their own parent, this code shouldn't pass in `allEntries` as a child here.

```
`local ui = scope:New "ScreenGui" {
    Parent = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    [Children] = {
        overlayFrame,
        taskLists,
        -- Don't pass `allEntries` in here - they manage their own parent!
    }
}`
```

# API Reference[¶](https://elttob.uk/Fusion/0.3/api-reference/#api-reference "Permanent link")

Welcome to the API Reference! This is where you can find more technical documentation about what the Fusion library provides.

For a beginner-friendly experience, [try the tutorials.](https://elttob.uk/Fusion/0.3/tutorials/)

## Most Popular[¶](https://elttob.uk/Fusion/0.3/api-reference/#most-popular "Permanent link")

### General[¶](https://elttob.uk/Fusion/0.3/api-reference/#general "Permanent link")

[Errors](https://elttob.uk/Fusion/0.3/api-reference/general/errors)[Contextual](https://elttob.uk/Fusion/0.3/api-reference/general/members/contextual)[Safe](https://elttob.uk/Fusion/0.3/api-reference/general/members/safe)

### Memory[¶](https://elttob.uk/Fusion/0.3/api-reference/#memory "Permanent link")

[Scope](https://elttob.uk/Fusion/0.3/api-reference/memory/types/scope)[innerScope](https://elttob.uk/Fusion/0.3/api-reference/memory/members/innerscope)[doCleanup](https://elttob.uk/Fusion/0.3/api-reference/memory/members/docleanup)[scoped](https://elttob.uk/Fusion/0.3/api-reference/memory/members/scoped)

### Graph[¶](https://elttob.uk/Fusion/0.3/api-reference/#graph "Permanent link")

[Observer](https://elttob.uk/Fusion/0.3/api-reference/graph/members/observer)

### State[¶](https://elttob.uk/Fusion/0.3/api-reference/#state "Permanent link")

[UsedAs](https://elttob.uk/Fusion/0.3/api-reference/state/types/usedas)[Computed](https://elttob.uk/Fusion/0.3/api-reference/state/members/computed)[peek](https://elttob.uk/Fusion/0.3/api-reference/state/members/peek)[Value](https://elttob.uk/Fusion/0.3/api-reference/state/members/value)

### Animation[¶](https://elttob.uk/Fusion/0.3/api-reference/#animation "Permanent link")

[Spring](https://elttob.uk/Fusion/0.3/api-reference/animation/members/spring)[Tween](https://elttob.uk/Fusion/0.3/api-reference/animation/members/tween)

### Roblox[¶](https://elttob.uk/Fusion/0.3/api-reference/#roblox "Permanent link")

[Child](https://elttob.uk/Fusion/0.3/api-reference/roblox/types/child)[Children](https://elttob.uk/Fusion/0.3/api-reference/roblox/members/children)[Hydrate](https://elttob.uk/Fusion/0.3/api-reference/roblox/members/hydrate)[New](https://elttob.uk/Fusion/0.3/api-reference/roblox/members/new)
