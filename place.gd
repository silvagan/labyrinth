extends Node

@onready var preview_line = Line2D.new()

@onready var tile = preload("res://tile.tscn")
@onready var room = preload("res://room.tscn")
@onready var tunnel = preload("res://tunnel.tscn")
@onready var chunk = preload("res://chunk.tscn")


@onready var pattern = $"../TileMap".tile_set.get_pattern(0)

@export var grid_width = 16
@export var grid_height = 16
@export var global_scaling = 1000

var thread: Thread

var chunks = {}
var start = false
var update = false
var is_room = false
var is_tunnel = false
var delete = false
var line_start = Vector2(0, 0)
var path = [null, null, null]
var dimentions = [null, null]

func _ready():
	get_window().position = Vector2(320, 180)
	DisplayServer.window_set_size(Vector2i(1920, 1080))
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#draw_grid(grid_width, grid_height, Vector2(0, 0))
	#debug_chunk_border(grid_width, grid_height, Vector2(0, 0))
	generate_chunk(0, 0)
	update_chunk(chunks["0 0"])
	
	
	$"../TileMap".set_pattern(0, Vector2i(0, 0), pattern)
	$"../TileMap".set_pattern(0, Vector2i(10, 0), pattern)
	$"../TileMap".set_pattern(0, Vector2i(0, 10), pattern)
	

func _process(delta):
	var mouse_pos = fit_into_grid((get_viewport().get_mouse_position() / Vector2($"../Camera2D".zoom[0], $"../Camera2D".zoom[1]))+$"../Camera2D".position)
	if is_tunnel:
		if start:
			preview_line = Line2D.new()
			preview_line.default_color = Color(Color.WHITE, 0.5)
			preview_line.add_point(line_start)
			preview_line.add_point(line_start)
			preview_line.add_point(line_start)
			path[0] = line_start
			preview_line.width = 500
			start = false
			$Top.add_child(preview_line)
		if update:
			path[1] = Vector2(mouse_pos[0], line_start[1])
			path[2] = mouse_pos
			preview_line.set_point_position(1, Vector2(mouse_pos[0], line_start[1]))
			preview_line.set_point_position(2, mouse_pos)

	if is_room:
		if start:
			
			preview_line = Line2D.new()
			preview_line.add_point(Vector2((line_start[0]+mouse_pos[0])/2, line_start[1]))
			preview_line.add_point(Vector2((line_start[0]+mouse_pos[0])/2, mouse_pos[1]))
			dimentions[0] = line_start
			start = false
			$Top.add_child(preview_line)
		if update:
			dimentions[1] = mouse_pos
			preview_line.width = (abs(line_start[0]-mouse_pos[0]))+900
			preview_line.default_color = Color(Color.WHITE, 0.5)
			if(line_start[1] > mouse_pos[1]):
				preview_line.set_point_position(0, Vector2((line_start[0]+mouse_pos[0])/2, line_start[1]+450))
				preview_line.set_point_position(1, Vector2((line_start[0]+mouse_pos[0])/2, mouse_pos[1]-450))
			else:
				preview_line.set_point_position(0, Vector2((line_start[0]+mouse_pos[0])/2, line_start[1]-450))
				preview_line.set_point_position(1, Vector2((line_start[0]+mouse_pos[0])/2, mouse_pos[1]+450))
			
	if delete:
		if start:
			
			preview_line = Line2D.new()
			preview_line.add_point(Vector2((line_start[0]+mouse_pos[0])/2, line_start[1]))
			preview_line.add_point(Vector2((line_start[0]+mouse_pos[0])/2, mouse_pos[1]))
			dimentions[0] = line_start
			start = false
			$Top.add_child(preview_line)
		if update:
			dimentions[1] = mouse_pos
			preview_line.width = (abs(line_start[0]-mouse_pos[0]))+900
			preview_line.default_color = Color(Color.RED, 0.5)
			if(line_start[1] > mouse_pos[1]):
				preview_line.set_point_position(0, Vector2((line_start[0]+mouse_pos[0])/2, line_start[1]+450))
				preview_line.set_point_position(1, Vector2((line_start[0]+mouse_pos[0])/2, mouse_pos[1]-450))
			else:
				preview_line.set_point_position(0, Vector2((line_start[0]+mouse_pos[0])/2, line_start[1]-450))
				preview_line.set_point_position(1, Vector2((line_start[0]+mouse_pos[0])/2, mouse_pos[1]+450))
		
