extends CanvasLayer

@export var baseButton: PackedScene = null
var global: GlobalState = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global = get_node("/root/Global")
	loadRecipies()
	pass # Replace with function body.


	
func loadRecipies() -> void:
	var activeIngredients = global.game_state['ingredientsHold']
	var parent_node = %Ingredients
	for ingredient in activeIngredients:
		var button_instance = baseButton.instantiate()
		var texture = load("res://assets/ui/" + ingredient + ".png")
		button_instance.get_node("TextureButton").texture_normal = texture
		button_instance.ingredientName = ingredient

		parent_node.add_child(button_instance)
	pass
	
