class_name LerpedTargetFocused
extends CameraControllerBase

@export var lead_speed:float
@export var catchup_delay_duration:float
@export var catchup_speed:float
@export var leash_distance:float
@export var alternative_smoothing:bool = true
#the implementation I prefer is on by default, toggle off in inspector to see the more vanilla version

var _anchor:Vector3
var _time:float

func _ready() -> void:
	super()
	position = target.position
	_anchor = position


func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	if alternative_smoothing:
		var diff:Vector3 = target.position - _anchor
		diff.y = 0
		
		if target.velocity == Vector3.ZERO:
			_time += delta
		else:
			_time = 0
		
		if (not target.velocity == Vector3.ZERO) or _time > catchup_delay_duration:
			_anchor += diff * clampf(target.velocity.length()/625, 0.08, 0.25)
			#set the camera's position equal to the precise opposite of the anchor
			#_anchor + (target.position - _anchor) + (target.position - _anchor)
			position = 2 * target.position - _anchor
		
		#to prevent any wonky indefinite counting
		if diff.length() < 0.001 * leash_distance:
			_time = 0
			position = target.position
		
	else:
		#this solution works, but it's not as elegant and I don't like it
		
		var diff:Vector3 = position - target.position
		diff.y = 0
		
		if not target.velocity == Vector3.ZERO:
			_time = 0
			
			position += target.velocity * delta * lead_speed
			
			if diff.length() > leash_distance:
				position -= diff.normalized() * (diff.length() - leash_distance) * delta
			
		if target.velocity == Vector3.ZERO:
			_time += delta
			if _time > catchup_delay_duration:
				position -= diff.normalized() * catchup_speed * delta
				if diff.length() < 0.05 * leash_distance:
					_time = 0
					position = target.position
	
	
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
