extends Tile
class_name Tunnel
var up = false
var right = false
var down = false
var left = false

func visualize(c, i, j, disp, global_scaling):
	temp = Line2D.new()
	temp.top_level = true
	temp.add_point(Vector2(i * global_scaling - 30 + disp[0], j * global_scaling + disp[1]))
	temp.add_point(Vector2(i * global_scaling + 30 + disp[0], j * global_scaling + disp[1]))
	temp.width = 60
	temp.default_color = Color.WHITE
	c.root.add_child(temp);
	if(up):
		temp = Line2D.new()
		temp.top_level = true
		temp.add_point(Vector2(i * global_scaling + disp[0], j * global_scaling - 30 + disp[1]))
		temp.add_point(Vector2(i * global_scaling + disp[0], j * global_scaling - 50 + disp[1]))
		temp.width = 60
		temp.default_color = Color.INDIAN_RED
		c.root.add_child(temp);
	if(right):
		temp = Line2D.new()
		temp.top_level = true
		temp.add_point(Vector2(i * global_scaling + 30 + disp[0], j * global_scaling + disp[1]))
		temp.add_point(Vector2(i * global_scaling + 50 + disp[0], j * global_scaling + disp[1]))
		temp.width = 60
		temp.default_color = Color.PALE_VIOLET_RED
		c.root.add_child(temp);
	if(down):
		temp = Line2D.new()
		temp.top_level = true
		temp.add_point(Vector2(i * global_scaling + disp[0], j * global_scaling + 30 + disp[1]))
		temp.add_point(Vector2(i * global_scaling + disp[0], j * global_scaling + 50 + disp[1]))
		temp.width = 60
		temp.default_color = Color.PINK
		c.root.add_child(temp);
	if(left):
		temp = Line2D.new()
		temp.top_level = true
		temp.add_point(Vector2(i * global_scaling - 30 + disp[0], j * global_scaling + disp[1]))
		temp.add_point(Vector2(i * global_scaling - 50 + disp[0], j * global_scaling + disp[1]))
		temp.width = 60
		temp.default_color = Color.LIGHT_PINK
		c.root.add_child(temp);
	
