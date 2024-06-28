extends Node2D
class_name Tile
var width = 60

#@onready var connection_right = false
#@onready var connection_down = false
var temp = Line2D.new()
#@onready var room = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func visualize(c, i, j, disp, global_scaling):
	temp = Line2D.new()
	temp.top_level = true
	temp.add_point(Vector2(i * global_scaling - width/2 + disp[0], j * global_scaling + disp[1]))
	temp.add_point(Vector2(i * global_scaling + width/2 + disp[0], j * global_scaling + disp[1]))
	temp.width = width
	temp.default_color = Color.WEB_GRAY
	c.root.add_child(temp);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

