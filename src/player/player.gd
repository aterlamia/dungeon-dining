class_name Player
extends CharacterBody3D

@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 20.0
@export var rotation_speed := 12.0

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 8.0

var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK

@export_group("Gravity")
@export var gravity := -30.0
@export var jump_impulse := 12.0

var _camera_pivot: Node3D =null
var _camera: Camera3D = null
var _skin: Node3D = null
var carringOrder = null
var gettingFood = false

func _ready() -> void:
	_skin = get_node("Char")
	_camera = get_node("CameraController/SpringArm3D/Camera3D")
	_camera_pivot = get_node("CameraController")
	get_node("CameraController/SpringArm3D/Camera3D").make_current()
	
func _on_col_detector_body_entered(body: Node3D) -> void:
	if body.name == "DispencerAura":
		gettingFood = true
		
func _on_col_detector_body_exited(body: Node3D) -> void:
	if body.name == "DispencerAura":
		gettingFood = false	

func delivered():
	var returnOrder = carringOrder
	carringOrder = null
	var indicator = get_node("Indicator")
	indicator.visible = false
	
	return returnOrder
	
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


func _physics_process(delta: float) -> void:
	_camera_pivot.rotation.x += -_camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, tilt_lower_limit, tilt_upper_limit)
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta

	_camera_input_direction = Vector2.ZERO

	var movement_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	var move_direction := forward * movement_vector.y + right * movement_vector.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()

	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	velocity.y = y_velocity + gravity * delta

	var is_starting_jump := Input.is_action_just_pressed("jump") and is_on_floor()
	if is_starting_jump:
		velocity.y += jump_impulse

	move_and_slide()

	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.rotation.y, target_angle, rotation_speed * delta)

	if is_starting_jump:
		print("jump")
	elif not is_on_floor() and velocity.y < 0:
		print("falling")
	elif is_on_floor():
		var ground_speed := velocity.length()
		if ground_speed > 0.0:
			_skin.get_node("AnimationPlayer").play("Move")
			_skin.get_node("AnimationPlayer").speed_scale = 2
		else:
			_skin.get_node("AnimationPlayer").play("Walking")
			_skin.get_node("AnimationPlayer").speed_scale = 1.2

func _process(delta: float) -> void:
	if gettingFood && Input.is_action_just_pressed("action") && carringOrder == null: 
		var dispencer: Dispencer = get_node("%Dispencer")
		carringOrder = dispencer.pickup()
		if carringOrder != null:
			var indicator = get_node("Indicator")
			indicator.visible = true
			indicator.mesh.material.albedo_color = carringOrder.wants_color
			return
		
	if carringOrder != null && Input.is_action_just_pressed("action"):
		get_node("/root/Events").on_deliver_attempt(carringOrder)
		return
