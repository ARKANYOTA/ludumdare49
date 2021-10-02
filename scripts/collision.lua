-- vim: fdm=marker

function collision(x1,y1,w1,h1,x2,y2,w2,h2) -- si collision entre deux objets, return true --{{{2
    return (x1+w1 > x2 and x1 < x2 + w2 and
       y1 < y2 + h2 and y1 + h1 > y2)
end

function draw_collision(x,y,w,h)--{{{2
    love.graphics.rectangle("line",x,y,w,h)
end

