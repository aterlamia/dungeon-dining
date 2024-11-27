extends Panel

var ingredientName: String = ""

func _on_texture_button_pressed() -> void:
	get_node("/root/Events").on_ingredient_selected(ingredientName)
	pass