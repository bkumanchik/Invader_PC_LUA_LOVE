-- Alt+L to run code



function love.load()
    wf = require 'libraries/windfield'
	
	world = wf.newWorld(0, 0, true)
    world:setGravity(0, 512)
	
	--box = world:newRectangleCollider(400 - 50/2, 0, 50, 50)
    circle = world:newCircleCollider(400 - 50/2, 0, 50)
    --box:setRestitution(0.8)
    circle:setRestitution(0.6)
    --box:applyAngularImpulse(5000)
    circle:applyAngularImpulse(5000)

    ground = world:newRectangleCollider(0, 550, 800, 50)
    wall_left = world:newRectangleCollider(0, 0, 50, 600)
    wall_right = world:newRectangleCollider(750, 0, 50, 600)
    ground:setType('static') -- Types can be 'static', 'dynamic' or 'kinematic'. Defaults to 'dynamic'
    wall_left:setType('static')
    wall_right:setType('static')
end



function love.update(dt) -- dt = delta time (60fps)
	world:update(dt)
end



function love.draw()
	world:draw() -- The world can be drawn for debugging purposes
end

