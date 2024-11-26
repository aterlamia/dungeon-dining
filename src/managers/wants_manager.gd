class_name WantsManager

extends Node

var enable_process = false

var rng: RandomNumberGenerator
func _ready() -> void:
		
		
	rng = RandomNumberGenerator.new()
	rng.randomize()
	pass

func getRandomWant() -> String:
	var global: GlobalState = get_node("/root/Global")
	var chosenDishes = global.chosen_dishes
	
	if chosenDishes.size() == 0:
		print("getRandomWant return ?")
		return ""

	rng.randomize()
	
	var choice = rng.randi_range(0, chosenDishes.size() - 1)
	global.chosen_dishes[choice]["count"] -= 1
	
	var dish = chosenDishes[choice]["dish"]
	if (global.chosen_dishes[choice]["count"] == 0):
		global.chosen_dishes.remove_at(choice)
	
	get_node("/root/Events").on_availability_updated()
	return dish
		
func getWantData(want: String) -> Recipe:
	var global: GlobalState = get_node("/root/Global")
	var availableRecipies = global.availableRecipies
	
	return availableRecipies[want]
