extends Tile
class_name Room
var top = false
var right = false
var bottom = false
var left = false
var corridors = [false, false, false, false]

var t

func visualize(c, i, j, disp, global_scaling):
	get_parent().set_pattern(0, Vector2i((c.x*16+i)*10, (c.y*16+j)*10), get_parent().tile_set.get_pattern(get_pattern_index() + 17))
	
func get_pattern_index():
	var count = 0
	if(corridors[0]):
		count += 1
	if(corridors[1]):
		count += 2
	if(corridors[2]):
		count += 4
	if(corridors[3]):
		count += 8
		
	#if(top):
		#count += 16
	#if(right):
		#count += 31
	#if(bottom):
		#count += 44
	#if(left):
		#count += 53
	return count
	
	
	#var x1 = i * global_scaling - width/2-200 + disp[0]
	#var x2 = i * global_scaling + width/2+200 + disp[0]
	#
	#var y = j * global_scaling + disp[1]
	#var w = width + 400
	#
	#if top:
		#y -= 2.5
		#w -= 5
	#if right:
		#x2 -= 5
	#if bottom:
		#y += 2.5
		#w -= 5
	#if left:
		#x1 += 5
		#
	#var p1 = Vector2(x1, y)
	#var p2 = Vector2(x2, y)
	#
	#temp = Line2D.new()
	#temp.top_level = true
	#temp.add_point(p1)
	#temp.add_point(p2)
	#temp.width = w
	#temp.default_color = Color.WHITE
	#c.root.add_child(temp);
	#
	#if corridors[0]:
		#t = Line2D.new()
		#t.add_point(Vector2(i * global_scaling + disp[0], j * global_scaling + disp[1] - (width+300)/2))
		#t.add_point(Vector2(i * global_scaling + disp[0], j * global_scaling + disp[1] - (width+300)/2 - 5))
		#t.width = 600
		#t.default_color = Color.WHITE
		#c.root.add_child(t);
	#if corridors[1]:
		#t = Line2D.new()
		#t.add_point(Vector2(p2[0], j * global_scaling + disp[1]))
		#t.add_point(Vector2(p2[0]+5, j * global_scaling + disp[1]))
		#t.width = 600
		#t.default_color = Color.WHITE
		#c.root.add_child(t);
	#if corridors[2]:
		#t = Line2D.new()
		#t.add_point(Vector2(i * global_scaling + disp[0], j * global_scaling + disp[1] + (width+300)/2 + 5))
		#t.add_point(Vector2(i * global_scaling + disp[0], j * global_scaling + disp[1] + (width+300)/2))
		#t.width = 600
		#t.default_color = Color.WHITE
		#c.root.add_child(t);
	#if corridors[3]:
		#t = Line2D.new()
		#t.add_point(Vector2(p1[0]-5, j * global_scaling + disp[1]))
		#t.add_point(Vector2(p1[0], j * global_scaling + disp[1]))
		#t.width = 600
		#t.default_color = Color.WHITE
		#c.root.add_child(t);
