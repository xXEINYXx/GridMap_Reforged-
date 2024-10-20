@tool
extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		var mouse_position: Vector2 = EditorInterface.get_editor_viewport_3d().get_mouse_position()
		var editor_viewport = EditorInterface.get_editor_viewport_3d().get_visible_rect()
		var origin: Vector3 = EditorInterface.get_editor_viewport_3d().get_camera_3d().project_ray_origin(mouse_position)
		var direction: Vector3 = EditorInterface.get_editor_viewport_3d().get_camera_3d().project_ray_normal(mouse_position)
		var distance = 1000
		var world3D = get_world_3d().direct_space_state
		var RayQuery = PhysicsRayQueryParameters3D.create(origin,direction*distance)
		var result = world3D.intersect_ray(RayQuery)
		if result:
			if "position" in result:
				var result_position = result.get("position")
				
				var result_position_slice_x = result_position[0]
				var result_position_slice_z = result_position[2]
				
				position.x = floor(result_position_slice_x)
				position.z = floor(result_position_slice_z)
