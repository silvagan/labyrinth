extends Tile
class_name Room
var top = false
var right = false
var bottom = false
var left = false
var corridors = [false, false, false, false]

func visualize(c, i, j, disp, global_scaling):
	get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+1, (c.y*16+j)*10+1), get_parent().tile_set.get_pattern(17))
	
	if(top):
		if(corridors[0]):
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+1, (c.y*16+j)*10), get_parent().tile_set.get_pattern(33))
		else:
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+1, (c.y*16+j)*10), get_parent().tile_set.get_pattern(20))
		if(right):
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+9, (c.y*16+j)*10), get_parent().tile_set.get_pattern(29))
		else:
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+9, (c.y*16+j)*10), get_parent().tile_set.get_pattern(25))
		if(left):
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10, (c.y*16+j)*10), get_parent().tile_set.get_pattern(32))
		else:
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10, (c.y*16+j)*10), get_parent().tile_set.get_pattern(25))
	else:
		get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+1, (c.y*16+j)*10), get_parent().tile_set.get_pattern(18))
		
	if(right):
		if(corridors[1]):
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+9, (c.y*16+j)*10+1), get_parent().tile_set.get_pattern(34))
		else:
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+9, (c.y*16+j)*10+1), get_parent().tile_set.get_pattern(21))
		if(!top):
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+9, (c.y*16+j)*10), get_parent().tile_set.get_pattern(26))
		if(!bottom):
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+9, (c.y*16+j)*10+9), get_parent().tile_set.get_pattern(26))
	else:
		get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+9, (c.y*16+j)*10+1), get_parent().tile_set.get_pattern(19))
		
	if(bottom):
		if(corridors[2]):
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+1, (c.y*16+j)*10+9), get_parent().tile_set.get_pattern(35))
		else:
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+1, (c.y*16+j)*10+9), get_parent().tile_set.get_pattern(22))
		if(right):
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+9, (c.y*16+j)*10+9), get_parent().tile_set.get_pattern(30))
		else:
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+9, (c.y*16+j)*10+9), get_parent().tile_set.get_pattern(27))
		if(left):
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10, (c.y*16+j)*10+9), get_parent().tile_set.get_pattern(31))
		else:
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10, (c.y*16+j)*10+9), get_parent().tile_set.get_pattern(27))
	else:
		get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+1, (c.y*16+j)*10+9), get_parent().tile_set.get_pattern(18))
		
	if(left):
		if(corridors[3]):
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10, (c.y*16+j)*10+1), get_parent().tile_set.get_pattern(36))
		else:
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10, (c.y*16+j)*10+1), get_parent().tile_set.get_pattern(23))
		if(!top):
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10, (c.y*16+j)*10), get_parent().tile_set.get_pattern(28))
		if(!bottom):
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10, (c.y*16+j)*10+9), get_parent().tile_set.get_pattern(28))
	else:
		get_parent().set_pattern(0, Vector2i((c.x*16+i)*10, (c.y*16+j)*10+1), get_parent().tile_set.get_pattern(19))
		
	if(!top):
		if(!left):
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10, (c.y*16+j)*10), get_parent().tile_set.get_pattern(24))
		if(!right):
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+9, (c.y*16+j)*10), get_parent().tile_set.get_pattern(24))
	if(!bottom):
		if(!left):
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10, (c.y*16+j)*10+9), get_parent().tile_set.get_pattern(24))
		if(!right):
			get_parent().set_pattern(0, Vector2i((c.x*16+i)*10+9, (c.y*16+j)*10+9), get_parent().tile_set.get_pattern(24))
