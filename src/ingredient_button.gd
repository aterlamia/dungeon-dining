extends Panel

var ingredientName: String = ""

func _on_texture_button_pressed() -> void:
	print("ingredient_button: _on_texture_button_pressed " + ingredientName)
	if get_node("/root/Global").inTutorial && get_node("/root/Global").game_state["tutorialStep"] < 10:
		if ingredientName == "milk":	
			get_node("/root/Events").on_tutorial_switch(10)
		else:
			return
	get_node("/root/Events").on_ingredient_selected(ingredientName)
	pass
