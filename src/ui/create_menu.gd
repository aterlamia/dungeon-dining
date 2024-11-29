extends CanvasLayer
func _on_close_button_pressed() -> void:
	if get_node("/root/Global").inTutorial:
		var cur = get_node("/root/Global").getFilledSlot("milkshake") if get_node("/root/Global").hasFilledSlot("milkshake") else  0 
		print(cur)
		if get_node("/root/Global").game_state["tutorialStep"] == 7:
			get_node("/root/Events").on_tutorial_switch(8)
		elif cur == 3 and get_node("/root/Global").game_state["tutorialStep"] == 12:
			get_node("/root/Events").on_tutorial_switch(13)
		else:
			return
		pass
	pass
	visible = false
	get_node("/root/Events").on_in_menu(false)
	pass
