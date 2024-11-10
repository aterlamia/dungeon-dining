extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		_on_attempt()
	
func _on_attempt() -> void:
	var overlapping_bodies = get_overlapping_bodies()
		
	for body in overlapping_bodies:
		if body.name == "Player":
			print("Player entered")
			get_node("/root/Events").on_scene_restarted(2)
			break
	pass
