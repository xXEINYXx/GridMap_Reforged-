@tool
extends EditorPlugin

var currentGridmapReforged:Gridmap_Reforged = null

func _init():
	if Engine.is_editor_hint():
		InputMap.add_action("clic_gauche")
		var clic_gauche = InputEventMouseButton.new()
		clic_gauche.button_index = MOUSE_BUTTON_LEFT
		clic_gauche.pressed = true
		InputMap.action_add_event("clic_gauche", clic_gauche)

func _handles(object: Object):
	return object is Gridmap_Reforged

func _edit(object: Object) -> void:
	currentGridmapReforged = object
	if (!currentGridmapReforged):
		print("caché")
		currentGridmapReforged.GridDisplay.hide()
		
	#todo: add any unselection tasks for the currentGridmapReforged here
		return
	#not needed anymore currentGridmapReforged.plugin_function_test(self)
	currentGridmapReforged.GridDisplay.show()
	print("visible")
#todo: add any selection tasks for the currentGridmapReforged here

func _input(event):
	if !Engine.is_editor_hint() || (!currentGridmapReforged): #we are not in the editor or we are not processing inputs for a Gridmap_Reforged
		return
	if event is InputEventMouseMotion:
		currentGridmapReforged.MouseMoved(event)
	if event.is_action("clic_gauche") && Input.is_action_just_pressed("clic_gauche"):
		currentGridmapReforged.ClickHappened(event)

func _enter_tree():
	pass
	
	
func _exit_tree():
	pass
	
func switchGridmapReforged(newGridmapReforged:Gridmap_Reforged):
	currentGridmapReforged = newGridmapReforged
	currentGridmapReforged.plugin_function_test(self)
