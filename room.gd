extends Tile
class_name Room
var top = false
var right = false
var bottom = false
var left = false
var corridors = [false, false, false, false]

var t

func visualize(c, i, j, disp, global_scaling):
	var x1 = i * global_scaling - width/2-20 + disp[0]
	var x2 = i * global_scaling + width/2+20 + disp[0]
	
	var y = j * global_scaling + disp[1]
	var w = width + 40
	
	if top:
		y -= 2.5
		w -= 5
	if right:
		x2 -= 5
	if bottom:
		y += 2.5
		w -= 5
	if left:
		x1 += 5
		
	var p1 = Vector2(x1, y)
	var p2 = Vector2(x2, y)
	
	temp = Line2D.new()
	temp.top_level = true
	temp.add_point(p1)
	temp.add_point(p2)
	temp.width = w
	temp.default_color = Color.WHITE
	c.root.add_child(temp);
	
	if corridors[0]:
		t = Line2D.new()
		t.add_point(Vector2(i * global_scaling + disp[0], j * global_scaling + disp[1] - (width+30)/2))
		t.add_point(Vector2(i * global_scaling + disp[0], j * global_scaling + disp[1] - (width+30)/2 - 5))
		t.width = 60
		t.default_color = Color.WHITE
		c.root.add_child(t);
	if corridors[1]:
		t = Line2D.new()
		t.add_point(Vector2(p2[0], j * global_scaling + disp[1]))
		t.add_point(Vector2(p2[0]+5, j * global_scaling + disp[1]))
		t.width = 60
		t.default_color = Color.WHITE
		c.root.add_child(t);
	if corridors[2]:
		t = Line2D.new()
		t.add_point(Vector2(i * global_scaling + disp[0], j * global_scaling + disp[1] + (width+30)/2 + 5))
		t.add_point(Vector2(i * global_scaling + disp[0], j * global_scaling + disp[1] + (width+30)/2))
		t.width = 60
		t.default_color = Color.WHITE
		c.root.add_child(t);
	if corridors[3]:
		t = Line2D.new()
		t.add_point(Vector2(p1[0]-5, j * global_scaling + disp[1]))
		t.add_point(Vector2(p1[0], j * global_scaling + disp[1]))
		t.width = 60
		t.default_color = Color.WHITE
		c.root.add_child(t);
