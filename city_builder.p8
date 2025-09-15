pico-8 cartridge // http://www.pico-8.com
version 43
__lua__





function _init()

	mouse_init()
	sel_menu_init()
	base_map_init()
	marker_init()
	confirm_init()

end

function _update()

	mouse_update(mouse)
	over_menu(mouse)
	
end

function _draw()
	cls()
	
	-- draws -- 
	draw_base_map(base_map)
	sel_menu_draw(mouse)
 draw_in_base(mouse,base_map,marker)
	
	marker_draw(marker)
	
	confirm_draw(options)
	
	-- prints --
	
	-- prints if the mouse if over the inv
	print(mouse_over_inv,0,0,7)
	
	-- prints the tiles the mouse is over
	mouse_over_tile(mouse)
	
	-- prints if left or right was clicked
	mouse_click(mouse)
	
	-- prints the selected from inv
	print(selection)
	
	-- prints if it can be placed
	can_be_placed()
	

	last_row(marker)
	middle_x(marker) 

	-- mouse at the bottom to be displayed always on top
	mouse_draw(mouse)
	
end
-->8
-- mouse --
function mouse_init()

	mouse = {
	
		x=0,
		y=0,
		click = 0,
		sprite = 0
	
	}
	
end

function mouse_update(mouse)
	
	mouse.x=stat(32)
	mouse.y=stat(33)
	mouse.click = stat(34)
	poke(0x5f2d,1)
	
	-- functions --

end

function mouse_draw(mouse)
	spr(mouse.sprite,mouse.x,mouse.y,1,1)
end

function mouse_click(mouse)
	
		left_click = false
		right_click = false
		
		-- if left click
		if mouse.click == 1 then
			left_click = true
		
			print('click left')
			print(left_click)

		end
		
		-- if right click 
		if mouse.click == 2 then
						print('click right')
						right_click = true
						print(right_click)
		end
		
end

-- whcih column and row is the mouse over
function mouse_over_tile(mouse)
	
		tile_x = flr(mouse.x / 8) +	1
		tile_y = flr(mouse.y / 8) + 1

		--	print(base_map[tile_y][tile_x])
  print("row: "..tile_y.." | column: "..tile_x, 0, 5, 7)

end
-->8
-- map base --
function base_map_init()
	
	base_map_tiles = {
	
	grass = 16,
	grass_light = 32
	
	
	}
	
	base_map =	{}
	
	-- fills the base map
	for y=1, 130 do
	
	local number = 0
	
	base_map[y] = {}
			
		for x=1,130 do 
		
			number+=1
				
				if number % 2 == 0 then
				
							base_map[y][x] =base_map_tiles.grass

					else
							base_map[y][x] = base_map_tiles.grass_light
				end
				
		end -- for(2)
		
	end -- for(1)
	

end

function draw_base_map(base_map)

	for y=1,#base_map do
		
		for x=1,#base_map[y] do
			
			local tile = base_map[y][x]
			spr(tile,(x-1)*8,(y-1)*8,1,1)
		end -- for(2)
		
	end -- for(1)
	
end
-->8
-- selection menu -- 
function sel_menu_init()
	
	select_menu = {
	
	{sprite = 22,x=0,y=0,h=1,w=1},	--house
	{sprite = 22,x=0,y=0,h=1,w=1}		--house

	}
	
end

function sel_menu_draw(mouse)

				local inv_x = 0 -- start from
				local inv_y = 125 -- y location
				
				-- inventory 
				-- x1, y1, x2, y2, color
				rectfill(inv_x, inv_y, inv_x + 130, inv_y - 15, 6)
				sel_inv_draw()
end


-- draw the items for the select menu
function sel_inv_draw()

				local inv_x = 0 -- start from
				local inv_y = 125 -- y location
				
				-- from 1 to inv count
				for i = 1, #select_menu do
						
		   	local item_x = inv_x - 14 + 14 * i
		    
		    -- draws in the inv selection
		    spr(select_menu[i].sprite, item_x+3, inv_y - 12, select_menu[i].h, select_menu[i].w)
						 

		    -- check if mouse is near this item
		    if abs(mouse.x - item_x) <= 8 and abs(mouse.y - (inv_y - 13)) <= 8 then
		       
		        selected_x = item_x

		        if left_click then
											selection = i
										end
										
		    end -- if
    
				end -- for
				
				if selected_x and mouse_over_inv then
		    rect(selected_x+1, inv_y-2, selected_x + 12, inv_y - 14, 7)
			end -- if

end

-- check if the mouse is over the inv
function over_menu(mouse)

				local inv_x = 0 -- start from
				local inv_y = 125 -- y location
				
			if mouse.x > inv_x and mouse.x < inv_x + 130 and mouse.y < inv_y and mouse.y > inv_y - 20
					
			then
			
							mouse_over_inv = true
								else
							mouse_over_inv = false

				end

end
-->8
-- place in map --

function marker_init()
		marker = {}
end


-- check if over map but not inv
function can_be_placed()
	
	if left_click and not mouse_over_inv and  selection ~= nil then
			return true
	end
	
end


-- checks if the tile is already occupied
function list_has(marker,mouse)
	
	
	local tile_x = flr(mouse.x / 8) + 1
 local tile_y = flr(mouse.y / 8) + 1

	for i=1, #marker do 
	
			if marker[i].x == tile_x and marker[i].y == tile_y then
			 -- list has it 
				return true
			
			end 
	
	end
	
	return false
	
