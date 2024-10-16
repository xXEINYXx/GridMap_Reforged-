@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Gridmap_Reforged","Node3D",preload("res://addons/Gridmap_Reforged/scripts/Gridmap_Reforged_Script.gd"),preload("res://addons/Gridmap_Reforged/icon.png"))
	
	
func _exit_tree():
	remove_custom_type("Gridmap_Reforged")
	
