class_name AutoscrollFrame
extends CameraControllerBase

@export var top_left:Vector2
@export var bottom_right:Vector2
@export var autoscroll_speed:Vector3
@export var relative_motion:bool = false

func _ready() -> void:
	super()
	position = target.position


func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	position += autoscroll_speed / delta
	if relative_motion:
		target.position += autoscroll_speed / delta
	
	var tpos = target.global_position
	var cpos = global_position
	
	#
	##boundary checks and pushing
	##left
	var left_diff = (cpos.x + top_left.x) - (tpos.x - target.WIDTH / 2.0)
	if left_diff > 0:
		target.global_position.x += left_diff
	##right
	var right_diff = (tpos.x + target.WIDTH / 2.0) - (cpos.x + bottom_right.x)
	if right_diff > 0:
		target.position.x -= right_diff
	##top
	var top_diff = (cpos.z + top_left.y) - (tpos.z - target.HEIGHT / 2.0)
	if top_diff > 0:
		target.position.z += top_diff
	##bottom
	var bottom_diff = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + bottom_right.y)
	if bottom_diff > 0:
		target.position.z -= bottom_diff
	
	super(delta)

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = top_left.x
	var right:float = bottom_right.x
	var top:float = top_left.y
	var bottom:float = bottom_right.y
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()


	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
