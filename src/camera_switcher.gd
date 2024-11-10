class_name CameraSwitcher

extends Node3D

@export var restaurant: Camera3D = null
@export var kitchen: Camera3D = null

func _ready() -> void:
	get_node("/root/Events").camera_switch.connect(_on_switch)


func _on_switch(camera: String) -> void:
	match camera:
		"restaurant":
			restaurant.make_current()
		"kitchen":
			kitchen.make_current()
			
func _on_restaurant_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		get_node("/root/Events").on_camera_switch("restaurant")
	pass

func _on_k_itchen_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		get_node("/root/Events").on_camera_switch("kitchen")
	pass
	
	