@tool
extends Node3D

@export var floor: int = 0
@export var mesh: PackedScene 

var gridMap_Reforged: Node3D  # Variable pour l'instance de GridMap_Reforged
var GridMap_Reforged: PackedScene = preload("res://addons/Gridmap_Reforged/scenes/Gridmap_Reforged.tscn")
var mesh_to_place
var previous_floor: int = floor  # Stocker la valeur précédente du sol

# Appelée lorsque le noeud entre dans l'arbre de la scène pour la première fois
func _ready():
	pass

# Processus qui s'exécute à chaque frame en mode éditeur
func _process(delta):
	if Engine.is_editor_hint():
		# Comparer la valeur précédente de 'floor' avec la nouvelle
		if floor != previous_floor:
			previous_floor = floor
			change_grid_Y()
		
		
		
		#MOUSE POSITION IN THE EDITOR
		
		var mouse_position: Vector2 = EditorInterface.get_editor_viewport_3d().get_mouse_position()
		var editor_viewport = EditorInterface.get_editor_viewport_3d().get_visible_rect()
		
		if editor_viewport.has_point(mouse_position):
			print(mouse_position)
			
		#SYSTEM DE PLACEMENT DE BLOCK GRACE A LA VAR MESH, AU CLIC DE LA SOURIS
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				var origin: Vector3 = EditorInterface.get_editor_viewport_3d().get_camera_3d().project_ray_origin(mouse_position)
				var direction: Vector3 = EditorInterface.get_editor_viewport_3d().get_camera_3d().project_ray_normal(mouse_position)
				var distance = 1000
				var world3D = get_world_3d().direct_space_state
				var RayQuery = PhysicsRayQueryParameters3D.create(origin,direction*distance)
				var result = world3D.intersect_ray(RayQuery)
				print(result)
				if result:
					print("Clic")
					mesh_to_place = mesh.instantiate()
					mesh_to_place.position = Vector3(result.position.x,result.position.y,result.position.z)
					add_child(mesh_to_place)
					print("Block placed")
		
func _enter_tree():
	# Instancier GridMap_Reforged et l'ajouter comme enfant
	gridMap_Reforged = GridMap_Reforged.instantiate() as Node3D
	add_child(gridMap_Reforged)
	print("GridMap_Reforged ajouté")
	return gridMap_Reforged

func _exit_tree():
	# Libérer l'instance de GridMap_Reforged lorsqu'elle est supprimée de l'arbre
	if gridMap_Reforged:
		gridMap_Reforged.queue_free()

# Change la position en Y du grid_map
func change_grid_Y():
	if gridMap_Reforged:
		var grid_display = gridMap_Reforged.get_child(0) as Node3D
		grid_display.position.y = floor
