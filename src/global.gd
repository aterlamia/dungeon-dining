class_name GlobalState
extends Node

var pauzed: bool = false
var availableRecipies: Dictionary
var inTutorial: bool = false:
	get:
		return game_state["tutorialStep"] > -1 and game_state["tutorialStep"]  < 18

func _ready() -> void:
	init_recipes()
	get_node("/root/Events").in_menu.connect(_on_pauze)
	get_node("/root/Events").tutorial_switch.connect(_on_tut_switch)
	pass
	
	
func _on_tut_switch(nr: int) -> void:
	inTutorial = true
	game_state["tutorialStep"] = nr
	pass
	
func addChosenDish(dish: String, count: int) -> void:
	#if dish already in chosen_dishes, update count
	for i in range(chosen_dishes.size()):
		if chosen_dishes[i]["dish"] == dish:
			chosen_dishes[i]["count"] += count
			return
	chosen_dishes.append({"dish":dish, "count":count})
	pass
	
func _on_pauze(pauzed: bool) -> void:
	self.pauzed = pauzed
	pass
	
var in_game: bool = false:
	get:
		return in_game
	set(value):
		in_game = value
		
var restaurant_level: int = 0:
	get:
		return game_state["restaurant_level"]
	set(value):
		game_state["restaurant_level"] = value

var money: float = 3.6:
	get:
		return game_state["gold"]
	set(value):
		game_state["gold"] = value
		
var chosen_dishes: Array = []:
	get:
		return game_state["chosenRecipies"]
	set(value):
		game_state["chosenRecipies"] = value
				
var part_state: String = 'prepare':
	get:
		return game_state["partState"]
	set(value):
		game_state["partState"] = value

var config_data: Dictionary = {
	"fullscreen": false,
	"vsync": false,
	"fps": false,
	"mute_music": false,
	"mute_fx": false,
	"mute_ui": false,
	"volume_music": 0,
	"volume_ui": 0,
	"volume_fx": 0,
	"key_map": {
		'move_forward': KEY_W,
		'move_backwards':KEY_S,
		'move_left': KEY_A,
		'move_right':KEY_D,
		'action': KEY_E,
	}
}

var game_state: Dictionary = {
	"gold": 3.6,
	"tutorialStep": -1,
	"slotsAvailable": 5,
	"dayPartsAvailable": 1,
	"currentDayPart": 0,
	"partState": "prepare", # prepare, start
	"restaurant_level": 0, # 0 is the tutorial level
	"filledSlots": {
		
	},	
	"ingredientsHold": {
		"tomato": 2,
		"lettuce": 1,
		"beef": 2,
		"pork": 0,
		"bread": 0,
		"milk": 0,
		"potato": 0,
		"carrot": 0,
		"onion": 0
	},
	"chosenRecipies": [],
	"recipesAvailable": ['burger', 'hotdog', 'milkshake', 'gardensalad', 'soup'],
	"level": 0,
}

func set_game_data(data, key: String) -> void:
	if game_state.has(key):
		game_state[key] = data
	else:
		print("Key not found")
	
func apply_config(data: Dictionary):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), data['mute_music'])
	AudioServer.set_bus_mute(AudioServer.get_bus_index("fx"), data['mute_fx'])
	AudioServer.set_bus_mute(AudioServer.get_bus_index("ui"), data['mute_ui'])
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), data['volume_music'])
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("fx"), data['volume_fx'])
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("ui"), data['volume_ui'])

	if(data['vsync']):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			
	if(data['fullscreen']):
		get_tree().root.mode = Window.MODE_FULLSCREEN
	else:
		get_tree().root.mode = Window.MODE_WINDOWED
		
	get_node("/root/Events").on_fps_displayed(data['fps'])
	
	config_data = data

func getIngredient(name: String):
	var ingredients = {
		"tomato": {
			"title": "Tomato",
			"image": "res://assets/images/ingredients/tomato.png",
			"price": 1.0,
			"description": "Fresh and juicy tomato"
		},
		"lettuce": {
			"title": "Lettuce",
			"image": "res://assets/images/ingredients/lettuce.png",
			"price": 0.5,
			"description": "Crisp and green lettuce"
		},
		"beef": {
			"title": "Beef",
			"image": "res://assets/images/ingredients/beef.png",
			"price": 5.0,
			"description": "High-quality beef"
		},
		"pork": {
			"title": "Pork",
			"image": "res://assets/images/ingredients/pork.png",
			"price": 4.0,
			"description": "Tender pork"
		},
		"bread": {
			"title": "Bread",
			"image": "res://assets/images/ingredients/bread.png",
			"price": 1.5,
			"description": "Freshly baked bread"
		},
		"milk": {
			"title": "Milk",
			"image": "res://assets/images/ingredients/milk.png",
			"price": 1.2,
			"description": "Rich and creamy milk"
		},
		"potato": {
			"title": "Potato",
			"image": "res://assets/images/ingredients/potato.png",
			"price": 0.8,
			"description": "Starchy potato"
		},
		"carrot": {
			"title": "Carrot",
			"image": "res://assets/images/ingredients/carrot.png",
			"price": 0.6,
			"description": "Crunchy carrot"
		},
		"onion": {
			"title": "Onion",
			"image": "res://assets/images/ingredients/onion.png",
			"price": 0.7,
			"description": "Flavorful onion"
		}
	}
	return ingredients[name]

