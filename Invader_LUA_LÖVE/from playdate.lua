-- Invader for Playdate
-- Started 7/6/2020
-- Brian Kumanchik

-- todo: fix random start for invader, game over, restart

-- import "CoreLibs/graphics"
-- import "CoreLibs/sprites"

-- -- Declaring "playdate.graphics", as just use "gfx."
-- local gfx <const> = playdate.graphics
-- -- Declaring "playdate.sound", as just use "snd."
-- local snd <const> = playdate.sound

-- -- misc variables
-- lb        = 16			-- left boundry
-- rb        = 400 - 50	-- right boundry	
-- score     = 0			-- starting score
-- lives     = 3			-- starting lives
-- pressed   = false		-- has fire button been pressed
-- game_over = false  		-- game over state

-- -- invader variables
-- inv_s      = 1			-- sprite frame
-- inv_x      = 200 - 16	-- invader starting x	
-- inv_y      = 40			-- invader starting y
-- inv_d      = 8  		-- invader delay
-- inv_dir    = 1			-- start direction		  
-- inv_exp_d  = 30			-- delay after exp..
-- inv_hit    = false		-- has invader been hit
-- inv_sx     = -30		-- starting invader shot x
-- inv_sy     = -30		-- starting invader shot y
-- inv_fire_d = 90			-- fire delay
-- inv_fired  = false		-- has invader fired

-- -- turret variables
-- tx           = 200 - 19	-- turret starting x
-- ty           = 185		-- turret starting y
-- t_shot_x     = -30 		-- turret shot x
-- t_shot_y     = -30 		-- turret shot y
-- t_fired      = false	-- has turret fired
-- t_exp_d      = 5 		-- tur exp anim delay
-- t_exp_s      = 1		-- exp start sprite 
-- times_played = 0 		-- play 4 times
-- turret_hit   = false	-- has turret been hit


function myGameSetUp()
	
	-- -- We want an environment displayed behind our sprite.
    -- local backgroundImage = gfx.image.new( "images/background.png" )
    -- assert( backgroundImage )
	
	-- -- Draw background
	-- gfx.sprite.setBackgroundDrawingCallback
	-- (
		-- function( x, y, width, height )
			-- gfx.setClipRect( x, y, width, height ) -- just draw what we need
			-- backgroundImage:draw( 0, 0 )
			-- gfx.clearClipRect()
		-- end
	-- )
	
	-- -- sounds
	-- pew_sound       = snd.sample.new("sounds/pew.wav")
	-- boom_sound      = snd.sample.new("sounds/boom.wav")
	-- explosion_sound = snd.sample.new("sounds/explosion.wav")

	-- font	
	font = gfx.font.new("images/font/Nontendo-Bold-2x")
	
	-- -- sprites -----------------------------------------------------------
	-- -- invader sprites
	-- invader_a = gfx.image.new("images/invader_a.png")
	-- invader_b = gfx.image.new("images/invader_b.png")
	-- blast     = gfx.image.new("images/blast.png")
	-- inv_shot  = gfx.image.new("images/inv_shot.png")

	-- -- Turret sprites
	-- turret    = gfx.image.new("images/turret.png")
	-- tur_exp_a = gfx.image.new("images/tur_exp_a.png")
	-- tur_exp_b = gfx.image.new("images/tur_exp_b.png")
	-- shot      = gfx.image.new("images/shot.png")
	
end


-- Call the function above to configure game.
myGameSetUp()


function playdate.update()
	if not game_over then 
		-- -- update all sprites every frame
		-- gfx.sprite.update()
		-- gfx.clearClipRect()	
		
		-- move_drop_inv()	
		-- move_turret()
		-- fire_turret()
		-- col_shot_inv() 
		col_inv_tur()	
		
		-- -- draw text, score and lives	
		-- gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
		-- --gfx.setFont(font)	
		-- --gfx.drawText("SCORE: ",12, 8)
		-- font:drawText("SCORE: ",12, 8)
		-- --gfx.drawText(score, 96, 8)
		-- font:drawText(score, 96, 8)
		-- --gfx.drawText("LIVES: ",300, 8)
		-- font:drawText(score, 96, 8)
		-- --gfx.drawText(lives, 376, 8)
		-- font:drawText(lives, 376, 8)		
		-- gfx.setImageDrawMode(gfx.kDrawModeCopy)
		
		-- -- draw sprites --	
		-- if not inv_hit then
			-- draw_inv()
			-- draw_inv_shot()
		-- end						  
		-- draw_inv_exp()		   		  
		-- draw_turret()
	end
	
	if game_over then		
		if playdate.buttonJustPressed("B") then				
			myGameSetUp()

			--misc game variables
			lb        		= 16			-- left boundry
			rb        		= 400 - 50		-- right boundry
			score     		= 0    			-- starting score
			lives     		= 3 			-- starting lives			
			times_played 	= 4				-- play 4 times 
			turret_hit		= false			-- has turret been hit
			game_over		= false			-- game over state
		end  
	end
end





-- functions *******************************************************************

