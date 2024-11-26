extends CanvasLayer
func _on_close_button_pressed() -> void:
	visible = false
	get_node("/root/Events").on_in_menu(false)
	pass