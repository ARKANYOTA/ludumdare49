# Collision Lib (CL) (Beta Version, README out of date)

### Getting Started

First add the library to your project, in the example below the library has been put in our projects `lib/` folder. Then we required the library in `main.lua`.

```lua
CL = require "lib.CollisionLib"
```

### Available Functions

Keep in mind that all functions in CL require you to pass tables with the correct key value pairs. CL's functions **don't** take loose values as parameters.
The only exception is the "buffer" parameter, it takes a number value.

```lua
CL.pointPoint(point1, point2)
CL.pointRect(point, rectangle)
CL.pointCirc(point, circle)
CL.pointLine(point, line, buffer)
CL.circCirc(circle1, circle2)
CL.circRect(circle, rectangle)
CL.rectRect(rectangle1, rectangle2)
```

Points consist of: (x)-coordinate, and a (y)-coordinate.

```lua
point = {}
point.x = 10
point.y = 10
```

Rectangles consist of: (x)-coordinate, (y)-coordinate, (w)idth, and (h)eight.

```lua
rectangle = {}
rectangle.x = 10
rectangle.y = 10
rectangle.w = 10
rectangle.h = 10
```

Circles consist of: (x)-coordinate, (y)-coordinate, and (r)adius.

```lua
circle = {}
circle.x = 10
circle.y = 10
circle.r = 10
```

Line segments consist of: (x1)-coordinate, (y1)-coordinate, (x2)-coordinate, and (y2)-coordinate.

```lua
line = {}
line.x1 = 300
line.y1 = 100
line.x2 = 500
line.y2 = 400
```

### Support

Like these libraries?

Help me make more by [supporting me on Patreon](https://www.patreon.com/V3X3D) for as little as a dollar each month.

