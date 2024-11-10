class_name CameraController

extends Node3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.30
@export var tilt_upper_limit := PI / 4.0
@export var tilt_lower_limit := -PI / 9.0

var _camera_input_direction := Vector2.ZERO

func _ready() -> void:
	get_node("/root/Events").camera_switch.connect(_on_camera_switch)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _on_camera_switch(camera: String) -> void:
	match camera:
		"PLAYER":
			
	
func _input(event: InputEvent) -> void:	
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity


func _process(delta: float) -> void:
	rotation.x += -_camera_input_direction.y * delta
	rotation.x = clamp(rotation.x, tilt_lower_limit, tilt_upper_limit)
	rotation.y -= _camera_input_direction.x * delta

	_camera_input_direction = Vector2.ZERO