-- --move turret
-- function move_turret()
	-- --don't move it if turret is exploding
	-- if not turret_hit then
		-- if playdate.buttonIsPressed("LEFT") then
			-- if tx >= lb +2 then
				-- tx -= 4
			-- end  
		-- elseif playdate.buttonIsPressed("RIGHT") then
			-- if tx <= rb -8 then
				-- tx += 4
			-- end
		-- end
	-- end 
-- end  	


-- --fire turret
-- function fire_turret() 	
	-- if playdate.buttonJustPressed("A") and not t_fired then			
		-- pew_sound:play(1)
		-- pressed = true
		-- t_fired = true
		-- t_shot_x = tx
		-- t_shot_y = ty
	-- end		
-- end	


-- --draw turret and shot
-- function draw_turret()
	-- if not turret_hit then
		-- turret:draw(tx,ty)		
		-- if(t_fired) then    
			-- shot:draw(t_shot_x,t_shot_y)			
			-- t_shot_y -= 8
			-- if t_shot_y < 36 then
				-- t_fired = false
				-- t_shot_y = 128
			-- end  
		-- end 		
	-- end
		
	-- if turret_hit then
		-- if t_exp_s == 1 then
			-- tur_exp_a:draw(tx,ty)
		-- end
		-- if t_exp_s == 2 then
			-- tur_exp_b:draw(tx,ty)
		-- end
	-- end
-- end  


-- --check collision invader shot with turret
-- function col_inv_tur()	
	-- if (inv_sx + 24 >= tx) and (inv_sx + 16 <= tx + 39) and (inv_sy + 21 == ty + 24) then
		-- explosion_sound:play(1)
		-- turret_hit = true 
		-- lives -= 1
		-- if lives == 0 then
			-- game_over = true	
			-- gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
			-- --gfx.setFont(font)	
			-- --gfx.drawText("GAME OVER",140, 113)
			-- font:drawText("GAME OVER",140, 113)
			-- gfx.setImageDrawMode(gfx.kDrawModeCopy)				 
		-- end			
	-- end

	-- --play turret explode anim
	-- if turret_hit then    
		-- t_exp_d -= 1
		-- if t_exp_d < 0 then
				-- t_exp_d = 5
				-- t_exp_s += 1
			-- if t_exp_s > 2 then
				-- t_exp_s = 1
			-- end 
			
			-- --play explode anim 3 times
			-- times_played += 1
			-- if times_played > 4 then
				-- turret_hit=false
				-- times_played = 0
			-- end    
		-- end      
	-- end  
-- end


-- --move and drop invader 
-- function move_drop_inv()		  		
	-- inv_d -= 1
	-- if inv_d < 0 then
		-- inv_d = 8		  
		-- if inv_dir == 1 then
			-- inv_x += 4
		-- else
			-- inv_x -= 4
		-- end 

		-- if inv_x > rb -6 then	
			-- inv_dir = 0	 		      
			-- inv_y += 8 		      	   		      
		-- end

		-- if inv_x < lb +2 then       
			-- inv_y += 8       
			-- inv_x += 2
			-- inv_dir = 1
		-- end  

		-- inv_s += 1
		-- if inv_s > 2 then
			-- inv_s = 1
		-- end		  
	-- end 
-- end


-- --draw invader
-- function draw_inv() 		
	-- if inv_s == 1 then
		-- invader_a:draw(inv_x,inv_y)
	-- end
	-- if inv_s == 2 then
		-- invader_b:draw(inv_x,inv_y)
	-- end	
-- end 


-- --draw invader shot 
-- function draw_inv_shot()				
	-- if not invader_fired then 
		-- inv_sx=inv_x - 4
		-- inv_sy=inv_y + 20
		-- invader_fired=true			  
	-- end

	-- inv_sy += 8
	-- inv_fire_d -= 1
	-- if inv_fire_d < 0 then
		-- inv_fire_d = 90
		-- invader_fired=false
	-- end

	-- if invader_fired then
		-- if inv_sy < (205) then
			-- --draw inv shot
			-- inv_shot:draw(inv_sx, inv_sy)				
		-- end
	-- end  
-- end


-- --check turret shot collision with invader
-- function col_shot_inv()
	-- if (t_shot_x + 21 >= inv_x) and (t_shot_x + 19 <= inv_x + 33) and (t_shot_y + 10 == inv_y + 27) then		
		-- boom_sound:play(1)
		-- t_fired = false
		-- inv_hit = true
		-- t_shot_y = 240
		-- inv_exp_x = inv_x
		-- inv_exp_y = inv_y
		-- inv_x =- 30
		-- inv_y =- 30   
		-- score += 10		
	-- end

	-- --if hit pause to display explosion
	-- if inv_hit then 
		-- inv_exp_d -= 1
		-- if inv_exp_d < 0 then		    
			-- t_fired = false
			-- inv_hit = false		    
			-- inv_exp_d = 30		   
			-- --rnd 20 pix each side
			-- --inv_x_pos = (math.random(5))
			-- --inv_x
			-- inv_x = 200 - 16	-- invader starting x
			-- inv_y = 40 			-- invader starting y			 
		-- end
	-- end  
-- end


-- --draw invader explosion
-- function draw_inv_exp()
  -- if inv_hit then    
	-- blast:draw(inv_exp_x, inv_exp_y)
  -- end
-- end




