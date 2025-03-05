local wf = require "libraries.windfield"
local utf8 = require "utf8"

function love.load()
    -- Window properties
    love.window.setTitle("Wish Upon A Star - By: AAOOII-RN")

    -- font
    font = love.graphics.newFont("Poppins.ttf")
    love.graphics.setFont(font)

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
    ww, wh = love.graphics.getDimensions() -- window size

    -- Barriers
    Ground = World:newRectangleCollider(0, wh-40, ww, 40)
    Ground:setType("static")

    Left_Wall = World:newRectangleCollider(-30, 0, 30, wh)
    Left_Wall:setType("static")

    Right_Wall = World:newRectangleCollider(ww, 0, 30, wh)
    Right_Wall:setType("static")

    Roof = World:newRectangleCollider(0, -40, ww, 30)
    Roof:setType("static")

    n = 90 -- star's revolution

    input_text = ""

    cv = {} --Circles' sizes
    sv = {} --Squares' sizes

    circle_group = {}
    square_group = {}

    show_txtBox = false

    shrugger = false
end

function love.textinput(t)
    if show_txtBox then
        input_text = input_text .. t
    end
end

function love.keypressed(key)
    if show_txtBox then
        if key == "backspace" then
            local byteoffset = utf8.offset(input_text, -1)
    
            if byteoffset then
                input_text = string.sub(input_text, 1, byteoffset - font:getWidth(input_text))
            end
        end
    
        if key == "return" then
            checkWish()
        end
    end
end

-- Star point calculation
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

function checkWish() -- checks wish obv
    local wish = string.lower(input_text)
    
    if wish == "circle" then
        isCircle()
    elseif wish == "square" then
        isSquare()
    else
        shrug()
    end
end

function isCircle() -- If the wish is circle, create a cricle
    local r = math.random(10, 20)
    local x = math.random(0, ww-r)
    local y = math.random(0, wh-50)

    table.insert(cv, r)
    table.insert(circle_group, World:newCircleCollider(x, y, r))
end

function isSquare() -- If the wish is square, create a square
    local s = math.random(20, 40)
    local x = math.random(0, ww-s)
    local y = math.random(0, wh-60)

    table.insert(sv, s)
    table.insert(square_group, World:newRectangleCollider(x, y, s, s))
end

function shrug()
    shrugger = true
end

function love.update(dt)
    World:update(dt)
    local speed = 10
    m = n/180*math.pi
    n = math.fmod(n, 360) + 36 * dt

    if #circle_group > 0 then
        if math.random(1, 100) == 27 then
            circle_group[math.random(1, #circle_group)]:applyForce(math.random(-640*50, 640*50), -640*50)
        end
    end

    if #square_group > 0 then
        if math.random(1, 100) == 27 then
            square_group[math.random(1, #square_group)]:applyForce(math.random(-640*50, 640*50), -640*50)
        end
    end

    show_txtBox = false
    if n > 0 and n < 45 then
        show_txtBox = true
    else
        shrugger = false
    end
end

function love.draw()
    -- star
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

    -- draw cricle
    love.graphics.setColor(1, 0, 0)
    for i, v in ipairs(cv) do
        love.graphics.circle("fill", circle_group[i]:getX(), circle_group[i]:getY(), cv[i])
        circle_group[i]:setRestitution(1)
    end

    -- draw square
    love.graphics.setColor(0, 0, 1)
    for i, v in ipairs(sv) do
        love.graphics.rectangle("fill", square_group[i]:getX()-sv[i]/2, square_group[i]:getY()-sv[i]/2, sv[i], sv[i])
        square_group[i]:setFixedRotation(true)
        square_group[i]:setRestitution(1)
    end

    -- input
    if show_txtBox then
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", (ww/2-font:getWidth(input_text)/2)-10, wh/2, font:getWidth(input_text)+20, font:getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(input_text, ww/2-font:getWidth(input_text)/2, wh/2)
        local say_this = "Type your wish then enter it quick!"
        love.graphics.print(say_this, ww/2-font:getWidth(say_this)/2, (wh/2)-50)
        if shrugger then
            local say_this2 = "Lol can't do that ¯\\_(o v o)_/¯"
            love.graphics.print(say_this2, ww/2-font:getWidth(say_this2)/2, (wh/2)+50)
        end
    end
end