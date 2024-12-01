extends BasePlayerState
var _camera_input_direction := Vector2.ZERO
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
@export_group("Camera")
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 8.0

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0.0
	player.animation_player.play("Walk")
	var anim : Animation= player.animation_player.get_animation("Walk")
	anim.loop_mode =(Animation.LOOP_LINEAR)
	
func update(_delta: float) -> void:
	if(player.velocity.length() <= 0.1):
		finished.emit(IDLEFOLLOW)
	else:
		if !player.in3thPerson:
			print("Walking24")
			finished.emit(WALKING)
	pass

func handle_input(event: InputEvent) -> void:
	if (global.pauzed):
		return
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity
		
func physics_update(delta: float) -> void:
	var _camera: Camera3D = player._camera
	var _camera_pivot: Node3D = player._camera_pivot
	_camera_pivot.rotation.x += -_camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, tilt_lower_limit, tilt_upper_limit)
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta

	_camera_input_direction = Vector2.ZERO