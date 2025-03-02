local wf = require "windfield"

function love.load()
    -- Window properties
    love.window.setTitle("Wish Upon A Star - By: AAOOII-RN")

    -- Physics World
    World = wf.newWorld()
    World:setGravity(0, 640)

    --forming a star
    ax, ay = calculate_point(0)
    bx, by = calculate_point(1)
    cx, cy = calculate_point(2)
    dx, dy = calculate_point(3)
    ex, ey = calculate_point(4)

    vertices = {
        ax,ay,
        cx,cy,
        ex,ey,
        bx, by,
        dx, dy,
    }    
    --x = 0
    --y = 0
    n = -180 -- star's revolution
    ww, wh = love.graphics.getDimensions() -- window size

    Ground = World:newRectangleCollider(0, wh-40, ww, 40)
    Ground:setType("static")

    Ball = World:newCircleCollider(ww/2, wh/2, 20)
    Ball:setRestitution(1)
end

function calculate_point(m) -- determines the points of a star
    local radius = 15
    local angle_between_points = 72
    local initial_angle = 90

    local initial_radian_angle = initial_angle / 180 * math.pi
    local current_radian_rotation = angle_between_points / 180 * math.pi * m
    local x = radius * math.cos(initial_radian_angle + current_radian_rotation)
    local y = radius * math.sin(initial_radian_angle + current_radian_rotation)
    return x, y
end

function love.update(dt)
    World:update(dt)
    local speed = 10
    n = n + 36 * dt
end

function love.draw()
    World:draw()
    --star
    love.graphics.setBackgroundColor(4/255, 26/255, 64/255)
    love.graphics.setColor(255/255, 255/255, 127.5/255)
    love.graphics.push()
    love.graphics.translate(0, wh*2) -- center point of rotation
    love.graphics.rotate(n/180*math.pi)
    love.graphics.translate(0, -wh-500)
    love.graphics.rotate(n*2)
    love.graphics.polygon("line", vertices)
    love.graphics.pop()

    -- grass
    love.graphics.setColor(0, 127.5/255, 0)
    love.graphics.rectangle("fill", 0, wh, ww, -40)

    -- dirt
    love.graphics.setColor(75/250, 37.5/250, 0)
    love.graphics.rectangle("fill", 0, wh, ww, -15)
end