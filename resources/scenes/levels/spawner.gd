class_name Spawner

extends Marker3D

var spawnTimer: Timer
var logger
var tableManager: TableManager
@export var npcContainer: Node3D
func _ready() -> void:
	tableManager = get_node("%TableManager")
	logger = get_node("/root/Log")
	logger.log_error("Test: ", logger.LogType.LOG_SCENE)
		
	spawnTimer = Timer.new()
	spawnTimer.set_wait_time(2)
	spawnTimer.set_one_shot(false)
	spawnTimer.connect("timeout", Callable(self, "_on_spawnTimer_timeout"))
	add_child(spawnTimer)
	spawnTimer.start()
	pass # Replace with function body.

func _on_spawnTimer_timeout() -> void:
	logger.log_info("Trigger: ", logger.LogType.LOG_GENERAL)
	spawnUser()
	pass

func _process(delta: float) -> void:
	pass

func spawnUser() -> void:
	var freeTable = tableManager.getRandomFreeTable()
	
	if(freeTable == null):
		logger.log_error("No free tables found", logger.LogType.LOG_GENERAL)
		return
	freeTable.setOccupied(true)
	
	var npc_resource = load("res://resources/scenes/npc/Npc.tscn")
	var npc: Npc = npc_resource.instantiate()

	npc.position = self.global_transform.origin
	npcContainer.add_child(npc)
	npc.updateTarget(freeTable)
