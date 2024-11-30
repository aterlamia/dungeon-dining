extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func load() -> void:
	get_node("/root/Events").on_camera_switch("PLAYER")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Player._skin.get_node("AnimationPlayer").play("Idle")
	if get_node("/root/Global").game_state["tutorialStep"] > 14:
		get_node("/root/Events").on_in_menu(false)
		$Dialog.visible = true
		$Dialog.switch(0)
		get_node("/root/Events").on_in_menu(true)
		
	
	pass