func init_recipes() -> void:
	var recipe_data = [
						{
						  "name": "Coffee",
						  "subtitle": "Plain old cup of joe",
						  "level": 0,
						  "model": "res://resources/scenes/food/coffee.tscn",
						  "image": "res://assets/images/food/coffee.png",
						  "quality_multiplier": 1,
						  "cost": 1.99,
						  "type": "coffee",
						  "makes": 999999999,
						  "group": "drinks",
						  "ingredients": {}
						},
						{
						  "name": "Delicious Burger",
						  "subtitle": "Traditional beef patty with lettuce and tomato",
						  "level": 1,
						  "model": "res://resources/scenes/food/burger.tscn",
						  "image": "res://assets/images/food/burger.png",
						  "quality_multiplier": 1,
						  "cost": 5.99,
						  "type": "burger",
						  "makes": 1,
						  "group": "main",
						  "ingredients": {"tomato": 1, "lettuce": 1, "beef":1}
						},
						{
						  "name": "Monsterous Burger",
						  "subtitle": "Amazing beef patty with \"lettuce\" and tomato",
						  "level": 1,
						  "model": "res://resources/scenes/food/burger.tscn",
						  "image": "res://assets/images/food/burger.png",
						  "quality_multiplier": 1.1,
						  "cost": 6.49,
						  "type": "carn_burger",
						  "makes": 1,
						  "group": "main",
						  "ingredients": {"tomato": 1, "carn_vines": 1, "beef":1}
						},
						{
						  "name": "Hotdog",
						  "subtitle": "Classic hot dog with your choice of toppings",
						  "level": 1,
						  "model": "res://resources/scenes/food/hotdog.tscn",
						  "image": "res://assets/images/food/hotdog.png",
						  "quality_multiplier": 1,
						  "cost": 3.99,
						  "type": "hotdog",
						  "makes": 2,
						  "group": "main",
						  "ingredients": {"pork": 1, "bread": 1}
						},
						{
						  "name": "Milkshake",
						  "subtitle": "Vanilla, chocolate, or strawberry",
						  "level": 1,
						  "model": "res://resources/scenes/food/milkshake.tscn",
						  "image": "res://assets/images/food/shake.png",
						  "quality_multiplier": 1,
						  "cost": 4.99,
						  "type": "milkshake",
						  "makes": 1,
						  "group": "desert",
						  "ingredients": {"milk": 1}
						},
						{
						  "name": "Garden Salad",
						  "subtitle": "Fresh mixed greens",
						  "level": 1,
						  "model": "res://resources/scenes/food/salad.tscn",
						  "image": "res://assets/images/food/salad.png",
						  "quality_multiplier": 1,
						  "cost": 6.99,
						  "type": "gardensalad",
						  "makes": 1,
						  "group": "side",
						  "ingredients": {"tomato": 2, "lettuce": 2}
						},
						{
						  "name": "Soup",
						  "subtitle": "Warm and comforting",
						  "level": 1,
						  "model": "res://resources/scenes/food/soup.tscn",
						  "image": "res://assets/images/food/soup.png",
						  "quality_multiplier": 1,
						  "cost": 4.49,
						  "type": "soup",
						  "makes": 4,
						  "group": "stew",
						  "ingredients": {"potato": 1, "carrot": 1, "onion":1, "beef":1}
						}
					  ]

	for data in recipe_data:
		var recipe = Recipe.create_recipe(data["name"], data["subtitle"], data["level"], data["model"],data["image"], data["quality_multiplier"], data["cost"], data["type"], data["makes"], data["group"], data["ingredients"])
		availableRecipies[data["type"]] = recipe
	pass
	
func getFilledSlot(type: String) -> int:
	return game_state.filledSlots[type]
	
func hasFilledSlot(type: String) -> bool:
	return game_state.filledSlots.has(type)
	
func setFilledSlot(type: String, amount: int) -> void:
	if game_state.filledSlots.has(type):
		game_state.filledSlots[type] += amount
	else:
		if game_state.slotsAvailable < game_state.filledSlots.size():
			print("No slots available")
			return
		game_state.filledSlots[type] = amount
	pass

func deleteFilledSlot(type: String) -> void:
	if game_state.filledSlots.has(type):
		game_state.filledSlots.erase(type)
	else:
		print("Slot not found")
	pass
