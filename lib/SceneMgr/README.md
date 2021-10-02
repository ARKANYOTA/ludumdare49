# Scene Manager (SM)

### Getting Started

First add the library to your project, in the example below it has been put in our projects `lib/` folder. Then we required the library in `main.lua`.

```lua
SM = require "lib.SceneMgr"
```

Scenes are just .lua files, so they need a folder to be stored in. In the example below a folder called `scenes/` has been created. We tell SM to set the path to our `scenes/` folder.

```lua
SM.setPath("scenes/")
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

SM uses the update() function when calling SM.update(dt) in `main.lua`'s update loop. The same goes for draw(). load() is called whenever a scene is loaded.

### Loading and running your scene

Once you have a scene file and your path set you can load the file with the load() function. The load funciton takes a string of the scenes name, don't include the extension. It is recommended to load your first scene in `main.lua`'s load() function.

```lua
function love.load()
  SM.load("intro")
end
```

Once our scene is loaded we can now update and draw it, this is simple enough, just call the update() and draw() function of SM inside of our `main.lua`'s update and draw functions.


```lua
function love.update(dt)
  SM.update(dt)
end

function love.draw()
  SM.draw()
end
```

### Unloading a scene

SM contains the notion of unloading a scene, this will unload the scenes state meaning the next time you load it the scene will be "restarted" so to speak.

If you never unload a scene then whenever the scene gets loaded it will have whatever changes occurred when it was previously loaded.

### Modify

If you want to get some fine grain control over particular state in your scene you can always use a scenes modify() function. I neglected to mention this earlier in the "Making a scene file" section, but each scene can have a modify function.

```lua
function scene.modify(flags)
end
```

The scenes modify() function takes a table as it's parameter with key value pairs. These key value pairs are references to the scenes local state. They are are then used in a scenes modify function however the developer chooses.

This is way less complex than it sounds, checkout my `scenes/title.lua` example that is included with this library.

Keep in mind, when you use SM to call modify a scene must be specified before the flags parameter, the above example was showing how to define the function inside of your scene. The below example is showing how to call the scene "intro"'s modify() function with SM.

```lua
SM.modify("intro", {x = 10, y = 20})
```

### Notes

This has been deprecated for StackingSceneMgr, a new and improved scene manager. I will however fix bugs with SM as they show up.

SM is fully functional so don't be afraid to use if it fits your needs.

### Support

Like these libraries?

Help me make more by [supporting me on Patreon](https://www.patreon.com/V3X3D) for as little as a dollar each month.
