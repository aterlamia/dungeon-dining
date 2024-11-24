extends Control

@export var baseIngredient: PackedScene = null
var amount = 1
var current: Recipe = null

func _ready() -> void:
	get_node("/root/Events").recipe_selected.connect(_on_switch)
	get_node("/root/Events").ingredients_updated.connect(_on_ingredients_updated)
	get_node("Container").visible = false
	pass


func _on_ingredients_updated() -> void:
	updateIngredients()
	pass
	
func _on_switch(recipe: String) -> void:
	amount = 1
	current = null
	var chosen: Recipe = get_node("/root/Global").availableRecipies[recipe]
	if chosen != null:
		get_node("Container").visible = true
	
	current = chosen
	get_node("Container/subtitle").text = chosen.subtitle
	get_node("Container/Title").text = chosen.name
	get_node("Container/priceVal").text = str(chosen.cost)
	get_node("Container/levelVal").text = str(chosen.level)
	get_node("Container/makesVal").text = str(chosen.makes)
	get_node("Container/masteryVal").text = str(chosen.quality_multiplier)
	updateIngredients()
	$Container.visible = true
	
func updateIngredients() -> void:
	for child in get_node("Container/Ingredients").get_children():
		child.queue_free()
		pass
	for ingredient_name in current.ingredients.keys():
		var ingredient_instance = baseIngredient.instantiate()
		var available_amount = get_node("/root/Global").game_state["ingredientsHold"].get(ingredient_name, 0)
		ingredient_instance.get_node("IngredientAmount").text = str(current.ingredients[ingredient_name] * amount) + " / " + str(available_amount)
		get_node("Container/Ingredients").add_child(ingredient_instance)
		pass

func getMinimum(ing) -> int:
	var min_amount = null
	for ingredient_name in current.ingredients.keys():
		var required_amount = current.ingredients[ingredient_name]
		var available_amount = get_node("/root/Global").game_state["ingredientsHold"].get(ingredient_name, 0)
		var possible_amount = floor(available_amount / required_amount)
	
		if min_amount == null or possible_amount < min_amount:
			min_amount = possible_amount
	return min_amount		
func _on_add_pressed() -> void:
	amount += 1
	var min_amount = getMinimum(current.ingredients)
	amount = min(amount, min_amount) if min_amount != null else 0
	
	get_node("Container/TextEdit").text = str(amount)
	updateIngredients()
	pass

func _on_remove_pressed() -> void:
	amount -= 1
	if amount < 1:
		amount = 1
		pass
	get_node("Container/TextEdit").text = str(amount)
	updateIngredients()
	pass


func _on_text_edit_text_changed() -> void:
	var amount = int(get_node("Container/TextEdit").text)
	print("Amount: %d" % amount)
	var min_amount = getMinimum(current.ingredients)
	if amount < 1:
		amount = 1
		pass
	amount = min(amount, min_amount) if min_amount != null else 0
	get_node("Container/TextEdit").text = str(amount)
	updateIngredients()
	pass # Replace with function body.

func _on_button_pressed() -> void:
	var chosen: Recipe = get_node("/root/Global").addChosenDish(current.type, amount)
	get_node("/root/Events").on_recipe_added(current.type, amount)
	pass # Replace with function body.
