class_name Spawner

extends Marker3D

var spawnTimer: Timer
var logger
var wantsManager: WantsManager
var tableManager: TableManager
@export var npcContainer: Node3D
func _ready() -> void:
	tableManager = get_node("%TableManager")
	logger = get_node("/root/Log")
		
	spawnTimer = Timer.new()
	spawnTimer.set_wait_time(2)
	spawnTimer.set_one_shot(false)
	spawnTimer.connect("timeout", Callable(self, "_on_spawnTimer_timeout"))
	add_child(spawnTimer)
	spawnTimer.start()
	wantsManager = get_node("/root/Wants")
	pass

func _on_spawnTimer_timeout() -> void:
	spawnUser()
	pass

func _process(delta: float) -> void:
	pass

func getRandomName() -> String:
	var first_names = ["Alice", "Bob", "Charlie", "Diana", "Eve", "Frank", "Grace", "Hank", "Ivy", "Jack", "Karen", "Leo", "Mona", "Nina", "Oscar", "Paul", "Quinn", "Rose", "Sam", "Tina"]
	var last_names = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin"]
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var first_name = first_names[rng.randi_range(0, first_names.size() - 1)]
	var last_name = last_names[rng.randi_range(0, last_names.size() - 1)]
	var full_name = first_name + " " + last_name
	return full_name
	
func spawnUser() -> void:
	var freeTable = tableManager.getRandomFreeTable()
	
	if(freeTable == null):
		logger.log_error("No free tables found", logger.LogType.LOG_GENERAL)
		return
	freeTable.setOccupied(true)
	
	var npc_resource = load("res://resources/scenes/npc/Npc.tscn")
	var npc: Npc = npc_resource.instantiate()

	npc.setName(getRandomName())
	
	npc.position = self.global_transform.origin
	npc.setWantsManager(wantsManager)
	npcContainer.add_child(npc)
	npc.updateTarget(freeTable)
