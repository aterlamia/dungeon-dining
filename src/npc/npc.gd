class_name Npc

extends CharacterBody3D

@onready var agent: NavigationAgent3D = $NavigationAgent3D
var notifications: Notification

var SPEED = 4
var target: Vector3
var targetTable: Table
var isSeated: bool = false
var wantsManager: WantsManager
var customerName: String = "Npc"
var want: String
var happyness: int = 100
var eatTimer: Timer
var returnPosition: Vector3
var finished: bool = false
var deleting: bool = false

func setReturnPosition(position: Vector3) -> void:
	returnPosition = position
	pass

func _on_npc_aura_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		updateTarget(body)
	pass
	
func setWantsManager(manager: WantsManager) -> void:
	wantsManager = manager
	pass

func setName(name: String) -> void:
	customerName = name
	pass
	
func _ready() -> void:
	get_node("/root/Events").delivery_attempt.connect(_on_attempt)
	notifications = get_node("SubViewport/Notifications")
	notifications.visible = false
	eatTimer = Timer.new()
	eatTimer.set_wait_time(10.0) # Set the eating duration
	eatTimer.set_one_shot(true)
	eatTimer.connect("timeout", Callable(self, "_on_eatTimer_timeout"))
	add_child(eatTimer)
	print("ready")
	pass

func updateTarget(target: Table) -> void:
	targetTable = target
	agent.set_target_position(targetTable.global_transform.origin)
	pass

func _on_attempt(order) -> void:
	var aura: Area3D = get_node("NpcAura")
	var overlapping_bodies = aura.get_overlapping_bodies()
		
	for body in overlapping_bodies:
		if body.name == "Player":
			var deliveredOrder = body.delivered()
			eatTimer.start()
			notifications.visible = false
			if deliveredOrder != null:
				
				if deliveredOrder.dish == want:
					happyness = 100
					return
				else:
					happyness = 0
					return
			
			break
	pass
	
func _process(delta: float) -> void:
	if targetTable == null:
		return
		
	look_at(target)
	rotation.x = 0
	rotation.z = 0
	if deleting:
		return

	if agent.is_target_reached() and finished:
		print("deleting")
		deleting = true
		get_parent().remove_child(self)
		queue_free()
		return
	
	if agent.is_target_reached() and not isSeated and not finished:
		want = wantsManager.getRandomWant()
		notifications.setWant(want)
		isSeated = true
		get_node("/root/Events").on_customer_seated(self)
		notifications.visible = true
		notifications.startTimer()
		var rng = RandomNumberGenerator.new()
		if rng.randf() > 0.5:
			position = targetTable.chair1.global_transform.origin
		else:
			position = targetTable.chair2.global_transform.origin
	pass

func _physics_process(delta: float) -> void:
	if targetTable == null or isSeated:
		return

	if position.distance_to(target) > 0.2:
		var curLoc = global_transform.origin
		var nexLoc = agent.get_next_path_position()
		var newVel = (nexLoc - curLoc).normalized() * SPEED
		velocity = newVel
		move_and_slide()
	pass


func _on_eatTimer_timeout() -> void:
	isSeated = false
	finished = true
	notifications.visible = false
	agent.set_target_position(returnPosition)
