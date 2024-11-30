extends CanvasLayer

func _on_dialog_dialog_done(what_dialog: String, currentPos: int) -> void:
	if what_dialog == "StoryCeller":
		if currentPos == 2:
			visible = true
			get_node("/root/Events").on_in_menu(true)
			return
		return
	pass # Replace with function body.


func _on_btn_1_pressed() -> void:
	$Story1.visible = false
	$Story2.visible = true
	pass # Replace with function body.
	
func _on_btn_2_pressed() -> void:
	$Story2.visible = false
	$Story3.visible = true
	pass
		
func _on_btn_3_pressed() -> void:
	$Story3.visible = false
	$Story4.visible = true
	pass	
	
func _on_btn_4_pressed() -> void:
	visible = false
	get_node("/root/Events").on_in_menu(false)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass	