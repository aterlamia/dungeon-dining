extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("/root/Events").in_menu.connect(_in_menu)
	get_node("/root/Events").end_battle.connect(_battle_done)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

func _battle_done() -> void:
	if(get_node("/root/Global")["game_state"]['firstFightDone'] == false):
		get_node("/root/Global")["game_state"]['firstFightDone'] = true
		get_node("Story").visible = true
		get_node("Story/Story5").visible = true
		
	get_node("/root/Events").on_in_menu(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass
	
func _in_menu(in_menu: bool) -> void:
	if in_menu:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load() -> void:
	get_node("/root/Events").on_camera_switch("player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Player._skin.get_node("AnimationPlayer").play("Idle")
	if get_node("/root/Global").game_state["tutorialStep"] > 14:
		$Dialog.visible = true
		$Dialog.switch(0)
		get_node("/root/Events").on_in_menu(true)
	pass
