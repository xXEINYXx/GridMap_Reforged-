@tool
extends EditorPlugin

var currentGridmapReforged:Gridmap_Reforged = null

func _handles(object: Object):
	return object is Gridmap_Reforged

func _edit(object: Object) -> void:
	currentGridmapReforged = object
	if(!currentGridmapReforged):
		return
	currentGridmapReforged.plugin_function_test(self)

#func _input(event):
	#if Engine.is_editor_hint():
		#if event.is_action_pressed(MOUSE_BUTTON_LEFT):
			#currentGridmapReforged.plugin_function_test(self)

func _enter_tree():
	pass
	
	
func _exit_tree():
	pass
	
func switchGridmapReforged(newGridmapReforged:Gridmap_Reforged):
	currentGridmapReforged = newGridmapReforged
	currentGridmapReforged.plugin_function_test(self)
