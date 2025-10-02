pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- snake game -- 

-- snake grows as it eats

-- 1 point per food
  
-- body copy the last position 
--	of the head

-- when head touches body then
-- game over or wall
 
 
function _init()
	snake_init() -- snake initiation
	map_init()
	food_init() -- food initiation
end

function _update()
	snake_update(snake_head) -- update snake
	ate_food(snake_head,food) -- did the snake ate the food?
end

function _draw()
	cls()

	map_draw(base_map) -- draw map tiles
	food_draw(food)				-- draw food
	snake_draw(snake_head,snake_body) -- draw snake
	
end
-->8
-- snake --

function snake_init()
	
	snake_head = {
	
			x = 0,
			y =	0,
			sp = 18,
			velocity_x = 0,
			velocity_y = 0,
			speed = 1,
			fx = false,
			fy = false	
	}
	
	snake_body={}
	
end
trail = {}

function snake_update(snake_head)
    -- save current head position in trail
    add(trail, {x=snake_head.x, y=snake_head.y})

    -- limit trail size (enough for all body parts, each spaced by "gap")
    local gap = 7 -- bigger number = more visible separation
    local max_length = (#snake_body * gap) + 1
    while #trail > max_length do
        deli(trail, 1)
    end

    -- move head
    snake_head.x += snake_head.velocity_x
    snake_head.y += snake_head.velocity_y

    change_directions(snake_head)

    -- position each body part with spacing
    for i=1,#snake_body do
        local index = #trail - (i * gap)
        if index > 0 then
            snake_body[i].x = trail[index].x
            snake_body[i].y = trail[index].y
        end
    end
end


function snake_draw(snake_head,snake_body)
		
		-- snake head
		local sp = snake_head.sp
		local x = snake_head.x 
		local y = snake_head.y
		local fx = snake_head.fx
		local fy = snake_head.fy

		spr(sp,x,y,1,1,fx,fy)
		
		-- if snake body is larger than 0
		if #snake_body > 0 then
			
			-- for every item inside 
			-- draw it
			for i = 1, #snake_body do
			
				local body = snake_body[i]
			
				if body then
					spr(body.sp,body.x,body.y,1,1)
				end
				
			end
			
		end
		
				
end


function update_body(snake_body,snake_head)
	
	
	-- the loop starts at #body - 1 and goes down to 1.
	for i = #snake_body, 2,-1 do
	--	snake_body[i] = snake_body[i-1]
		snake_body[i].x = snake_body[i-1].x 
  snake_body[i].y = snake_body[i-1].y 
	end
	
	if #snake_body > 0  then
	
		snake_body[1].x = snake_head.x 
		snake_body[1].y = snake_head.y 

	end
	
		
end

function change_directions(snake_head)
	
	if btnp(⬆️) and snake_head.velocity_y ~= 1 then
		snake_head.velocity_y = -1
		snake_head.velocity_x =0
		snake_head.fx = false
    snake_head.fy = false
	end
	
	if btnp(⬇️) and snake_head.velocity_y ~= -1 then
		snake_head.velocity_y = 1
		snake_head.velocity_x =0
		snake_head.fx = false
    snake_head.fy = true
	end
	
	if btnp(➡️) and snake_head.velocity_x ~= -1 then
		snake_head.velocity_y = 0
		snake_head.velocity_x = 1
	end
	
	if btnp(⬅️) and snake_head.velocity_x ~= 1 then
		snake_head.velocity_y = 0
		snake_head.velocity_x = -1
	end
	
	
end


-->8
-- map --

function map_init()

	base_map = {
	{32,32,32,32,32,32,32,32,32,32,32,32,32},
	{32,32,32,32,32,32,32,32,32,32,32,32,32},
	{32,32,32,32,32,32,32,32,32,32,32,32,32},
	{32,32,32,32,32,32,32,32,32,32,32,32,32},
	{32,32,32,32,32,32,32,32,32,32,32,32,32},
	{32,32,32,32,32,32,32,32,32,32,32,32,32},
	{32,32,32,32,32,32,32,32,32,32,32,32,32},
	{32,32,32,32,32,32,32,32,32,32,32,32,32},
	{32,32,32,32,32,32,32,32,32,32,32,32,32},
	{32,32,32,32,32,32,32,32,32,32,32,32,32},
	{32,32,32,32,32,32,32,32,32,32,32,32,32},
	{32,32,32,32,32,32,32,32,32,32,32,32,32},
	{32,32,32,32,32,32,32,32,32,32,32,32,32},
	{32,32,32,32,32,32,32,32,32,32,32,32,32},
	{32,32,32,32,32,32,32,32,32,32,32,32,32},
	{32,32,32,32,32,32,32,32,32,32,32,32,32}

	}
	
end

function map_update()

end

function map_draw(base_map)
	
	-- from row 1 to last
	for x = 1 , #base_map do
	
		-- in each column to last
		for y = 1, #base_map[x] do
			local tile = base_map[x][y]
			
			
  	spr(tile, x * 8, y * 8,1,1) -- assuming each tile is 8x8 pixels

		end -- for
		
	end -- for
	
end
-->8
function food_init()
	
	food = {
		sp = 0,
		x 	=	flr(rnd(120)),
		y 	= flr(rnd(120))
	}

end

function create_food(food)
	
	food.x = flr(rnd(120))
	food.y = flr(rnd(120))

end

function food_draw(food)
	
	spr(food.sp,food.x,food.y,1,1)
	
end
-->8
-- food collition --

function ate_food(snake_head,food)
	
	local sx = snake_head.x -- snake head x
	local sy = snake_head.y -- snake head y
	local fx = food.x -- food x
	local fy = food.y -- food y
	
	if abs(sx-fx) <= 4 and abs(sy-fy) <= 4 then
			
			create_food(food)
			
			add(snake_body,{
			
			x = fx,
			y = fy,
			sp = 17
			
			})
	end
	
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000033bbbb333353000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009a9a9a3333b3333543330800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9a9a9a9abb3333333333338000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9a9a9a9a3b333bb33333338000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009a9a9a33333bb33543330800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000003bbb33333353000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e222222e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e222222e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e222222e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e222222e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e222222e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e222222e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