var screen = Vector2i(1920, 1080)
func _input(event):
	if event.is_action_pressed("shift_left_click"):
		line_start = fit_into_grid((get_viewport().get_mouse_position() / Vector2($"../Camera2D".zoom[0], $"../Camera2D".zoom[1]))+$"../Camera2D".position)
		is_room = true
		start = true
		update = true
	elif event.is_action_pressed("left_click"):
		line_start = fit_into_grid((get_viewport().get_mouse_position() / Vector2($"../Camera2D".zoom[0], $"../Camera2D".zoom[1]))+$"../Camera2D".position)
		is_tunnel = true
		start = true
		update = true
	if event.is_action_pressed("right_click"):
		line_start = fit_into_grid((get_viewport().get_mouse_position() / Vector2($"../Camera2D".zoom[0], $"../Camera2D".zoom[1]))+$"../Camera2D".position)
		delete = true
		start = true
		update = true
	if event.is_action_released("left_click") || event.is_action_released("right_click"):
		
		#thread = Thread.new()
		#thread.start(_thread_function.bind())
		if(delete):
			preview_line.queue_free()
			update = false
			delete = false
			
			var coord_min = [min(dimentions[0][0], dimentions[1][0])/global_scaling, min(dimentions[0][1], dimentions[1][1])/global_scaling]
			var coord_max = [max(dimentions[0][0], dimentions[1][0])/global_scaling, max(dimentions[0][1], dimentions[1][1])/global_scaling]

			var chunk_min = [floor(coord_min[0]/16), floor(coord_min[1]/16)]
			var chunk_max = [floor(coord_max[0]/16), floor(coord_max[1]/16)]
			
			for i in range(chunk_min[0], chunk_max[0]+1):
				for j in range(chunk_min[1], chunk_max[1]+1):
					var key = str(i) + " " + str(j)
					if(!chunks.has(key)):
						return
					var range_x = [i*grid_width, (i+1)*grid_width-1]
					var range_y = [j*grid_height, (j+1)*grid_height-1]
					var local_min = [coord_min[0], coord_min[1]]
					var local_max = [coord_max[0], coord_max[1]]
					
					if(local_min[0] < range_x[0]):
						local_min[0] = range_x[0]
					if(local_min[1] < range_y[0]):
						local_min[1] = range_y[0]
						
					if(local_max[0] > range_x[1]):
						local_max[0] = range_x[1]
					if(local_max[1] > range_y[1]):
						local_max[1] = range_y[1]
					
					local_min[0] -= i*grid_width
					local_min[1] -= j*grid_height
					local_max[0] -= i*grid_width
					local_max[1] -= j*grid_height
					
					delete_from_grid(key, local_min, local_max)
								
					#update_chunk(chunks[key])
		
		if(is_room):
			preview_line.queue_free()
			update = false
			is_room = false
			
			var coord_min = [min(dimentions[0][0], dimentions[1][0])/global_scaling, min(dimentions[0][1], dimentions[1][1])/global_scaling]
			var coord_max = [max(dimentions[0][0], dimentions[1][0])/global_scaling, max(dimentions[0][1], dimentions[1][1])/global_scaling]

			var chunk_min = [floor(coord_min[0]/16), floor(coord_min[1]/16)]
			var chunk_max = [floor(coord_max[0]/16), floor(coord_max[1]/16)]
			
			for i in range(chunk_min[0], chunk_max[0]+1):
				for j in range(chunk_min[1], chunk_max[1]+1):
					var key = str(i) + " " + str(j)
					if(!chunks.has(key)):
						#draw_grid(grid_width, grid_height, Vector2(i, j))
						#debug_chunk_border(grid_width, grid_height, Vector2(i, j))
						generate_chunk(i, j)
						
					var range_x = [i*grid_width, (i+1)*grid_width-1]
					var range_y = [j*grid_height, (j+1)*grid_height-1]
					var local_min = [coord_min[0], coord_min[1]]
					var local_max = [coord_max[0], coord_max[1]]
					
					if(local_min[0] < range_x[0]):
						local_min[0] = range_x[0]
					if(local_min[1] < range_y[0]):
						local_min[1] = range_y[0]
						
					if(local_max[0] > range_x[1]):
						local_max[0] = range_x[1]
					if(local_max[1] > range_y[1]):
						local_max[1] = range_y[1]
					
					local_min[0] -= i*grid_width
					local_min[1] -= j*grid_height
					local_max[0] -= i*grid_width
					local_max[1] -= j*grid_height
					
					var transfer = [false, false, false, false]
					if(j != chunk_min[1]):
						transfer[0] = true
					if(i != chunk_max[0]):
						transfer[1] = true
					if(j != chunk_max[1]):
						transfer[2] = true
					if(i != chunk_min[0]):
						transfer[3] = true
					save_room_to_grid(key, local_min, local_max, transfer)
								
					#update_chunk(chunks[key])
						
						
		if(is_tunnel):
			preview_line.queue_free()
			update = false
			is_tunnel = false
			
			var first_chunk = floor(path[0] / (global_scaling * grid_width))
			var turn_chunk = floor(path[1] / (global_scaling * grid_width))
			var last_chunk = floor(path[2] / (global_scaling * grid_width))

			for i in range(min(first_chunk[0], turn_chunk[0]), max(first_chunk[0], turn_chunk[0]) + 1):
				var chunk_range = [i*global_scaling*grid_width, ((i+1)*grid_width-1)*global_scaling]
				var p = [path[0][0], path[1][0]]
				if (p[0] < chunk_range[0]):
					p[0] = chunk_range[0]
				elif (p[0] > chunk_range[1]):
					p[0] = chunk_range[1]
				if (p[1] < chunk_range[0]):
					p[1] = chunk_range[0]
				elif (p[1] > chunk_range[1]):
					p[1] = chunk_range[1]
				var key = str(i) + " " + str(first_chunk[1])
				if(!chunks.has(key)):
					#draw_grid(grid_width, grid_height, Vector2(i, first_chunk[1]))
					#debug_chunk_border(grid_width, grid_height, Vector2(i, first_chunk[1]))
					generate_chunk(i, first_chunk[1])
				
				p[0] -= global_scaling*grid_width*(i)
				p[1] -= global_scaling*grid_width*(i)
				var y = path[0][1] - global_scaling*grid_height*first_chunk[1]
				
				var transfer = [false, false]
				if i != (min(first_chunk[0], turn_chunk[0])):
					transfer[0] = true
				if i != (max(first_chunk[0], turn_chunk[0])):
					transfer[1] = true
				var v1 = Vector2(p[0], y)
				var v2 = Vector2(p[1], y)
				if v1 > v2:
					var temp = v2
					v2 = v1
					v1 = temp
				save_tunnel_to_grid(chunks[key], v1, v2, "horizontal", transfer)
				#update_chunk(chunks[key])
					
			for j in range(min(turn_chunk[1], last_chunk[1]), max(turn_chunk[1], last_chunk[1]) + 1):
				var chunk_range = [j*global_scaling*grid_height, ((j+1)*grid_height-1)*global_scaling]
				var p = [path[1][1], path[2][1]]
				if (p[0] < chunk_range[0]):
					p[0] = chunk_range[0]
				elif (p[0] > chunk_range[1]):
					p[0] = chunk_range[1]
				if (p[1] < chunk_range[0]):
					p[1] = chunk_range[0]
				elif (p[1] > chunk_range[1]):
					p[1] = chunk_range[1]
				var key = str(last_chunk[0]) + " " + str(j)
				if(!chunks.has(key)):
					#draw_grid(grid_width, grid_height, Vector2(last_chunk[0], j))
					#debug_chunk_border(grid_width, grid_height, Vector2(j, first_chunk[1]))
					generate_chunk(last_chunk[0], j)
				
				p[0] -= global_scaling*grid_height*(j)
				p[1] -= global_scaling*grid_height*(j)
				var x = path[2][0] - global_scaling*grid_width*(turn_chunk[0])
				
				var transfer = [false, false]
				if j != (min(turn_chunk[1], last_chunk[1])):
					transfer[0] = true
				if j != (max(turn_chunk[1], last_chunk[1])):
					transfer[1] = true
				var v1 = Vector2(x, p[0])
				var v2 = Vector2(x, p[1])
				if v1 > v2:
					var temp = v2
					v2 = v1
					v1 = temp
				save_tunnel_to_grid(chunks[key], v1, v2, "vertical", transfer)
				#update_chunk(chunks[key])
	
	if event.is_action_pressed("zoom_in"):
		$"../Camera2D".zoom *= 2
		$"../Camera2D".position[0] += screen[0]/4
		$"../Camera2D".position[1] += screen[1]/4
		screen /= 2
	if event.is_action_pressed("zoom_out"):
		$"../Camera2D".zoom /= 2
		$"../Camera2D".position[0] -= screen[0]/2
		$"../Camera2D".position[1] -= screen[1]/2
		screen *= 2

