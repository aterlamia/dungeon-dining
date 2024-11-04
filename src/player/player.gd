extends CharacterBody3D

const SPEED = 3.5
const GRAVITY = 9.8

const JUMP_VELOCITY = 4.5

var carringOrder = null

var gettingFood = false
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
	
func _process(delta: float) -> void:
	var direction = Vector3()
	
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
	else:
		velocity.y -= GRAVITY * delta
		
	direction = direction.normalized() * SPEED
	velocity.x = direction.x
	velocity.z = direction.z
	direction = direction.normalized() * SPEED
	
	if gettingFood && Input.is_action_just_pressed("action") && carringOrder == null: 
		var dispencer: Dispencer = get_node("%Dispencer")
		carringOrder = dispencer.pickup()
		print(carringOrder)
		if carringOrder != null:
			var indicator = get_node("Indicator")
			indicator.visible = true
			indicator.mesh.material.albedo_color = carringOrder.wants_color
			return
		
	if carringOrder != null && Input.is_action_just_pressed("action"):
		get_node("/root/Events").on_deliver_attempt(carringOrder)
		return
	
	if direction.length() > 0:
		look_at(global_transform.origin + direction, Vector3.UP)

	move_and_slide()
