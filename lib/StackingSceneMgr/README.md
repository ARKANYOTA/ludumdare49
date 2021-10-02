# Stacking Scene Manager (SSM)

### Getting Started

First add the library to your project, in the example below it has been put in our projects `lib/` folder. Then we required the library in `main.lua`.

```lua
StackingScene = require "lib.StackingSceneMgr"
```

Once we have required the file (which should only ever be done once), then we can create a new scene manager, and setup our scenes.

```lua
-- The 'newManager' function creates our scene manager that is pointed to by the variable 'SSM'.
SSM = StackingScene.newManager()
```

You can also do the above two snippets of code (the require and the function call) in one line.

```lua
SSM = require "lib.StackingSceneMgr".newManager()
```

Now that we have a scene manger we can get started.

Scenes are just .lua files, so they need a folder to be stored in. In the example below a folder called `scenes/` has been created. We tell SSM to set the path to our `scenes/` folder.

```lua
SSM.setPath("scenes/")
```

You can now create your first scene inside of the `scenes/` directory.

### Making a scene file

A scene file must contain a table that you attach your scenes functions to. This table gets returned and is effectively your scene.

This table requires a load() function, a update() function, and a draw() function.

Below is an example scene file.

```lua
local scene = {}

function scene.load()
end

function scene.update(dt)
end

function scene.draw()
end

return scene
```

SSM uses the update() function when calling SSM.update(dt) in `main.lua`'s update loop. The same goes for draw(). load() is called whenever a scene is added to SSM's scene table.

### Adding and running your scene.

Once you have a scene file and your path set you can add the file to SSM's scene table with the add() function. It takes one parameter that being the scenes name without the extension. It is recommended to add your first scene in `main.lua`'s load() function.

```lua
function love.load()
  SSM.add("intro")
end
```

Once our scene is added we can now update and draw it, this is simple enough, just call the update() and draw() function of SSM inside of our `main.lua`'s update and draw functions.


```lua
function love.update(dt)
  SSM.update(dt)
end

function love.draw()
  SSM.draw()
end
```

### Removing a scene, and purging a scene

SSM contains the notion of scene removal and scene purging, lets look at the former first.

Scene removal is simply taking a scene out of SSM's scene table, thus it will no longer be updating or rendering.

```lua
SSM.remove("intro")
```

Scene purging also does this, but takes it a step further buy garbage collecting the scenes state.

```lua
SSM.purge("intro")
```

You can also call removeAll(), and purgeAll() to target all scenes with these commands.

### Freeze

Lets say you have an "inventory" scene that you want to open on top of your "game" scene. This can be done by simply adding the "inventory" scene while the game scene is already in the scene table.

However the "game" scene will keep running in the background while the "inventory" is open. To prevent this you can use the setFrozen() function. It takes two parameters a scene name, and a boolean, in that order. The below example would freeze our intro scene.

```lua
SSM.setFrozen("intro", true)
```

You can also check if a scene is frozen by calling isFrozen(). The below example will now return true.

```lua
SSM.isFrozen("intro")
```

### Modify

If you want to get some fine grain control over particular state in your scene you can always use a scenes modify() function. I neglected to mention this earlier in the "Making a scene file" section, but each scene can have a modify function.

```lua
function scene.modify(flags)
end
```

The scenes modify() function takes a table as it's parameter with key value pairs. These key value pairs are references to the scenes local state. They are are then used in a scenes modify function however the developer chooses.

This is way less complex than it sounds, checkout my `scenes/inventory.lua` example that is included with this library.

Keep in mind, when you use SSM to call modify a scene must be specified before the flags parameter, the above example was showing how to define the function inside of your scene. The below example is showing how to call the scene "intro"'s modify() function with SM.

```lua
SSM.modify("intro", {x = 10, y = 20})
```

### Notes

Some of the function names used in this library are subject to change. Particularly the ones involving freezing a scene.

### Support

Like these libraries?

Help me make more by [supporting me on Patreon](https://www.patreon.com/V3X3D) for as little as a dollar each month.
