extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("/root/Events").on_camera_switch("restaurant")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func load() -> void:
	pass


