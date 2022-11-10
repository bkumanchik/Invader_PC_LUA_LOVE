-- Alt+L to run code



function love.load()
    sti = require 'libraries/sti' -- Simple-Tiled-Implementation (sti) library
    anim8 = require 'libraries/anim8' -- anim8 library
    windfield = require 'libraries/windfield'
    gameMap = sti('maps/testMap.lua') -- my map created with "Tiled" and exported as .lua file
    love.graphics.setDefaultFilter("nearest", "nearest") -- stops filtering (bluring) of scaled-up sprite   

    player = {}
    player.x = 164
    player.y = 200
    player.speed = 2  
    player.spriteSheet = love.graphics.newImage('sprites/player-sheet.png') -- loads sprite sheet 
    -- setup for sprite sheet (x sprite size, y sprite size, sprite sheet width, sprite sheet height)
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight()) -- (w = 48, h = 72)

    player.animations = {} -- table for individual player sprite animations 
--                                  (4 frames - columns 1 to 4, row mumber, playback delay per frame)                                             
    player.animations.left  = anim8.newAnimation(player.grid('1-4', 2), 0.2)
    player.animations.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
    player.animations.up    = anim8.newAnimation(player.grid('1-4', 4), 0.2)
    player.animations.down  = anim8.newAnimation(player.grid('1-4', 1), 0.2)

    player.anim = player.animations.down -- default animation frame
end



function love.update(dt) -- dt = delta time (60fps)
    local isMoving = false                      -- default to not moving

    if love.keyboard.isDown("left") then        -- if left pressed...
        player.x = player.x - player.speed      -- move player left...
        player.anim = player.animations.left    -- set walk left animation
        isMoving = true                         -- and isMoving to true
    end
    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed
        player.anim = player.animations.right
        isMoving = true
    end       
    if love.keyboard.isDown("up") then
        player.y = player.y - player.speed
        player.anim = player.animations.up
        isMoving = true
    end    
    if love.keyboard.isDown("down") then
        player.y = player.y + player.speed
        player.anim = player.animations.down
        isMoving = true
    end      

    if isMoving == false then                   -- if not moving use default animation frame (2)
        player.anim:gotoFrame(2)
    end

    player.anim:update(dt)                      -- update animation 
end



function love.draw()
    gameMap:draw() -- draw "Tiled" map
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, 4, 4) -- draw player sprite (from sheet)  
end