func fit_into_grid (vec):
	return snapped(vec, Vector2(global_scaling, global_scaling))
	
func draw_grid (height, width, pos):
	var dist = -global_scaling / 2
	var tline = Line2D.new()
	for i in height+1:
		tline = Line2D.new()
		tline.add_point(Vector2(grid_width*global_scaling*pos[0] + dist, i * global_scaling + grid_height*global_scaling*pos[1] + dist))
		tline.add_point(Vector2((width) * global_scaling + grid_width*global_scaling*pos[0] + dist, i * global_scaling + grid_height*global_scaling*pos[1] + dist))
		tline.default_color = Color.DIM_GRAY
		$Background.add_child(tline)
		
	for j in width+1:
		tline = Line2D.new()
		tline.add_point(Vector2(j * global_scaling + grid_width*global_scaling*pos[0] + dist, grid_height*global_scaling*pos[1] + dist))
		tline.add_point(Vector2(j * global_scaling + grid_width*global_scaling*pos[0] + dist, grid_height*global_scaling*pos[1] + dist + (height) * global_scaling))
		tline.default_color = Color.DIM_GRAY
		$Background.add_child(tline)
		
func draw_routes(c, v1, v2):
	for i in range(v1[0], v2[0]):
		for j in range(v1[1], v2[1]):
			var disp = Vector2(c.x * global_scaling * grid_width, c.y * global_scaling * grid_height)
			c.tiles[i][j].visualize(c, i, j, disp, global_scaling)
			
