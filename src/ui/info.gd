extends Control

@export var baseIngredient: PackedScene = null
@export var addButton: Button = null
var amount = 1
var global: GlobalState = null
var current: Recipe = null
var container: Control = null
var events: EventManager = null
func _ready() -> void:
	global = get_node("/root/Global")
	container = get_node("Container")
	events = get_node("/root/Events")
	events.recipe_selected.connect(_on_switch)
	events.ingredients_updated.connect(_on_ingredients_updated)
	container.visible = false
	
	pass


func _on_ingredients_updated() -> void:
	updateIngredients()
	if(!hasEnoughIngredientsForRecipe(current)):
		addButton.disabled = true
	pass
	
# wwhen swithcing to a recipe, show the recipe info	
func _on_switch(recipe: String) -> void:
	amount = 1
	current = null
	var chosen: Recipe = global.availableRecipies[recipe]
	# make sure there are enough ingredients

	if(!hasEnoughIngredientsForRecipe(chosen)):
		addButton.disabled = true
	else:
		addButton.disabled = false
	if chosen != null:
		container.visible = true
	
	current = chosen
	container.get_node("subtitle").text = chosen.subtitle
	container.get_node("Title").text = chosen.name
	container.get_node("priceVal").text = str(chosen.cost)
	container.get_node("levelVal").text = str(chosen.level)
	container.get_node("makesVal").text = str(chosen.makes)
	container.get_node("masteryVal").text = str(chosen.quality_multiplier)
	var texture = load(chosen.image)
	container.get_node("FoodPic").texture = texture
	updateIngredients()
	$Container.visible = true
	
func updateIngredients() -> void:
	if current == null:
		return
	for child in container.get_node("Ingredients").get_children():
		child.queue_free()
		pass
	for ingredient_name in current.ingredients.keys():
		var ingredient_instance = baseIngredient.instantiate()
		var available_amount = global.game_state["ingredientsHold"].get(ingredient_name, 0)
		ingredient_instance.get_node("IngredientAmount").text = str(current.ingredients[ingredient_name] * amount) + " / " + str(available_amount)
		
		var texture = load("res://assets/ui/" + ingredient_name + ".png")
				
		ingredient_instance.get_node("IngredientPic").texture = texture
		
		container.get_node("Ingredients").add_child(ingredient_instance)
		pass

func getMinimum(ing) -> int:
	var min_amount = null
	for ingredient_name in current.ingredients.keys():
		var required_amount = current.ingredients[ingredient_name]
		var available_amount = global.game_state["ingredientsHold"].get(ingredient_name, 0)
		var possible_amount = floor(available_amount / required_amount)
		
		if min_amount == null or possible_amount < min_amount:
			min_amount = possible_amount
	return min_amount		
	
func _on_add_pressed() -> void:
	amount += 1
	var min_amount = getMinimum(current.ingredients)
	amount = min(amount, min_amount) if min_amount != null else 0
	
	container.get_node("TextEdit").text = str(amount)
	updateIngredients()
	pass

func _on_remove_pressed() -> void:
	amount -= 1
	if amount < 1:
		amount = 1
		pass
	container.get_node("TextEdit").text = str(amount)
	updateIngredients()
	pass


func _on_text_edit_text_changed() -> void:
	var currentAmount = int(container.get_node("TextEdit").text)
	var min_amount = getMinimum(current.ingredients)
	if amount < 1:
		amount = 1
		pass
	currentAmount = min(currentAmount, min_amount) if min_amount != null else 0
	container.get_node("TextEdit").text = str(currentAmount)
	updateIngredients()
	pass 

# adds the chosen dish to the global state if enough ingredients are available
func _on_button_pressed() -> void:
	if(!hasEnoughIngredientsForRecipe(current)):
		addButton.disabled = true
		return
		
	global.addChosenDish(current.type, amount)
	events.on_recipe_added(current.type, amount)
	pass

func hasEnoughIngredientsForRecipe(chosen: Recipe):
	if chosen == null:
		return
	for ingredient in chosen.ingredients.keys():
		if global.game_state["ingredientsHold"].has(ingredient):
			if global.game_state["ingredientsHold"][ingredient] < chosen.ingredients[ingredient]:
				return false
		else:
			return false
	return true
