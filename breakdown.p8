pico-8 cartridge // http://www.pico-8.com
version 43
__lua__


function _init()
	paddle_init() -- paddle init
	ball_init() -- ball init
	bricks_init() -- brick init
	 
end

function _update()
	paddle_update(paddle) -- paddle update
	ball_update(ball) -- ball update
	brick_update()
end

function _draw()
	cls()
	
	paddle_draw(paddle) -- draw paddle
	ball_draw(ball) -- draw ball
	brick_draw(bricks_layout) -- draw bricks
	print(paddle.middle)
	print(paddle_right)
	print(paddle_left)

end

-->8
-- paddle --


function paddle_init()

	paddle = {
		x=0,
		y=110,
		middle = 4, -- 8 pixel long,half is 4
		sprite = 16,
		h = 2,
		w = 8
	}
	
end

function paddle_update(paddle)
	
	-- paddle only moves on x axis 
	paddle.x=stat(32) -- x
	
	-- allows mouse to work
	poke(0x5f2d,1)
	
	-- update the paddle collitions
		paddle.middle = flr((paddle.x + paddle.w) / 2)
		paddle_right = flr(paddle.x + paddle.w)
		paddle_left = flr(paddle.x)	
	
	-- functions --  

	
	
end

function paddle_draw(paddle)
	
	-- draw the paddle 
	spr(paddle.sprite,paddle.x,paddle.y,1,1)
	
end


-->8
-- ball -- 

function ball_init()
	ball = {
		x=30,
		y=30,
		vel_x = 0,
		vel_y = 1,
		speed = 1,
		max_speed = 10,
		sprite = 1,
		h=4,
		w=6
	
	}
	
	
end


function ball_update(ball)
	
	ball_fall(ball)
	bounce(ball,paddle) -- bounce ball
	
end

function ball_draw(ball)
	spr(ball.sprite,ball.x,ball.y,1,1)
end
-->8
-- collition & bouncing  -- 

function ball_fall(b)
	-- fall by defualt 
	
	b.x += b.vel_x
 b.y += b.vel_y
 
 


end -- function

function wall_bounce(b)

		-- bounce off left wall
    if b.x < 0 then
        b.x = 0
        b.vel_x = -b.vel_x
    end

    -- bounce off right wall
    if b.x + b.w > 128 then
        b.x = 128 - b.w
        b.vel_x = -b.vel_x
    end

    -- bounce off top wall
    if b.y < 0 then
        b.y = 0
        b.vel_y = -b.vel_y
    end

    -- bottom wall (optional: lose life or reset)
    if b.y > 128 then
 					
 					-- end game --   
	    
    end
end


-- bounce ball on contact

function bounce(ball, paddle)

		wall_bounce(ball) -- wall bounce
		
				
	 if collition(ball, paddle) then
     
    local offset = (ball.x - paddle.middle)/(paddle.w/2)
  
    ball.vel_y = -ball.vel_y
    ball.vel_x = ball.speed * offset
  
  end -- if
  
  -- destroy brick on hit 
  	destroy_brick(bricks,ball)
  	
end


function destroy_brick(bricks,ball)

	for brick in all(bricks) do	
			
			--local offset = (ball.x - brick.middle)/(brick.w/2)
			
			
			if collition(ball,brick) then
				ball.vel_y =- ball.vel_y
    --ball.vel_x = ball.max_speed * offset 
				del(bricks,brick)
				break
			end
			
 end
	
end


-- did collition happen?	
function collition(a, b)

    return a.x < b.x + b.w and
           a.x + a.w > b.x and
           a.y < b.y + b.h and
           a.y + a.h > b.y
end
	
-->8
-- bricks layout -- 
function bricks_init()
	
	bricks_layout = {
	
	{2,2,2,2,2,2,2,2,2,2,2,2,2},
	{2,2,2,2,2,2,2,2,2,2,2,2,2},
	{2,2,2,2,2,2,2,2,2,2,2,2,2}


	}
	
	bricks={}
	save_brick(bricks_layout)
end

function brick_update()

	
end

function save_brick(bricks_layout)
	
	for y=1, #bricks_layout do
			-- for every column in the row
			for x=1,#bricks_layout[y] do
			
				local brick = bricks_layout[y][x]

			
				add(bricks, {
	    x = (x-1)*9,
	    y = (y-1)*3,
	    middle =	4, -- half of the brick width
	    w = 8, -- width
	    h = 2  -- height
				})

			end
		end
	
	
end


function brick_draw()

    for brick in all(bricks) do
        spr(2, brick.x, brick.y, 1, 1) -- assuming sprite 2 is your brick
    end
    
end
__gfx__
00000000000000003333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