func save_tunnel_to_grid(c, v1, v2, axis, transfer):

	var x = v1[0]/global_scaling
	var y = v1[1]/global_scaling
	var disp = Vector2(c.x * global_scaling * grid_width, c.y * global_scaling * grid_height)
	match axis:
		"horizontal":
			var count = (v2[0] - v1[0]) / global_scaling
			for i in count:
				match determine_class(c.tiles[x+i][y]):
					"Tunnel":
						c.tiles[x+i][y].right = true
						if(i != 0):
							c.tiles[x+i][y].left = true
							if c.tiles[x+i-1][y] is Room:
								c.tiles[x+i-1][y].corridors[1] = true
					"Room":
						if(i != 0):
							if c.tiles[x+i-1][y] is Tunnel:
								c.tiles[x+i][y].corridors[3] = true
							if c.tiles[x+i-1][y] is Room && c.tiles[x+i-1][y].right:
								c.tiles[x+i-1][y].corridors[1] = true
								c.tiles[x+i][y].corridors[3] = true
					"Tile":
						var temp = tunnel.instantiate()
						temp.right = true
						if(i != 0):
							temp.left = true
							if c.tiles[x+i-1][y] is Room:
								c.tiles[x+i-1][y].corridors[1] = true
						$"../TileMap".add_child(temp)
						c.tiles[x+i][v1[1]/global_scaling] = temp
				if (i!=0):
					c.tiles[x+i][y].visualize(c, x+i, y, disp, global_scaling)
					c.tiles[x+i-1][y].visualize(c, x+i-1, y, disp, global_scaling)
					
			match determine_class(c.tiles[x+count][y]):
				"Room":
					if count != 0:
						if c.tiles[x+count-1][y] is Tunnel:
							c.tiles[x+count][y].corridors[3] = true
						if c.tiles[x+count-1][y] is Room && c.tiles[x+count-1][y].right:
								c.tiles[x+count-1][y].corridors[1] = true
								c.tiles[x+count][y].corridors[3] = true
				"Tunnel":
					if count != 0:
						c.tiles[x+count][y].left = true
						if c.tiles[x+count-1][y] is Room:
							c.tiles[x+count-1][y].corridors[1] = true
				"Tile":
					var temp = tunnel.instantiate()
					if (count != 0):
						temp.left = true
						if c.tiles[x+count-1][y] is Room:
							c.tiles[x+count-1][y].corridors[1] = true
					$"../TileMap".add_child(temp)
					c.tiles[x+count][y] = temp
					
			if transfer[0]:
				if c.tiles[x][y] is Room && c.tiles[x][y].left:
					c.tiles[x][y].corridors[3] = true
				if c.tiles[x][y] is Tunnel:
					c.tiles[x][y].left = true
			if transfer[1]:
				if c.tiles[x+count][y] is Room && c.tiles[x+count][y].right:
					c.tiles[x+count][y].corridors[1] = true
				if c.tiles[x+count][y] is Tunnel:
					c.tiles[x+count][y].right = true
			c.tiles[x+count-1][y].visualize(c, x+count-1, y, disp, global_scaling)
			c.tiles[x+count][y].visualize(c, x+count, y, disp, global_scaling)
			c.tiles[x][y].visualize(c, x, y, disp, global_scaling)
				
		"vertical":
			var count = (v2[1] - v1[1]) / global_scaling
			for i in count:
				match determine_class(c.tiles[x][y+i]):
					"Tunnel":
						if(count != 0):
							c.tiles[x][y+i].down = true
						if(i != 0):
							c.tiles[x][y+i].up = true
							if c.tiles[x][y+i-1] is Room:
								c.tiles[x][y+i-1].corridors[2] = true
								c.tiles[x][y+i-1].visualize(c, x, y+i-1, disp, global_scaling)
					"Room":
						if(i != 0):
							if c.tiles[x][y+i-1] is Tunnel:
								c.tiles[x][y+i].corridors[0] = true
								c.tiles[x][y+i].visualize(c, x, y+i, disp, global_scaling)
							if c.tiles[x][y+i-1] is Room && c.tiles[x][y+i-1].top && c.tiles[x][y+i].bottom:
								c.tiles[x][y+i-1].corridors[2] = true
								c.tiles[x][y+i-1].visualize(c, x, y+i-1, disp, global_scaling)
								c.tiles[x][y+i].corridors[0] = true
					"Tile":
						var temp = tunnel.instantiate()
						temp.down = true
						if(i != 0):
							temp.up = true
							if c.tiles[x][y+i-1] is Room:
								c.tiles[x][y+i-1].corridors[2] = true
								c.tiles[x][y+i-1].visualize(c, x, y+i-1, disp, global_scaling)
						$"../TileMap".add_child(temp)
						c.tiles[x][y+i] = temp
						pass
				if (i!=0):
					c.tiles[x][y+i].visualize(c, x, y+i, disp, global_scaling)

			match determine_class(c.tiles[x][y+count]):
				"Room":
					if count != 0:
						if c.tiles[x][y+count-1] is Tunnel:
							c.tiles[x][y+count].corridors[0] = true
						if c.tiles[x][y+count-1] is Room && c.tiles[x][y+count-1].bottom && c.tiles[x][y+count].top:
								c.tiles[x][y+count-1].corridors[2] = true
								c.tiles[x][y+count].corridors[0] = true
								c.tiles[x][y+count-1].visualize(c, x, y+count-1, disp, global_scaling)
				"Tunnel":
					if (count != 0):
						c.tiles[x][y+count].up = true
						if c.tiles[x][y+count-1] is Room:
							c.tiles[x][y+count-1].corridors[2] = true
							c.tiles[x][y+count-1].visualize(c, x, y+count-1, disp, global_scaling)
				"Tile":
					var temp = tunnel.instantiate()
					if (count != 0):
						temp.up = true
					if c.tiles[x][y+count-1] is Room:
						c.tiles[x][y+count-1].corridors[2] = true
						c.tiles[x][y+count-1].visualize(c, x, y+count-1, disp, global_scaling)
					$"../TileMap".add_child(temp)
					c.tiles[x][y+count] = temp
			if transfer[0]:
				if c.tiles[x][y] is Room && c.tiles[x][y].bottom:
					c.tiles[x][y].corridors[0] = true
				if c.tiles[x][y] is Tunnel:
					c.tiles[x][y].up = true
			if transfer[1]:
				if c.tiles[x][y+count] is Room && c.tiles[x][y+count].top:
					c.tiles[x][y+count].corridors[2] = true
				if c.tiles[x][y+count] is Tunnel:
					c.tiles[x][y+count].down = true
					
			c.tiles[x][y].visualize(c, x, y, disp, global_scaling)
			c.tiles[x][y+count].visualize(c, x, y+count, disp, global_scaling)

