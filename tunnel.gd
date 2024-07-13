extends Tile
class_name Tunnel
var up = false
var right = false
var down = false
var left = false

func visualize(c, i, j, disp, global_scaling):
	get_parent().set_pattern(0, Vector2i((c.x*16+i)*10, (c.y*16+j)*10), get_parent().tile_set.get_pattern(get_pattern_index()+1))
	
func get_pattern_index():
	var count = 0
	if(up):
		count += 1
	if(right):
		count += 2
	if(down):
		count += 4
	if(left):
		count += 8
	return count
	
	
	
	
	#temp = Line2D.new()
	#temp.top_level = true
	#temp.add_point(Vector2(i * global_scaling - 300 + disp[0], j * global_scaling + disp[1]))
	#temp.add_point(Vector2(i * global_scaling + 300 + disp[0], j * global_scaling + disp[1]))
	#temp.width = 600
	#temp.default_color = Color.WHITE
	#c.root.add_child(temp);
	#if(up):
		#temp = Line2D.new()
		#temp.top_level = true
		#temp.add_point(Vector2(i * global_scaling + disp[0], j * global_scaling - 300 + disp[1]))
		#temp.add_point(Vector2(i * global_scaling + disp[0], j * global_scaling - 500 + disp[1]))
		#temp.width = 600
		#temp.default_color = Color.WHITE
		#c.root.add_child(temp);
	#if(right):
		#temp = Line2D.new()
		#temp.top_level = true
		#temp.add_point(Vector2(i * global_scaling + 300 + disp[0], j * global_scaling + disp[1]))
		#temp.add_point(Vector2(i * global_scaling + 500 + disp[0], j * global_scaling + disp[1]))
		#temp.width = 600
		#temp.default_color = Color.WHITE
		#c.root.add_child(temp);
	#if(down):
		#temp = Line2D.new()
		#temp.top_level = true
		#temp.add_point(Vector2(i * global_scaling + disp[0], j * global_scaling + 300 + disp[1]))
		#temp.add_point(Vector2(i * global_scaling + disp[0], j * global_scaling + 500 + disp[1]))
		#temp.width = 600
		#temp.default_color = Color.WHITE
		#c.root.add_child(temp);
	#if(left):
		#temp = Line2D.new()
		#temp.top_level = true
		#temp.add_point(Vector2(i * global_scaling - 300 + disp[0], j * global_scaling + disp[1]))
		#temp.add_point(Vector2(i * global_scaling - 500 + disp[0], j * global_scaling + disp[1]))
		#temp.width = 600
		#temp.default_color = Color.WHITE
		#c.root.add_child(temp);
	
