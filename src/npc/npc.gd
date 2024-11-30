class_name Npc

extends CharacterBody3D

signal stateChange(next_state_path: String, data: Dictionary)

@onready var agent: NavigationAgent3D = $NavigationAgent3D
var notifications: Notification

var SPEED = 4
var targetTable: Table
var isSeated: bool = false
var wantsManager: WantsManager
var customerName: String = "Npc"
var want: String = ""
var happyness: int = 100
var eatTimer: Timer
var returnPosition: Vector3
var finished: bool = false
var deleting: bool = false
var global: GlobalState = null
var _skin: Node3D = null
var _last_movement_direction := Vector3.BACK
var animation_player: AnimationPlayer

func _ready() -> void:
	get_node("/root/Events").delivery_attempt.connect(_on_attempt)
	global = get_node("/root/Global")
	notifications = get_node("SubViewport/Notifications")
	notifications.wait_expired.connect(_onNotificationExpired)
	_skin = get_node("Npc/Mesh")
	animation_player = _skin.get_node("AnimationPlayer")
	pass


func _onNotificationExpired() -> void:
	if !finished:
		finished = true
		agent.set_target_position(returnPosition)
		stateChange.emit("Walking")
	pass
	
func setReturnPosition(position: Vector3) -> void:
	returnPosition = position
	pass

func _on_npc_aura_area_entered(body: Area3D) -> void:
	if body.name == "ColDetectorPlayer":
		body.get_parent().innpcAura(true)
	pass
	
func _on_npc_aura_area_exited(body: Area3D) -> void:
	if body.name == "ColDetectorPlayer":
		body.get_parent().innpcAura(false)
	
func setWantsManager(manager: WantsManager) -> void:
	wantsManager = manager
	pass

func setName(name: String) -> void:
	customerName = name
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
			stateChange.emit("Eating")
			
			if deliveredOrder != null:
				if deliveredOrder.dish == want:
					happyness = 100
					return
				else:
					happyness = 0
					return
			
			break
	pass
