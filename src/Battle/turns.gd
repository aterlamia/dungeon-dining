extends Node

@export var playerLoc: Marker3D = null
@export var enemyLoc1: Marker3D = null
@export var enemyLoc2: Marker3D = null
@export var enemyLoc3: Marker3D = null
@export var enemyLoc4: Marker3D = null
@export var enemyLoc5: Marker3D = null

@export var attackbtn : TextureButton = null
@export var defendbtn : TextureButton = null
@export var fleebtn : TextureButton = null

var turn_order: Array = []
var playerCount: float = 0
var enemy1Count: float = 0
var enemy2Count: float = 0
var enemy3Count: float = 0
var enemy4Count: float = 0
var enemy5Count: float = 0

signal battle_end

var turnsRunning: bool = false

var player: Player = null
@export var battleMenuQueue: VBoxContainer = null

var attackPending: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attackbtn.disabled = true
	defendbtn.disabled = true
	fleebtn.disabled = true
	calculate_turn_order()	
	player = playerLoc.get_child(0)
	player.inAttackForm = true
	enemyLoc1.get_child(0).get_node("EnemyModel/AnimationPlayer").play("Idle")
	pass # Replace with function body.

func _process(delta: float) -> void:
	if !turnsRunning:
		return
		
	update_counts(delta)
	update_progress_bar()
	if(!attackPending || turn_order[0] != "Player"):
		attackbtn.disabled = true
		defendbtn.disabled = true
		fleebtn.disabled = true
	else:
		attackbtn.disabled = false
		defendbtn.disabled = false
		fleebtn.disabled = false
	if attackPending and turn_order[0] != "Player":
		attackPending = false
		setToValueForName(turn_order[0], 0)
		var loc = getLocByName(turn_order[0])
		##wait for animation to finish
		loc.get_child(0).get_node("EnemyModel/AnimationPlayer").play("Attack")
		await loc.get_child(0).get_node("EnemyModel/AnimationPlayer").animation_finished
		loc.get_child(0).get_node("EnemyModel/AnimationPlayer").play("Idle")
		loc.get_child(0).attack()
		if turn_order.size() > 0:
			turn_order.pop_front()
		calculate_turn_order()
	
	#check all enemies for death
	var enemies = [
		{"name": "Enemy1", "node": enemyLoc1},
		{"name": "Enemy2", "node": enemyLoc2},
		{"name": "Enemy3", "node": enemyLoc3},
		{"name": "Enemy4", "node": enemyLoc4},
		{"name": "Enemy5", "node": enemyLoc5}
	]
	#check if all enemies are dead if so end battle 
	var enemiesLeft = 0;
	for enemy in enemies:
		var node = null
		if(enemy["node"].get_child_count() != 0):
			enemiesLeft += 1
			
	if enemiesLeft == 0:
		turnsRunning = false
		battle_end.emit()
		return
	
func calculate_turn_order() -> void:
	# Reset turn order and UI
	turn_order.clear()
	for child in battleMenuQueue.get_children():
		child.get_node("Label").text = ""
	
	var participants = [
		{"name": "Player", "loc": playerLoc, "count": playerCount},
		{"name": "Enemy1", "loc": enemyLoc1, "count": enemy1Count},
		{"name": "Enemy2", "loc": enemyLoc2, "count": enemy2Count},
		{"name": "Enemy3", "loc": enemyLoc3, "count": enemy3Count},
		{"name": "Enemy4", "loc": enemyLoc4, "count": enemy4Count},
		{"name": "Enemy5", "loc": enemyLoc5, "count": enemy5Count}
	]
	
	# Keep track of actions filled
	var actions_filled = 0
	
	# Continue until we have 6 actions queued
	while actions_filled < 6:
		var highest_count = -1
		var next_participant = null
		
		# Find participant with highest count
		for participant in participants:
			if participant["loc"].get_child_count() == 0:
				continue
				
			var curPar = participant["loc"].get_child(0)
			if curPar == null:
				continue
				
			# Only consider this participant if they're still in battle
			var speed = curPar.battleSpeed
			
			# Accumulate speed
			participant["count"] += speed
			
			# Track highest count
			if participant["count"] > highest_count:
				highest_count = participant["count"]
				next_participant = participant
		
		# If we found a next participant
		if next_participant != null:
			# Add to turn order
			turn_order.append(next_participant["name"])
			
			# Update UI
			var battle_name = next_participant["loc"].get_child(0).battleName
			var maxHitpoints = next_participant["loc"].get_child(0).maxHitpoints
			var currentHitpoints = next_participant["loc"].get_child(0).hitpoints
			var percent = (currentHitpoints / maxHitpoints) * 100
			battleMenuQueue.get_child(actions_filled).get_node("Label").text = battle_name
			battleMenuQueue.get_child(actions_filled).get_node("TextureRect/ProgressBar").value = percent
			
			# Subtract 100 from their count
			next_participant["count"] -= 100
			
			actions_filled += 1
	
	pass

	
	
