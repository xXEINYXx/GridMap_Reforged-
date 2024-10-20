@tool
class_name Gridmap_Reforged
extends Node3D
#floor var + setter + call chenge_grid_Y function
@export_category("Floor selection")
@export var floor:int = 0:
	set(val):
		if(val != floor):
			floor = val
			change_grid_Y()

@export_category("TileSet")	
@export_group("1")		
@export var tileset1_selected : bool = true
@export var instance1: PackedScene 
@export var instance2: PackedScene
@export var instance3: PackedScene  

var gridMap_Reforged: Node3D  # Variable pour l'instance de GridMap_Reforged
var GridMap_Reforged: PackedScene = preload("res://addons/Gridmap_Reforged/scenes/Gridmap_Reforged.tscn")
var mesh_to_place
var GridCoord 
var previous_floor: int = floor  # Stocker la valeur précédente du sol




	
# Appelée lorsque le noeud entre dans l'arbre de la scène pour la première fois
func _ready():
	pass
		

# Processus qui s'exécute à chaque frame en mode éditeur
func _process(delta):
	if Engine.is_editor_hint():
		
		self.position = Vector3(0,0,0)
		var selection = EditorInterface.get_selection()
		selection.get_selected_nodes()
		if self in selection.get_selected_nodes():
			
			var GridDisplay = gridMap_Reforged.find_child("GridDisplay", true, false)
			GridDisplay.show()
		
		#MOUSE POSITION IN THE EDITOR
		
			var mouse_position: Vector2 = EditorInterface.get_editor_viewport_3d().get_mouse_position()
			var editor_viewport = EditorInterface.get_editor_viewport_3d().get_visible_rect()
			
			if editor_viewport.has_point(mouse_position):
					
			#SYSTEM DE PLACEMENT DE BLOCK GRACE A LA VAR MESH, AU CLIC DE LA SOURIS
				if Input.is_action_just_pressed("clic_gauche"):
					var origin: Vector3 = EditorInterface.get_editor_viewport_3d().get_camera_3d().project_ray_origin(mouse_position)
					var direction: Vector3 = EditorInterface.get_editor_viewport_3d().get_camera_3d().project_ray_normal(mouse_position)
					var distance = 1000
					var world3D = get_world_3d().direct_space_state
					var RayQuery = PhysicsRayQueryParameters3D.create(origin,direction*distance)
					var result = world3D.intersect_ray(RayQuery)
					if result:
						mesh_to_place = instance1.instantiate()
						mesh_to_place.position = Vector3(floor(0.5 + result.position.x/GridCoord.cell_size)*GridCoord.cell_size,result.position.y,floor(0.5 + result.position.z/GridCoord.cell_size)*GridCoord.cell_size)
						#make it unclickable on the editor
						mesh_to_place.set_meta("_edit_lock_", true)
						add_child(mesh_to_place,false,Node3D.INTERNAL_MODE_BACK)
						mesh_to_place.set_owner(get_tree().get_edited_scene_root())
						print("Block placed")
						
		else:
			var GridDisplay = gridMap_Reforged.find_child("GridDisplay", true, false)
			GridDisplay.hide()	
			
			
			
func _enter_tree():
	# Instancier GridMap_Reforged et l'ajouter comme enfant
	gridMap_Reforged = GridMap_Reforged.instantiate() as Node3D
	add_child(gridMap_Reforged)
	gridMap_Reforged.set_owner(get_tree().get_edited_scene_root())
	gridMap_Reforged.set_meta("_edit_lock_", true)
	print("GridMap_Reforged ajouté")
	GridCoord = gridMap_Reforged.find_child("GridCoord", true, false)	
	
func _exit_tree():
	# Libérer l'instance de GridMap_Reforged lorsqu'elle est supprimée de l'arbre
	if gridMap_Reforged:
		gridMap_Reforged.queue_free()

# Change la position en Y du grid_map
func change_grid_Y():
	if gridMap_Reforged:
		var grid_display = gridMap_Reforged.get_child(0) as Node3D
		grid_display.position.y = floor

func plugin_function_test(myEditorPlugin: EditorPlugin):
	print(self, "is me")
