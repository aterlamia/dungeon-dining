class_name Player
extends CharacterBody3D

@export var inAttackForm: bool = false
@export var in3thPerson: bool = false
@export var hitpoints := 30.0
@export var maxHitpoints := 30.0
@export var damage := 2
@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 20.0
@export var rotation_speed := 62.0
var battleSpeed = 12
var battleName = "You"
var _last_movement_direction := Vector3.BACK
@export var camRes: Camera3D = null
@export var camKit: Camera3D = null

@export_group("Gravity")
@export var gravity := -30.0
@export var jump_impulse := 12.0
var nots: Notification = null

# Create a BoneAttachment3D node

var _camera_pivot: Node3D =null
var _camera: Camera3D = null
var _skin: Node3D = null
var animation_player: AnimationPlayer = null
var carringOrder = null
var gettingFood = false
var global: GlobalState = null
var waitingForCamSwitch = false 
var bubble: Sprite3D = null
var inStairs = false
var inStairsUp = false

func _on_switch(camera: String) -> void:
	waitingForCamSwitch = true
	if camera == "player":
		get_node("CameraController/SpringArm3D/Camera3D").make_current()
		_camera = get_node("CameraController/SpringArm3D/Camera3D")
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
func _ready() -> void:
	get_node("/root/Events").camera_switch.connect(_on_switch)
	get_node("/root/Events").damage_player.connect(damage_player)
	_skin = get_node("player")
	animation_player = _skin.get_node("AnimationPlayer")
	_camera = get_node("CameraController/SpringArm3D/Camera3D")
	_camera_pivot = get_node("CameraController")
	global = get_node("/root/Global")
	get_node("CameraController/SpringArm3D/Camera3D").make_current()
	_skin.get_node("Armature/Skeleton3D/ServePlate").visible = false
	nots = get_node("SubViewport/Notifications")
	bubble = get_node("player/Bubble2")
	bubble.visible = false
		
func damage_player(damage: float):
	hitpoints -= damage
	if hitpoints <= 0:
		get_node("/root/Events").on_gameover()
		
func _on_col_detector_area_entered(body: Area3D) -> void:
	print(body.name)	
	if body.name == "Hatch":
		bubble.visible = true
		nots.setAction("down")
		bubble.position = Vector3(0.1, 2.3, 0)
		inStairs = true	
	if body.name == "Stairs":
		bubble.visible = true
		nots.setAction("up")
		bubble.position = Vector3(0.1, 2.3, 0)
		inStairsUp = true	
	if body.name == "DispencerAura" and !gettingFood:
		gettingFood = true
		bubble.visible = true
		nots.setAction("pickup")
		bubble.position = Vector3(-1, 1.5, 0)
		
func _on_col_detector_area_exited(body: Area3D) -> void:
	if body.name == "Hatch":
		bubble.visible = false
		inStairs = false
	if body.name == "DispencerAura":
		gettingFood = false
		bubble.visible = false
	if body.name == "Stairs":
		bubble.visible = false
		inStairsUp = false
		
			
func delivered():
	var returnOrder = carringOrder
	carringOrder = null
	return returnOrder
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("left_click"):
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		pass

func innpcAura(isIn: bool):
	bubble.position = Vector3(0.1, 2.3, 0)	
	bubble.visible = isIn && carringOrder != null
	nots.setAction("deliver")
	pass


func attack():
	get_node("StateMachine")._transition_to_next_state("Attack")
	pass
func attackStance():
	get_node("StateMachine")._transition_to_next_state("FightingIdle")
	pass
	
func _physics_process(delta: float) -> void:
	if (global.pauzed || inAttackForm):
		return

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
	
	var isAction := Input.is_action_just_pressed("action")
	if isAction and inStairs:
		get_node("/root/Events").on_scene_restarted(2)
	if isAction and inStairsUp:
		get_node("/root/Events").on_scene_restarted(1)
	move_and_slide()

	if move_direction.length() > 0.05:
		_last_movement_direction = move_direction
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.rotation.y, target_angle, rotation_speed * delta)

func _process(delta: float) -> void:
	if (global.pauzed || inAttackForm):
		return
		
	if waitingForCamSwitch and velocity.length() == 0:
		switchCurrentCamera3D()
	

func switchCurrentCamera3D():
	waitingForCamSwitch = false
	if camRes != null && camRes.current:
		_camera = camRes
	elif camKit != null && camKit.current:
		_camera = camKit
	_camera.make_current()
	
