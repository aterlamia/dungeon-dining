class_name WantsManager

extends Node

var enable_process = false

func _ready() -> void:
	pass

func getRandomWant() -> String:
	var rng = RandomNumberGenerator.new()
	var choice = rng.randi_range(0, 2)
	
	if choice == 0:
		return "burger"
	elif choice == 1:
		return "steak"
	else:
		return "nuggets"
		
		
func getWantData(want: String) -> Dictionary:
	if want == "burger":
		return {
			"want": "burger",
			"cookingTime": 3,
			"eatingTime": 3,
			"color": Color(1, 0.5, 0.5)
		}
	elif want == "steak":
		return {
			"want": "steak",
			"cookingTime": 5,
			"eatingTime": 5,
			"color": Color(0.5, 1, 0.5)
		}
	else:
		return {
			"want": "nuggets",
			"cookingTime": 2,
			"eatingTime": 2,
			"color": Color(0.5, 0.5, 1)
		}