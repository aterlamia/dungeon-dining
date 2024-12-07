extends Node3D
var events: EventManager = null
var global: GlobalState = null
func _ready() -> void:
	events = get_node("/root/Events")
	global = get_node("/root/Global")
	
	events.on_camera_switch("restaurant")
	events.on_money_changed(get_node("/root/Global").money)
	events.on_play_music("Restaurant")
	get_node("KitchenCam").make_current()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func load() -> void:
	if(global.game_state["tutorialStep"] < 0):
		events.on_tutorial_switch(1)
	pass
