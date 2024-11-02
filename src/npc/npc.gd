class_name Npc

extends CharacterBody3D

@onready var agent: NavigationAgent3D = $NavigationAgent3D

var SPEED = 1
var target: Vector3
var targetTable: Table
var isSeated: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func updateTarget(target: Table) -> void:
	targetTable = target
	agent.set_target_position(targetTable.global_transform.origin)
	pass

func _physics_process(delta: float) -> void:
	if (targetTable == null):
		return
		
	look_at(target)
	rotation.x = 0
	rotation.z = 0
	
	if position.distance_to(target) > 0.2 && !isSeated:
		var curLoc = global_transform.origin
		var nexLoc = agent.get_next_path_position()
		var newVel = (nexLoc - curLoc).normalized() * SPEED
		velocity = newVel
		move_and_slide()
		
		
	if agent.is_target_reached() && !isSeated:
		isSeated = true
		var rng = RandomNumberGenerator.new()
		if rng.randf() > 0.5:
			position = targetTable.chair1.global_transform.origin
		else:
			position = targetTable.chair2.global_transform.origin
	pass
