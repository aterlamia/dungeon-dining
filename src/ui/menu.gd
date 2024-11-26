class_name MenuScreen
extends Panel

@export var baseMenuGroup: PackedScene = null
@export var baseMenuItem: PackedScene = null
@export var menuSlots: Dictionary[String, MenuItemGroup]

var global: GlobalState = null
var events = null

var recipeDict: Dictionary[String, Node]
var log

func _ready() -> void: 
	self.log = get_node("/root/Log")
	recipeDict = {}
	events = get_node("/root/Events")
	events.recipe_added.connect(_on_recipe_added)
	global = get_node("/root/Global")
	for slot in menuSlots.values():
		slot.visible = false
	pass # Replace with function body.

func _on_recipe_added(recipe: String, amount: int) -> void:
	var group: MenuItemGroup = null 
	var rec: Recipe = global.availableRecipies[recipe]
	
	for ingredient in rec.ingredients.keys():
		if global.game_state["ingredientsHold"].has(ingredient):
			if global.game_state["ingredientsHold"][ingredient] < rec.ingredients[ingredient] * amount:
				self.log.log_info("not enough for " + ingredient)
				return
		else:
			self.log.log_error("Unknown ingredient " + ingredient)
			return
	
	if recipeDict.has(rec.type) == true:
		global.setFilledSlot(rec.type, amount)
		var curAmount = global.getFilledSlot(rec.type)
		recipeDict[rec.type].get_node('Amount').text = "[right] x" + str(curAmount) + "[/right]"
		remove_ingredients(rec.ingredients, amount)
		return
		
	if(menuSlots.has(rec.group)):
		group = menuSlots[rec.group]
	else:
		return
	
	var item = baseMenuItem.instantiate()
	item.get_node('MenuItem').text = rec.name
	item.get_node('Amount').text = "[right] x" + str(amount) + "[/right]"
	item.get_node('Price').text =  "[right]" + str(rec.cost) + "[/right]"
	item.get_node('Subscript').text = "[i]" + rec.subtitle + "[/i]"
	group.visible = true
	
	global.setFilledSlot(rec.type, amount)
	recipeDict[rec.type] = item

	group.get_node("MarginContainer/VBoxContainer/Items").add_child(item)
	remove_ingredients(rec.ingredients, amount)

	pass
	
func _process(delta: float) -> void:
	pass

func remove_ingredients(recipe_ingredients: Dictionary, amount: int) -> void:
	for ingredient in recipe_ingredients.keys():
		if global.game_state["ingredientsHold"].has(ingredient):
			global.game_state["ingredientsHold"][ingredient] -= recipe_ingredients[ingredient] * amount
			if global.game_state["ingredientsHold"][ingredient] < 0:
				global.game_state["ingredientsHold"][ingredient] = 0
				
		else:
			log.log_error("Ingredient not found: " + ingredient, log.LogType.LOG_GENERAL)
	events.on_ingredients_updated()
