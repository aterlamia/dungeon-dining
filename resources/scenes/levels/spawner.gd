class_name Spawner

extends Marker3D

var spawnTimer: Timer
var logger
var global: GlobalState
var wantsManager: WantsManager
var tableManager: TableManager
@export var npcContainer: Node3D
func _ready() -> void:
	tableManager = get_node("%TableManager")
	logger = get_node("/root/Log")
	global = get_node("/root/Global")
	get_node("/root/Events").diner_opened.connect( Callable(self, "_on_started"))
	spawnTimer = Timer.new()
	spawnTimer.set_wait_time(2)
	spawnTimer.set_one_shot(true)
	spawnTimer.connect("timeout", Callable(self, "_on_spawnTimer_timeout"))
	add_child(spawnTimer)
	wantsManager = get_node("/root/Wants")
	pass

func _on_started(open:bool) -> void:
	if(open):
		spawnTimer.start()
	else:
		spawnTimer.stop()
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
	if(global.inTutorial and global.game_state["tutorialStep"] > 14):
		return
		
	var level_data = getLevelData()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var wait_time = rng.randi_range(level_data["spawnRateMin"], level_data["spawnRateMax"])
	spawnTimer.set_wait_time(wait_time)
	spawnTimer.start()
	
	if (global.pauzed || global.game_state.partState == "prepare"):
		return
		
	var freeTable = tableManager.getRandomFreeTable()
	
	if(global.inTutorial):
		freeTable = tableManager.getTable(0)
		
	if(freeTable == null):
		return
		
	freeTable.setOccupied(true)
	
	var npc_resource = load("res://resources/scenes/npc/Npc.tscn")
	var npc: Npc = npc_resource.instantiate()

	npc.setName(getRandomName())
	npc.get_node("Npc/Mesh/AnimationPlayer").play("Walk")
	npc.get_node("Npc/Mesh/AnimationPlayer").speed_scale = 1.5
	npc.position = self.global_transform.origin
	npc.setWantsManager(wantsManager)
	npc.setReturnPosition(self.global_transform.origin)
	npcContainer.add_child(npc)
	npc.updateTarget(freeTable)
	
	
func getLevelData() -> Dictionary:
	var current_level:int = global.restaurant_level
	var level_data:Dictionary = {
		"maxVisitors": 0,
		"spawnRateMin": 10,
		"spawnRateMax": 20,
		"patienceMin": 10, # higher is more patience
		"patienceMax": 20,	
	}
	
	match current_level:
		0:
			level_data["maxVisitors"] = 4
			level_data["spawnRateMin"] = 10
			level_data["spawnRateMax"] = 20
			level_data["patienceMin"] = 10
			level_data["patienceMax"] = 20
		1:
			level_data["maxVisitors"] = 3
			level_data["spawnRateMin"] = 4
			level_data["spawnRateMax"] = 8
			level_data["patienceMin"] = 20
			level_data["patienceMax"] = 30
		2:
			level_data["maxVisitors"] = 4
			level_data["spawnRateMin"] = 3
			level_data["spawnRateMax"] = 6
			level_data["patienceMin"] = 30
			level_data["patienceMax"] = 40
		3:
			level_data["maxVisitors"] = 5
			level_data["spawnRateMin"] = 2
			level_data["spawnRateMax"] = 5
			level_data["patienceMin"] = 40
			level_data["patienceMax"] = 50
		4:
			level_data["maxVisitors"] = 6
			level_data["spawnRateMin"] = 1
			level_data["spawnRateMax"] = 3
			level_data["patienceMin"] = 50
			level_data["patienceMax"] = 60
		5:
			level_data["maxVisitors"] = 7
			level_data["spawnRateMin"] = 1
			level_data["spawnRateMax"] = 2
			level_data["patienceMin"] = 60
			level_data["patienceMax"] = 70
		6:
			level_data["maxVisitors"] = 8
			level_data["spawnRateMin"] = 1
			level_data["spawnRateMax"] = 2
			level_data["patienceMin"] = 70
			level_data["patienceMax"] = 80
		7:
			level_data["maxVisitors"] = 9
			level_data["spawnRateMin"] = 1
			level_data["spawnRateMax"] = 2
			level_data["patienceMin"] = 80
	
	return level_data
