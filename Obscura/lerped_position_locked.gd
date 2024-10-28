class_name LerpedPositionLocked
extends CameraControllerBase

@export var follow_speed:float
@export var catchup_speed:float
@export var leash_distance:float
@export var alternative_smoothing:bool = false

func _ready() -> void:
	super()
	position = target.position


func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var diff:Vector3 = target.position - position
	diff.y = 0
	
	if alternative_smoothing:
		position += diff * clampf(target.velocity.length()/625, 0.08, 0.2)
	else:
		if diff.length() > leash_distance:
			if target.velocity == Vector3.ZERO:
				position += 0.12 * diff
			else:
				position += diff.normalized() * target.velocity.length() * delta
		elif not target.velocity == Vector3.ZERO:
			#follow
			position += diff.normalized() * target.velocity.length() * follow_speed * delta
		else:
			#catchup
			
			#I personally prefer using this nonlinear smoothing pattern
			#position += 0.06 * diff
			
			#but for the assignment, the following better conforms to the instructions
			if diff.length() < 0.025 * leash_distance:
				position = target.position
			else:
				position += diff.normalized() * target.BASE_SPEED * catchup_speed * delta
	
	super(delta)

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -5))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, 5))
	
	immediate_mesh.surface_add_vertex(Vector3(-5, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(5, 0, 0))
	immediate_mesh.surface_end()


	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	#mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	mesh_instance.global_position = Vector3(global_position.x, global_position.y - 10, global_position.z)
	#the above way of doing it keeps the crosshair size constant on the screen, for clarity
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
