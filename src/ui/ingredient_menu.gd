extends CanvasLayer

@export var baseButton: PackedScene = null
var global: GlobalState = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global = get_node("/root/Global")
	loadRecipies()
	get_node("/root/Events").ingredients_updated.connect(_on_ingredients_updated)
	pass # Replace with function body.


func _on_ingredients_updated():
	var parent_node = %Ingredients
	for child in parent_node.get_children():
		var available_amount = global.game_state["ingredientsHold"].get(child.ingredientName, 0)
		child.get_node("Label").text = str(available_amount)
	
	
func loadRecipies() -> void:
	var activeIngredients = global.game_state['ingredientsHold']
	var parent_node = %Ingredients
	for ingredient in activeIngredients:
		var available_amount = global.game_state["ingredientsHold"].get(ingredient, 0)
		var button_instance = baseButton.instantiate()
		var texture = load("res://assets/ui/" + ingredient + ".png")
		button_instance.get_node("TextureButton").texture_normal = texture
		button_instance.ingredientName = ingredient
		button_instance.get_node("Label").text = str(available_amount)

		parent_node.add_child(button_instance)
	pass
	
func _on_close_button_pressed():
	if get_node("/root/Global").inTutorial and get_node("/root/Global").game_state["tutorialStep"] < 12:
		get_node("/root/Events").on_tutorial_switch(12)
	visible = false
	get_node("/root/Events").on_in_menu(false)
	pass
