# Input Manager (IM)

### Getting Started

First add the library to your project, in the example below it has been put in our projects `lib/` folder. Then we required the library in `main.lua`.

```lua
IM = require "lib.InputMgr"
```

Then at the end of your games love.update() loop add IM's reset function, without this it will not function correctly.

```lua
love.keyboard.resetInputStates()
```

### Taking input

IM just expands upon love2d's built in mouse and keyboard functions. With IM you can now check if the mouse/keyboard input was pressed or released.

Here are some example function calls.


```lua
if love.keyboard.isPressed("a") then
  print "\"a\" was pressed."
end

if love.keyboard.isReleased("a") then
  print "\"a\" was released."
end

if love.mouse.isPressed("left") then
  print "\"left\" was pressed."
end

if love.mouse.isReleased("left") then
  print "\"left\" was released."
end
```

Be sure these are called before IM's resetInputStates() is called, as mentioned above.

### Quality of life

Mouse codes can now be called by a string rather than a numeric code: "left" = 1; "right" = 2; "middle" = 3.

Currently this only works for the isPressed, and isReleased functions.

### Notes

This is a library in early development, expect many changes and additions. Also this library has only been tested on love 11.3 at the moment.

### Support

Like these libraries?

Help me make more by [supporting me on Patreon](https://www.patreon.com/V3X3D) for as little as a dollar each month.
