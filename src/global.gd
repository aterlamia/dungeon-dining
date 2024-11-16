class_name GlobalState
extends Node

var pauzed: bool = false
var availableRecipies: Dictionary
var in_game: bool = false:
	get:
		return in_game
	set(value):
		in_game = value

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
}

var game_state: Dictionary = {
	"clicks": 0,
	"slotsAvailable": 5,
	"ingredientsHold": {
		"tomato": 7,
		"lettuce": 7,
		"beef": 6,
		"pork": 2,
		"bread": 2,
		"milk": 2,
		"potato": 1,
		"carrot": 1,
		"onion": 1
	},
	"chosenRecipies": [],
	"recipesAvailable": ['burger', 'hotdog', 'milkshake', 'gardensalad','soup'],
	"level": 0,
}

func _ready() -> void:
	init_recipes()
	pass
	
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


func init_recipes() -> void:
	var recipes = {}
	var recipe_data = [
                        {
                          "name": "Delicious Burger",
                          "subtitle": "Traditional beef patty with lettuce and tomato",
                          "level": 1,
                          "model": "res://models/burger.mesh",
                          "quality_multiplier": 1,
                          "cost": 5.99,
                          "type": "burger",
                          "makes": 1,
                          "group": "main",
                          "ingredients": {"tomato": 1, "lettuce": 1, "beef":1}
                        },
                        {
                          "name": "Hotdog",
                          "subtitle": "Classic hot dog with your choice of toppings",
                          "level": 1,
                          "model": "res://models/hotdog.mesh",
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
                          "model": "res://models/milkshake.mesh",
                          "quality_multiplier": 1,
                          "cost": 4.99,
                          "type": "milkshake",
                          "makes": 1,
                          "group": "main",
                          "ingredients": {"milk": 1}
                        },
                        {
                          "name": "Garden Salad",
                          "subtitle": "Fresh mixed greens",
                          "level": 1,
                          "model": "res://models/gardensalad.mesh",
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
                          "model": "res://models/soup.mesh",
                          "quality_multiplier": 1,
                          "cost": 4.49,
                          "type": "soup",
                          "makes": 4,
                          "group": "stew",
                          "ingredients": {"potato": 1, "carrot": 1, "onion":1, "beef":1}
                        }
                      ]

	for data in recipe_data:
		var recipe = Recipe.create_recipe(data["name"], data["subtitle"], data["level"], data["model"], data["quality_multiplier"], data["cost"], data["type"], data["makes"], data["group"], data["ingredients"])
		availableRecipies[data["type"]] = recipe
	pass
