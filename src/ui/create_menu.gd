extends CanvasLayer
func _on_close_button_pressed() -> void:
	print ("Close button pressed")
	visible = false
	get_node("/root/Events").on_in_menu(false)
	pass