func delete_from_grid(key, local_min, local_max):
	for x in range(local_min[0], local_max[0]+1):
		for y in range(local_min[1], local_max[1]+1):
			var temp = tile.instantiate()
			$"../TileMap".add_child(temp)
			chunks[key].tiles[x][y] = temp
				

func save_room_to_grid(key, local_min, local_max, transfer):
	var disp = Vector2(chunks[key].x * global_scaling * grid_width, chunks[key].y * global_scaling * grid_height)
	for x in range(local_min[0], local_max[0]+1):
		for y in range(local_min[1], local_max[1]+1):
			if chunks[key].tiles[x][y] is Tile :
				var temp = room.instantiate()
				$"../TileMap".add_child(temp)
				chunks[key].tiles[x][y] = temp
				
			if(x == local_min[0]):
				chunks[key].tiles[x][y].left = true
			if(x == local_max[0]):
				chunks[key].tiles[x][y].right = true
				
				
			if(y == local_min[1]):
				chunks[key].tiles[x][y].top = true
			if(y == local_max[1]):
				chunks[key].tiles[x][y].bottom = true
				
			if transfer[2] && y == local_max[1]:
				chunks[key].tiles[x][y].bottom = false
			if transfer[1] && x == local_max[0]:
				chunks[key].tiles[x][y].right = false
			if transfer[0] && y == local_min[1]:
				chunks[key].tiles[x][y].top = false
			if transfer[3] && x == local_min[0]:
				chunks[key].tiles[x][y].left = false
				
			chunks[key].tiles[x][y].visualize(chunks[key], x, y, disp, global_scaling)
			
				
