-- Invader for PC with Lua using LÖVE library
-- Started 8/23/2021
-- Brian Kumanchik


-- init function
function love.load()
	love.window.setMode(512, 512, {resizable=false})		
	
	-- misc variables
	lb        = 32			-- left boundry
	rb        = 512 - 66	-- right boundry	
	score     = 0			-- starting score
	lives     = 3			-- starting lives
	--pressed   = false		-- has fire button been pressed
	game_over = false  		-- game over state
	
	-- invader variables
	inv_s      = 1			-- sprite frame
	inv_x      = 256 - 16	-- invader starting x	
	inv_y      = 60			-- invader starting y
	inv_d      = 15  		-- invader delay
	inv_dir    = 1			-- start direction		  
	inv_exp_d  = 30			-- delay after exp..
	inv_hit    = false		-- has invader been hit
	inv_sx     = -30		-- starting invader shot x
	inv_sy     = -30		-- starting invader shot y
	inv_fire_d = 120		-- fire delay
	inv_fired  = false		-- has invader fired

	-- turret variables
	tx           	= 256 - 19	-- turret starting x
	ty           	= 425		-- turret starting y
	t_shot_x     	= -30 		-- turret shot x
	t_shot_y     	= -30 		-- turret shot y
	t_fired      	= false		-- has turret fired
	t_exp_d      	= 10 		-- tur exp anim delay
	t_exp_s      	= 1			-- exp start sprite 
	times_played 	= 0 		-- play 4 times
	turret_hit   	= false		-- has turret hit (used for anim count reset)
	turret_been_hit	= false		-- has turret been hit	
	
	-- sprites -----------------------------------------------------------
	-- invader sprites
	invader_a = love.graphics.newImage("images/invader_a.png")	
	invader_b = love.graphics.newImage("images/invader_b.png")
	blast     = love.graphics.newImage("images/blast.png")
	inv_shot  = love.graphics.newImage("images/inv_shot.png")
	
	-- Turret sprites
	turret    = love.graphics.newImage("images/turret.png")
	tur_exp_a = love.graphics.newImage("images/tur_exp_a.png")
	tur_exp_b = love.graphics.newImage("images/tur_exp_b.png")
	shot      = love.graphics.newImage("images/shot.png")	

	pew_sound       = love.audio.newSource("sounds/pew.wav", "static")
	boom_sound      = love.audio.newSource("sounds/boom.wav", "static")
	explosion_sound = love.audio.newSource("sounds/explosion.wav", "static")
	
	font = love.graphics.setNewFont("fonts/C64_Pro_Mono-STYLE.ttf", 16 )
end


-- update function
function love.update()
	if not game_over then 		
		move_drop_inv()	
		move_turret()
		fire_turret()
		col_shot_inv() 
		col_inv_tur()			
	end
	
	if game_over then
		function love.joystickpressed( joystick, button )
			b_pressed = button
		end
		-- if button 8 (start button)
		if b_pressed == 8 then
			button_8_pressed = true
			b_pressed = false -- reset button_8 pressed			
			
			-- init function to reset game settings
			love.load()			
		else
			button_8_pressed = false
		end
	end	
end


-- draw function
function love.draw()
	if not game_over then 		
		-- draw text, score and lives		
		love.graphics.print("SCORE:", 20, 20)
		love.graphics.print(score, 117, 20)		
		love.graphics.print("LIVES:", 380, 20)
		love.graphics.print(lives, 477, 20)		
				
		-- draw sprites --	
		if not inv_hit then			
			draw_inv()			
			draw_inv_shot()
		end						  
		draw_inv_exp()		   		  
		draw_turret()				
	end
	
	
	if game_over then
		-- draw text, score and lives and GAME OVER		
		love.graphics.print("SCORE:", 20, 20)
		love.graphics.print(score, 117, 20)		
		love.graphics.print("LIVES:", 380, 20)
		love.graphics.print(lives, 477, 20)			
		love.graphics.print("GAME OVER", 183, 250)

		-- draw sprites --	
		draw_inv()			
		--draw_inv_shot()	
		love.graphics.draw(inv_shot, inv_sx, inv_sy)
		draw_turret()	
	end
end





-- my functions *******************************************************************

--move turret
function move_turret()
	--don't move it if turret is exploding
	if not turret_hit then		
		-- check joystick (hat - not dpad, see Pi version) 
		function love.joystickhat( joystick, hat, direction )
			dir = direction
		end
		-- if d-pad left or left up or left down
		if dir == "l" or dir == "lu" or dir == "ld" then
			if tx >= lb + 2 then
				tx = tx - 4
			end  		
		-- if d-pad right or right u or right down
		elseif dir == "r" or dir == "ru" or dir == "rd" then		
			if tx <= rb - 8 then
				tx = tx + 4
			end
		end		
	end 
