

require("player")
require("ball")
require("ai")
planets_x = 0.0



function love.load()
    universe = love.graphics.newImage("assets/universe.png")
    planets = love.graphics.newImage("assets/planets.png")
    Player:load()
    Ball:load()
    AI:load()
end


function love.update(dt)
    Player:update(dt)
    Ball:update(dt)
    AI:update(dt)
    planets_x = planets_x + .1
end

function love.draw()
    love.graphics.draw(universe, 0, 0)
    love.graphics.draw(planets, planets_x, 0)
    Player:draw()
    Ball:draw()
    AI:draw()
end


function checkCollision(a, b)
    if a.x + a.width > b.x and a.x <b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height then
        return true
    else
        return false
    end
end
