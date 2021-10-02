# Camera Manager (CM)

### Load and Setup Camera

First add the library to your project, in the example below it has been put in our projects `lib/` folder. Then we required the library in `main.lua`.

```lua
Camera = require "lib.CameraMgr"
```

Once we have required the file (which should only ever be done once), then we can create a new camera manager, and start changing our cameras properties.

```lua
-- The 'newManager' function creates our camera manager that is pointed to by the variable 'CM'.
CM = Camera.newManager()
```

You can also do the above two snippets of code (the require and the function call) in one line.

```lua
CM = require "lib.CameraMgr".newManager()
```

### Update and Drawing with CM

To update CM, simply add it's update function into your `main.lua`'s update loop.

```lua
funciton love.update(dt)
  CM.update(dt)
end
```

The process for drawing is a bit different, you need to use the attach() and detach() functions of CM inside of `main.lua`'s draw loop. Whatever goes between these two functions will be affected by the camera logic.

```lua
function love.draw()
  CM.attach()

  -- Whatever is drawn between attach and detach
  -- will be influenced by the camera. Drawing
  -- outside of them will not be positioned relative
  -- to the camera.

  CM.detach()
end
```

Also, if you want to see the values that CM is using you can call it's debug() function inside if `main.lua`'s draw loop.

```lua
function love.draw()
  CM.debug()
end
```

### Configure the camera

All properties of the camera can be configured with the following functions. It is recommend to call these functions initially inside of `main.lua`'s load() function.

```lua
function love.load()
  CM.setScale(num)               -- Default of 1 (call before others)
  CM.setRotation(num)            -- Between 0 and 6.14
  CM.setLerp(num)                -- Between 0 and 1
  CM.setOffset(num)              -- Offset, works with posative and negative numbers

  CM.setBounds(x, y, w ,h)       -- Bounds of camera (not required)
  CM.unsetBounds()               -- Remove bounds
  CM.setDeadzone(x, y, w, h)     -- Deadzone starting from center screen
  CM.unsetDeadzone()             -- Remove deadzone

  CM.setTarget(x, y)             -- Camera moves to/toward target position
  CM.setCoords(x, y)             -- Hard position the camera to a point
end
```

### Get camera values

The following functions will return their respective set values.

```lua
CM.getCoords()
CM.getSize()
CM.getTarget()
CM.getBounds()
CM.getDeadzone()
CM.getScale()
CM.getRotation()
CM.getLerp()
CM.getOffset()
```

### Convert

Camera and world coordinates are not the same, easily convert between them with the following functions.

```lua
CM.toWorldCoords(x, y)
CM.toCameraCoords(x, y)
```

### Notes

Highly inspired by [STALKER-X](https://github.com/adnzzzzZ/STALKER-X), much of my code is modified directly from this camera library. I removed extra features and simplified some functionality. Also removed the oop style, as it generally isn't what I want.

### Support

Like these libraries?

Help me make more by [supporting me on Patreon](https://www.patreon.com/V3X3D) for as little as a dollar each month.
