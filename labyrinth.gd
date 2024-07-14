extends Node2D
@onready var ex = preload("res://explorer.tscn")
	
func _ready():
	var x = ex.instantiate()
	x.position = Vector2(0,0)
	add_child(x)
