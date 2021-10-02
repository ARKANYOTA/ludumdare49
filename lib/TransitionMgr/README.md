# Transition Mananger (TM)

### Load a Transition

First add the library to your project, in the example below it has been put in our projects `lib/` folder. Then we required the library in `main.lua`.

```lua
Transition = require "lib.TransitionMgr"
```

Once we have required the file (which should only ever be done once), then we can create a new transition manager.

```lua
-- The 'newManager' function creates our transition manager that is pointed to by the variable 'TM'.
TM = Transition.newManager()
```

You can also do the above two snippets of code (the require and the function call) in one line.

```lua
TM = require "lib.TransitionMgr".newManager()
```

Now that we have a transition manger we can get started.

Transitions are .lua files stored in a directory. I'm storing mine in a folder called "transitions/". With TM the transition directory can be defined with TM.setPath(path).

```lua
TM.setPath("transitions/")
```

You can now create your first transition inside of that `transitions/` directory. Jump to the "Transition Files" section below for information on how to structure a transition.\

Once you have a transition file (in this case `fade-in.lua`) then you can load that file with TM.load(file, call, params). Note the .lua file extension should be omitted.

```lua
TM.load(
  "fade-in",         -- effect
  love.event.quit,   -- result
  0                  -- result params
)
```

TM.load() takes a transition file as it's first parameter. A function call (result) -- this will be what is called when the transition is over -- as the second parameter. For the final parameter it will take a single value or a table of values to be passed to the previous result function call.

In effect loading a transition starts the transition. That is true as long as we have the proper update and draw calls in our update and draw loops.

These are called with the respective TM.update(dt), and TM.draw() functions, as seen below.

```lua
function love.update(dt)
  -- Update the called transition
  TM.update(dt)
end

function love.draw()
  -- Draw the called transition
  TM.draw()
end
```

### Transition Files

Our file `fade-in.lua` needs to be defined in our previously set `transitions/` folder.\

An example of a template transition would look like this.

```lua
local transition = {}

-- Initalize local transition variables here

function transition.load()
  -- Load some values into variables
end

function transition.update(dt)
  -- If the condition is true then finish the transition with
  -- the resulting function call (second param in TM.load)
  if condition then
    TM.result(TM.params)
  end
end

function transition.draw()
end

return transition
```

transition.load() is called when we run TM.load(). Can set variable values.
transition.update(dt) is our transition update loop. Takes delta time (dt).
transition.draw() is our transition draw loop.

### Bonus

You can load a transition inside a transition.
Chaining transitions, not recommended but it does work.

```lua
TM.load(
  "slide-in",                       -- effect
  TM.load,                          -- result
  {"fade-in", love.event.quit, 0}   -- result params
)
```

### Summary

This pairs great with my scene managers, before a scene change you first would call TM.load() with the result function being the scene change call.

### Support

Like these libraries?

Help me make more by [supporting me on Patreon](https://www.patreon.com/V3X3D) for as little as a dollar each month.
