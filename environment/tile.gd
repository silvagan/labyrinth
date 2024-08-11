extends Node2D
class_name Tile
var width = 600

var temp = Line2D.new()
func _ready():
	pass

func visualize(c, i, j, disp, global_scaling):
	get_parent().set_pattern(0, Vector2i((c.x*16+i)*10, (c.y*16+j)*10), get_parent().tile_set.get_pattern(0))

