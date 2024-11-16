extends Panel

@export var baseButton: PackedScene = null

var global: GlobalState = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global = get_node("/root/Global")
	loadRecipies()
	pass # Replace with function body.


	
func loadRecipies() -> void:
	var activeRecipies = global.game_state['recipesAvailable']
	var parent_node = %Recepies
	for recipe in activeRecipies:
		var button_instance = baseButton.instantiate()
		button_instance.setTitle(global.availableRecipies[recipe].name)
		button_instance.item = recipe
		parent_node.add_child(button_instance)
	pass
	
