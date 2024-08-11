extends Node2D

@export var fov: float = 160
@export var viewDistance = 5000
@export var rayCount: float = 100
@export var headTurnSpeed = 0.2

var diff = 0

var angle : float = 0
var origin = Vector3(position.x, position.y, 0)

func _ready():
	pass

var t = 0.0
var r = 0.0
var dr = 10.0
var rotating : bool = false

func _physics_process(delta):
	var s = snapped($"../BodySprite".rotation, 0.001)
	if (!rotating || dr != s):
		dr = s
		rotating = true
		r = rotation
		t = 0
	else:
		if (t < 2.2):
			t += delta * headTurnSpeed
		var temp = lerp_angle(rotation, dr, t)
		diff = snapped(abs(fmod(rotation, 6.28319) - fmod(temp, 6.28319)) * 20, 0.0001)
		if (snapped(diff, 0.001) == 0):
			rotation = dr
		else:
			rotation = fmod(temp, 6.28319)
		print(rotation)
	
	
	make_view_mesh()
	
func make_view_mesh():
	var angleIncrease: float = (fov+diff*20) / rayCount
	angle = $".".global_rotation + (fov+diff*20) / 2 
	if $ViewCone/Mesh.mesh != null:
		$ViewCone/Mesh.mesh = null
	var vertices = PackedVector3Array()
	
	#var poliVertices = PackedVector2Array()

	#poliVertices.append(position)
	for i in rayCount+1:
		var temp = position + get_vector_from_angle(angle) * (viewDistance/(diff*2+1))
		
		var ray = RayCast2D.new()
		add_child(ray)
		ray.target_position = temp
		ray.force_raycast_update()
		
		if(ray.is_colliding()):
			var col = ray.get_collision_point()
			ray.global_position = col
			col = ray.position
			temp = col
		else:
			var col = ray.get
		ray.queue_free()
		
		var vertex = Vector3(temp.x, temp.y, 0)
		if (i == 0):
			vertices.append(vertex)
		else:
			vertices.append(vertex)
			if (rayCount > i):
				vertices.append(origin)
				vertices.append(vertex)
			else:
				vertices.append(origin)
				
		#poliVertices.append(temp)
		angle -= angleIncrease
	
	#$ViewCone/Area2D/Collider.polygon = poliVertices
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_color(Color(0.8, 0.8, 0.8, 0.8))
	for v in vertices.size(): 
		st.set_normal(Vector3(0, 0, 1))
		st.add_vertex(vertices[v])
	var mesh = st.commit()
	$ViewCone/Mesh.mesh = mesh


func get_vector_from_angle(angle):
	var angleRad = angle * PI/180
	return Vector2(cos(angleRad), sin(angleRad))
	
func _on_timer_timeout():
	make_view_mesh()
	
