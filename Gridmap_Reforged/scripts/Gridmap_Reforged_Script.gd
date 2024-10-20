@tool
class_name Gridmap_Reforged
extends Node3D
#floor var + setter + call chenge_grid_Y function
@export_category("Floor selection")
@export var floor:int = 0:
	set(val):
		if(val != floor):
			floor = val
			GridDisplay.position.y = floor

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
var GridDisplay

func shootRayFromMouse():
	var mouse_position: Vector2 = EditorInterface.get_editor_viewport_3d().get_mouse_position()
	var editor_viewport = EditorInterface.get_editor_viewport_3d().get_visible_rect()
	if !editor_viewport.has_point(mouse_position):
		return null
	var distance = 1000
	var origin = EditorInterface.get_editor_viewport_3d().get_camera_3d().position
	var endpoint = EditorInterface.get_editor_viewport_3d().get_camera_3d().project_position(mouse_position, distance)
	var world3D = get_world_3d().direct_space_state
	#var RayQuery = PhysicsRayQueryParameters3D.create(origin,direction*distance)
	var RayQuery = PhysicsRayQueryParameters3D.create(origin,endpoint)
	var result = world3D.intersect_ray(RayQuery)
	if result:
		if "position" in result:
			return result.get("position")
	else:
		return null

func MouseMoved(event):
	self.position = Vector3(0,0,0)
	self.rotation = Vector3(0,0,0)
	#this is not a good idea really, we want to be able to put the gridmap anywhere and still have it behave right
	var rp = shootRayFromMouse()
	if rp is Vector3:
		GridDisplay.position.x = rp[0]
		GridDisplay.position.z = rp[2]
	
func ClickHappened(event):
	var mouse_position: Vector2 = EditorInterface.get_editor_viewport_3d().get_mouse_position()
	var editor_viewport = EditorInterface.get_editor_viewport_3d().get_visible_rect()
	var rp = shootRayFromMouse()
	if rp is Vector3:
		mesh_to_place = instance1.instantiate()
		mesh_to_place.position = Vector3(floor(0.5 + rp.x/GridCoord.cell_size)*GridCoord.cell_size,rp.y,floor(0.5 + rp.z/GridCoord.cell_size)*GridCoord.cell_size)
		#make it unclickable on the editor
		mesh_to_place.set_meta("_edit_lock_", true)
		add_child(mesh_to_place,false,Node3D.INTERNAL_MODE_BACK)
		mesh_to_place.set_owner(get_tree().get_edited_scene_root())
		print("Block placed")

# Appelée lorsque le noeud entre dans l'arbre de la scène pour la première fois
func _ready():
	GridDisplay.hide()

func _enter_tree():
	if !gridMap_Reforged:
	 # Instancier GridMap_Reforged et l'ajouter comme enfant
		gridMap_Reforged = GridMap_Reforged.instantiate() as Node3D
		add_child(gridMap_Reforged)
		gridMap_Reforged.set_owner(get_tree().get_edited_scene_root())
		gridMap_Reforged.set_meta("_edit_lock_", true)
		print("GridMap_Reforged ajouté")
		GridCoord = gridMap_Reforged.find_child("GridCoord", true, false)
		GridDisplay = gridMap_Reforged.find_child("GridDisplay", true, false)
		GridDisplay.position.y = floor

func _exit_tree():
	# Libérer l'instance de GridMap_Reforged lorsqu'elle est supprimée de l'arbre
	if gridMap_Reforged:
		gridMap_Reforged.queue_free()
		print("free")

func Selected(): #when editor plugin sees us
	GridDisplay.show()
#	GridDisplay.position.y = floor

func Deselected(): #when editor plugin does not see us
	GridDisplay.hide()