end  	


function fire_turret()
	-- check joystick buttons
	function love.joystickpressed( joystick, button )
		b_pressed = button
	end
	-- if button 1
	if b_pressed == 1 then
		button_1_pressed = true
		b_pressed = false -- reset button_1 pressed
	else
		button_1_pressed = false
	end
	
	if button_1_pressed then
		button_1_pressed = false
		love.audio.play( pew_sound )		
		t_fired = true
		t_shot_x = tx
		t_shot_y = ty
	end	
end


--draw turret and shot
function draw_turret()
	if not turret_hit then		
		love.graphics.draw(turret, tx, ty)		
		if(t_fired) then  			
			love.graphics.draw(shot, t_shot_x, t_shot_y)
			t_shot_y = t_shot_y - 8
			if t_shot_y < 55 then
				t_fired = false
				t_shot_y = 128
			end  
		end 		
	end
		
	if turret_hit then
		if t_exp_s == 1 then			
			love.graphics.draw(tur_exp_a, tx, ty)
		end
		if t_exp_s == 2 then			
			love.graphics.draw(tur_exp_b, tx, ty)
		end
	end
end  


--check collision invader shot with turret
function col_inv_tur()	
	if not turret_been_hit and (inv_sx + 24 >= tx) and (inv_sx + 16 <= tx + 39) and (inv_sy + 21 >= ty + 24) then	
		turret_been_hit = true
		love.audio.play( explosion_sound )		
		turret_hit = true 
		lives = lives - 1
		if lives == 0 then
			game_over = true									 
		end			
	end

	--play turret explode anim
	if turret_hit then    
		t_exp_d = t_exp_d -1
		if t_exp_d < 0 then
				t_exp_d = 10
				t_exp_s = t_exp_s + 1
			if t_exp_s > 2 then
				t_exp_s = 1
			end 
			
			--play explode anim 3 times
			times_played = times_played + 1
			if times_played > 5 then
				turret_hit = false
				turret_been_hit = false
				times_played = 0
			end    
		end      
	end  
end


--move, animate and drop invader 
function move_drop_inv()		  		
	inv_d = inv_d - 1
	if inv_d < 0 then
		inv_d = 15		  
		if inv_dir == 1 then
			inv_x = inv_x + 4
		else
			inv_x = inv_x - 4
		end 

		if inv_x > rb -6 then	
			inv_dir = 0	 		      
			inv_y = inv_y + 8 		      	   		      
		end

		if inv_x < lb +2 then       
			inv_y = inv_y + 8       
			inv_x = inv_x + 2
			inv_dir = 1
		end  

		inv_s = inv_s + 1
		if inv_s > 2 then
			inv_s = 1
		end		  
	end 
end


--draw invader
function draw_inv() 		
	if inv_s == 1 then		
		love.graphics.draw(invader_a, inv_x, inv_y)
	end
	if inv_s == 2 then		
		love.graphics.draw(invader_b, inv_x, inv_y)
	end	
end 


--draw invader shot 
function draw_inv_shot()				
	if not invader_fired and not game_over then 
		inv_sx = inv_x - 4
		inv_sy = inv_y + 20
		invader_fired=true			  
	end

	inv_sy = inv_sy + 8
	inv_fire_d = inv_fire_d - 1
	if inv_fire_d < 0 then
		inv_fire_d = 120		
		invader_fired = false		
	end

	if invader_fired then
		if inv_sy < (445) then
			--draw inv shot			
			love.graphics.draw(inv_shot, inv_sx, inv_sy)
		elseif inv_sy > (445) then
			inv_sx = -30
			inv_sy = -30			
		end
	end  
end


--check turret shot collision with invader
function col_shot_inv()
	if (t_shot_x + 21 >= inv_x) and (t_shot_x + 19 <= inv_x + 33) and (t_shot_y + 10 <= inv_y + 28) then	
		love.audio.play( boom_sound )
		t_fired = false
		inv_hit = true
		t_shot_y = 240 -------------
		inv_exp_x = inv_x
		inv_exp_y = inv_y
		inv_x = -30
		inv_y = -30   
		score = score + 10		
	end

	--if hit pause to display explosion
	if inv_hit then 
		inv_exp_d = inv_exp_d - 1
		if inv_exp_d < 0 then		    
			t_fired = false
			inv_hit = false		    
			inv_exp_d = 30		   
			inv_x = love.math.random( 32, 446 ) -- invader random x
			inv_y = 60       					-- invader starting y 					 
		end
	end  
end


--draw invader explosion
function draw_inv_exp()
  if inv_hit then    	
	love.graphics.draw(blast, inv_exp_x, inv_exp_y)
  end
end