end

function draw_in_base(mouse,base_map,marker)
	
				local tile_x = flr(mouse.x / 8) + 1
    local tile_y = flr(mouse.y / 8) + 1

			if can_be_placed() and not list_has(marker,mouse) then
			
				add(marker,	{
					x = tile_x,
					y = tile_y,
					sprite = 1
				})
				
	end
	
	
end



function marker_draw(marker)
	
    for ma in all(marker) do
    	  base_map[ma.y][ma.x] = ma.sprite 
    end
    
end

-- finds which is the last row 
function last_row(marker)
	
	local last_row = 0
	
	for i = 1, #marker do 
		
	--	print(marker[i].y ..","..marker[i].x)
		
			if marker[i].y > last_row then
				last_row = marker[i].y			
			end
			
	end
	
	return last_row
 --print("last row is: " .. last_row)

	--print(last_row)
		
end

-- finds the middle point of lenght 
function middle_x(marker) 

				local total_x = 0

    for i = 1, #marker do
        total_x += marker[i].x
    end

    local avg_x = total_x / #marker
    
    return avg_x
    --print("middle x (average): " .. avg_x)

end

-->8
-- confirm or cancel -- 

function confirm_init()

	options = {
	
		{sp=2,h=1,w=1},
		{sp=3,h=1,w=1}
		
	}
	
end

function confirm_draw(options)
	
	local last_row = last_row(marker)
	local middle_x = middle_x(marker) 

	-- if the marker has something then show 
	if #marker > 0  then
	
		-- draw the options list
		-- keep them in the middle and last row
			for i = 1, #options do
					spr(options[i].sp, middle_x * 6 + (i-1)*8, last_row * 8, 1, 1)
			end
	
	end
	
end


__gfx__
00000000773333770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000733333370333333008888880000000000000000000000000000000000000044400007777777777000000000000000000000000000000000000000000
00700700333333330333373008877880000000000000000000000000000000000000044400007666666667000000000000000000000000000000000000000000
000770003333333303337330087777800000000000000000000000000000000000000444000076dddd77d7000000000000000000000000000000000000000000
000770003333333303737330087777800000000000000000000000000004440044444444000076dddd55d7000000000000000000000000000000000000000000
007007003333333303773330088778800000000000000000000000000004440044444444000076ddddddd7000000000000000000000000000000000000000000
00000000733333370333333008888880000000000000000000000000000777007777766600007777777777000000000000000000000000000000000000000000
00000000773333770000000000000000000000000000000000000000000707007777066600006666666666000000000000000000000000000000000000000000
333333330000000000000000000000000000000000000000003bb300006000000000000000006666666666000000000000000000000000000000000000000000
33333333000000000000000000000000000000000000000003b33b30745444470070007000006666666666000000000000000000000000000000000000000000
3333333300000000000000000000000000000000000000003b3333b3744444474565456500006c66c64466000000000000000000000000000000000000000000
3333b3330000000000000000000000000000000000000000b333333b744444474545454500006666664466000000000000000000000000000000000000000000
33b3b3b30000000000000000000000000000000000000000b33bb33b777777774545454500000000000000000000000000000000000000000000000000000000
333333330000000000000000000000000000000000000000b3b33b3b666666666666666600000000000000000000000000000000000000000000000000000000
3333333300000000000000000000000000000000000000003b3333b3660660666067777700000000000000000000000000000000000000000000000000000000
3333333300000000000000000000000000000000000000003b3333b3660666666667777700000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000003300000033000000000000000000000000000000000000000000000000000444444440000000000000000000000000000000000000000
bbbb3bbb00000000003bb300003bb300000000000000000000000000000000000044474000000000444444440000000000000000000000000000000000000000
bb3b3b3b0000000003bbbb30003bbb30000000000000000000000000000000004444464400000000444444440000000000000000000000000000000000000000
bbbbbbbb0003300003bbbb3003bbbbb3000000000000000000000000000000004444444400000000666661770000000000000000000000000000000000000000
bbbbbbbb003bb3003bbbbbb303bbbbb30000000000000000000000000000000044444ddd00000000666617770000000000000000000000000000000000000000
bbbbbbbb03bbbb303bbbbbb33bbbbbb300000000000000000000000005566550ddddd66600000000606617070000000000000000000000000000000000000000
bbbbbbbb03bbbb3003bbbb303bbbbb30000000000000000000000000057007506606660600000000666617770000000000000000000000000000000000000000
bbbbbbbb003bb300003bb30003bbb300000000000000000000000000056776506666666600000000666661770000000000000000000000000000000000000000
00000000007777000000000000000000000000000000000000000000444545450000070000070700666617770000000000000000000000000000000000000000
00555500000000000000000000000000000000000000000000000000444545454454564544565645666177770000000000000000000000000000000000000000
05666650007777000000000000000000000000000000000000000000444545454545445445454454661777070000000000000000000000000000000000000000
56666665000000000000000000000000000000000000000000000000444545454545445445454454617777770000000000000000000000000000000000000000
05666775007777000000000000000000000000000000000000000000666667777777777777777777177777770000000000000000000000000000000000000000
00566750000000000000000000000000000000000000000000000000666667777777777777777777777077770000000000000000000000000000000000000000
00055500007777000000000000000000000000000000000000000000666067077070707707707077777777770000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000666667077777777707777777777777770000000000000000000000000000000000000000
