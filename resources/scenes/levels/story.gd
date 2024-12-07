extends CanvasLayer

func _on_dialog_dialog_done(what_dialog: String, currentPos: int) -> void:
	if what_dialog == "StoryCeller":
		if currentPos == 2:
			visible = true
			$Story1.visible = true
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
	$Story4.visible = false
	get_node("/root/Events").on_in_menu(true)
	get_parent().remove_child(get_parent().get_node("Objects/WallBoxes"))
	get_parent().get_node("Objects/WallBoxes").queue_free()
	get_node("/root/Events").on_start_battle('BabyVine', 1)
	get_node("/root/Events").on_play_music("Battle")
	
	pass	

func _on_btn_5_pressed() -> void:
	$Story5.visible = false
	$Story6.visible = true
	pass	
	
func _on_btn_6_pressed() -> void:
	$Story6.visible = false
	$Story7.visible = true
	pass	
	
func _on_btn_7_pressed() -> void:
	$Story7.visible = false
	$Story8.visible = true
	pass	
	
func _on_btn_8_pressed() -> void:
	$Story7.visible = false
	$Story8.visible = false
	visible = false
	pass	