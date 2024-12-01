class_name PlayerStateMachine extends Node
var global: GlobalState = null
@export var initial_state: PlayerState = null

@onready var state: PlayerState = (func get_initial_state() -> PlayerState:
	return initial_state if initial_state != null else get_child(0)
).call()

var logger: Log

func _ready() -> void:
	global = get_node("/root/Global")
	logger = get_node("/root/Log")
	for state_node: PlayerState in find_children("*", "PlayerState"):
		state_node.finished.connect(_transition_to_next_state)

	await owner.ready
	state.enter("")


func _unhandled_input(event: InputEvent) -> void:
	if global.pauzed:
		return	
	state.handle_input(event)


func _process(delta: float) -> void:
	if global.pauzed:
		return
	state.update(delta)


func _physics_process(delta: float) -> void:
	if global.pauzed:
		return
	state.physics_update(delta)


func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	logger.log_info("State transitioned to: " + target_state_path + " for player", logger.LogType.LOG_STATE)
	if not has_node(target_state_path):
		printerr(owner.name + ": Trying to transition to state " + target_state_path + " but it does not exist.")
		return

	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)
