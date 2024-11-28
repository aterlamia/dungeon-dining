extends MarginContainer

func _ready():
	get_node("Screen/Forward/TextEdit").text = InputMap.action_get_events("move_forward")[0].as_text().replace(" (Physical)", "")
	get_node("Screen/Backward/TextEdit").text = InputMap.action_get_events("move_backward")[0].as_text().replace(" (Physical)", "")
	get_node("Screen/Left/TextEdit").text = InputMap.action_get_events("move_left")[0].as_text().replace(" (Physical)", "")
	get_node("Screen/Right/TextEdit").text = InputMap.action_get_events("move_right")[0].as_text().replace(" (Physical)", "")
	get_node("Screen/Action/TextEdit").text = InputMap.action_get_events("action")[0].as_text().replace(" (Physical)", "")
	pass
	
func _on_text_edit_gui_input(event: InputEvent, action: String):
	if event is not InputEventKey:
		return
	
	var key = event.get_keycode()
	updateKeys(action, key)


func updateKeys(action:String, keyCode):
	InputMap.erase_action(action)
	var new_key_event = InputEventKey.new()
	new_key_event.physical_keycode = keyCode
	InputMap.add_action(action)
	InputMap.action_add_event(action, new_key_event)
	updateText(action, keyCode)

func updateText(action:String, keyCode: int):
	var key = OS.get_keycode_string(keyCode)
	match action:
		"move_forward":
			get_node("Screen/Forward/TextEdit").text = key
			return
		"move_backward":
			get_node("Screen/Backward/TextEdit").text = key
			return
		"move_left":
			get_node("Screen/Left/TextEdit").text = key
			return
		"move_right":
			get_node("Screen/Right/TextEdit").text = key
			return
		"action":
			get_node("Screen/Action/TextEdit").text = key
			return
	pass