func determine_class(t):
	if t is Room:
		return "Room"
	elif t is Tunnel:
		return "Tunnel"
	else:
		return "Tile"

func update_chunk(c):
	for n in c.root.get_children():
		c.root.remove_child(n)
		n.queue_free()
	draw_routes(c, Vector2(0,0), Vector2(grid_width,grid_height))
	
func update_tile(c, i, j):
	var n = i+j*16
	if(n != 0):
		c.root.get_child(n).queue_free()
	var disp = Vector2(c.x * global_scaling * grid_width, c.y * global_scaling * grid_height)
	c.tiles[i][j].visualize(c, i, j, disp, global_scaling)

func initialize_table(c):
	for i in grid_width:
		c.tiles.append([])
		for j in grid_height:
			var temp = tile.instantiate()
			$"../TileMap".add_child(temp)
			c.tiles[i].append(temp) # Set a starter value for each position
	update_chunk(c)

func clear_chunk(x, y):
	var new_key = str(x) + " " + str(y)
	chunks[new_key].tiles


func generate_chunk(x, y):
	var new_key = str(x) + " " + str(y)
	var node_root = CanvasLayer.new()
	node_root.follow_viewport_enabled = true
	
	add_child(node_root)
	var c = chunk.instantiate()
	c.root = node_root
	c.x = x
	c.y = y
	initialize_table(c)
	chunks[new_key] = c

#func generate_chunks_around(x, y):
	#var min = [x-1, y-1]
	#var max = [x+1, y+1]
	#for i in range(min[0], max[0]+1):
		#for j in range(min[1], max[1]+1):
			#var key = str(i)+" "+str(j)
			#if(!chunks.has(key)):
				#draw_grid(grid_width, grid_height, Vector2(i, j))
				#debug_chunk_border(grid_width, grid_height, Vector2(i, j))
				#generate_chunk(i, j)
				#update_chunk(chunks[key])

func debug_chunk_border(width, height, pos):
	var dist = -global_scaling / 2
	var tline = Line2D.new()
	
	tline = Line2D.new()
	var x = pos[0]*global_scaling*grid_width+dist
	var y = pos[1]*global_scaling*grid_height+dist
	tline.add_point(Vector2(x, y))
	tline.add_point(Vector2(x + (width)*global_scaling, y))
	tline.add_point(Vector2(x + (width)*global_scaling, y + (height)*global_scaling))
	tline.add_point(Vector2(x, y + (height)*global_scaling))
	tline.add_point(Vector2(x, y))
	tline.default_color = Color.RED
	$Background.add_child(tline)

func _on_timer_timeout():
	pass
