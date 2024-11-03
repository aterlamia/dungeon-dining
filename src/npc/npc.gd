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
	notifications = get_node("SubViewport/Notifications")
	notifications.visible = false
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
			print("Player is in the aura")
			break
	pass
	
func _process(delta: float) -> void:
	if targetTable == null:
		return
		
	get_node("/root/Events").delivery_attempt.connect(_on_attempt)

	look_at(target)
	rotation.x = 0
	rotation.z = 0

	if agent.is_target_reached() and not isSeated:
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
