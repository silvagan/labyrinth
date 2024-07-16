extends CharacterBody2D

@export var movement_speed: float = 200.0
@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_navigation_agent_2d_velocity_computed))
	set_movement_target(random_walk())

func set_movement_target(movement_target: Vector2):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	if (!navigation_agent.is_target_reachable()):
		set_movement_target(random_walk())
	if navigation_agent.is_navigation_finished():
		set_movement_target(random_walk())

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()


func random_walk():
	return Vector2(position[0] + randf_range(500, -500), position[1] + randf_range(500, -500))


#func _on_navigation_agent_2d_target_reached() -> void:
	#set_movement_target(random_walk())
