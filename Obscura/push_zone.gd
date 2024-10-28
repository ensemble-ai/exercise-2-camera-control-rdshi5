class_name PushZone
extends CameraControllerBase

@export var push_ratio:float
@export var pushbox_top_left:Vector2
@export var pushbox_bottom_right:Vector2
@export var speedup_zone_top_left:Vector2
@export var speedup_zone_bottom_right:Vector2
@export var proportionate_box:bool = false

var _opushbox_top_left:Vector2
var _opushbox_bottom_right:Vector2
var _ospeedup_zone_top_left:Vector2
var _ospeedup_zone_bottom_right:Vector2

func _ready() -> void:
	super()
	position = target.position
	_opushbox_top_left = pushbox_top_left
	_opushbox_bottom_right = pushbox_bottom_right
	_ospeedup_zone_top_left = speedup_zone_top_left
	_ospeedup_zone_bottom_right = speedup_zone_bottom_right

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	if proportionate_box:
		pushbox_top_left = _opushbox_top_left * dist_above_target / 10
		pushbox_bottom_right = _opushbox_bottom_right * dist_above_target / 10
		speedup_zone_top_left = _ospeedup_zone_top_left * dist_above_target / 10
		speedup_zone_bottom_right = _ospeedup_zone_bottom_right * dist_above_target / 10
	
	var tpos = target.global_position
	var cpos = global_position
	
	#left
	var left_diff = (cpos.x + pushbox_top_left.x) - (tpos.x - target.WIDTH / 2.0)
	if left_diff > 0:
		global_position.x -= left_diff
	elif (tpos - cpos).x < speedup_zone_top_left.x and target.velocity.x < 0:
		global_position.x += target.velocity.x * delta * push_ratio
	
	#right
	var right_diff = (tpos.x + target.WIDTH / 2.0) - (cpos.x + pushbox_bottom_right.x)
	if right_diff > 0:
		position.x += right_diff
	elif (tpos - cpos).x > speedup_zone_bottom_right.x and target.velocity.x > 0:
		global_position.x += target.velocity.x * delta * push_ratio
	
	#top
	var top_diff = (cpos.z + pushbox_top_left.y) - (tpos.z - target.HEIGHT / 2.0)
	if top_diff > 0:
		position.z -= top_diff
	elif (tpos - cpos).z < speedup_zone_top_left.y and target.velocity.z < 0:
		global_position.z += target.velocity.z * delta * push_ratio
	
	#bottom
	var bottom_diff = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + pushbox_bottom_right.y)
	if bottom_diff > 0:
		position.z += bottom_diff
	elif (tpos - cpos).z > speedup_zone_bottom_right.y and target.velocity.z > 0:
		global_position.z += target.velocity.z * delta * push_ratio
	
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = pushbox_top_left.x
	var right:float = pushbox_bottom_right.x
	var top:float = pushbox_top_left.y
	var bottom:float = pushbox_bottom_right.y
	
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