func update_counts(delta: float) -> void:
	if attackPending:
		return
	var participants = [
		{"name": "Player", "loc": playerLoc, "count": playerCount},
		{"name": "Enemy1", "loc": enemyLoc1, "count": enemy1Count},
		{"name": "Enemy2", "loc": enemyLoc2, "count": enemy2Count},
		{"name": "Enemy3", "loc": enemyLoc3, "count": enemy3Count},
		{"name": "Enemy4", "loc": enemyLoc4, "count": enemy4Count},
		{"name": "Enemy5", "loc": enemyLoc5, "count": enemy5Count}
	]

	for participant in participants:
		if participant["loc"].get_child_count() == 0:
			continue
		var curPar = participant["loc"].get_child(0)
		if curPar == null:
			continue
		var speed = curPar.battleSpeed
		participant["count"] += speed * delta

	playerCount = participants[0]["count"]
	enemy1Count = participants[1]["count"]
	enemy2Count = participants[2]["count"]
	enemy3Count = participants[3]["count"]
	enemy4Count = participants[4]["count"]
	enemy5Count = participants[5]["count"]
	pass
	
func update_progress_bar() -> void:
	if turn_order.size() == 0:
		return

	var shown: Dictionary = {
		"Player": 0,
		"Enemy1": 0,
		"Enemy2": 0,
		"Enemy3": 0,
		"Enemy4": 0,
		"Enemy5": 0
	}
	for i in range(turn_order.size()):
		var participant_name = turn_order[i]
		var participant = null
		var count = 0.0
		var progressBar: ProgressBar = battleMenuQueue.get_child(i).get_node("ProgressBar")

		if participant_name == "Player":
			participant = playerLoc.get_child(0)
			count = playerCount
		elif participant_name == "Enemy1":
			participant = enemyLoc1.get_child(0)
			count = enemy1Count
		elif participant_name == "Enemy2":
			participant = enemyLoc2.get_child(0)
			count = enemy2Count
		elif participant_name == "Enemy3":
			participant = enemyLoc3.get_child(0)
			count = enemy3Count
		elif participant_name == "Enemy4":
			participant = enemyLoc4.get_child(0)
			count = enemy4Count
		elif participant_name == "Enemy5":
			participant = enemyLoc5.get_child(0)
			count = enemy5Count

		if participant != null:
			shown[participant_name] = shown[participant_name] + 1
			progressBar.value = ((count / 100.0) * 100.0) / shown[participant_name]
			if progressBar.value >= 100.0:
				progressBar.value = 100.0
				attackPending = true
				
func _on_attack_pressed() -> void:
	attackPending = false
	playerCount = 0
	playerLoc.get_child(0).attack()
	enemyLoc1.get_child(0).doDamage(player.damage)
	
	
	if turn_order.size() > 0:
		turn_order.pop_front()
	calculate_turn_order()
	pass

func setToValueForName(name: String, value: float) -> void:
	if name == "Player":
		playerCount = value
	elif name == "Enemy1":
		enemy1Count = value
	elif name == "Enemy2":
		enemy2Count = value
	elif name == "Enemy3":
		enemy3Count = value
	elif name == "Enemy4":
		enemy4Count = value
	elif name == "Enemy5":
		enemy5Count = value
	pass
	
func getLocByName(name: String) -> Marker3D:
	if name == "Player":
		return playerLoc
	elif name == "Enemy1":
		return enemyLoc1
	elif name == "Enemy2":
		return enemyLoc2
	elif name == "Enemy3":
		return enemyLoc3
	elif name == "Enemy4":
		return enemyLoc4
	elif name == "Enemy5":
		return enemyLoc5
	return null
	pass
	
func connectDeathByName(name: String):
	if name == "Player":
		return
	elif name == "Enemy1":
		enemyLoc1.get_child(0).died.connect(_on_enemy_death)
	elif name == "Enemy2":
		enemyLoc2.get_child(0).died.connect(_on_enemy_death)
	elif name == "Enemy3":
		enemyLoc3.get_child(0).died.connect(_on_enemy_death)
	elif name == "Enemy4":
		enemyLoc4.get_child(0).died.connect(_on_enemy_death)
	elif name == "Enemy5":
		enemyLoc5.get_child(0).died.connect(_on_enemy_death)
	pass

func _on_enemy_death() -> void:
	var enemies = [
		{"name": "Enemy1", "loc": enemyLoc1},
		{"name": "Enemy2", "loc": enemyLoc2},
		{"name": "Enemy3", "loc": enemyLoc3},
		{"name": "Enemy4", "loc": enemyLoc4},
		{"name": "Enemy5", "loc": enemyLoc5}
	]
	
	var enemiesLeft = 0;
	for enemy in enemies:
		if enemy["loc"].get_child_count() != 0:
			enemiesLeft += 1
			
	if enemiesLeft == 0:
		turnsRunning = false
		battle_end.emit()
		return
	
	if turn_order.size() > 0:
		turn_order = []	
	calculate_turn_order()
	pass

func _input(event):
	if Input.is_action_just_pressed("mouse_capture"):
		turnsRunning = true