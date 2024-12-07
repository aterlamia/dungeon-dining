extends Node3D

@export var hitpoints: float = 5
@export var battleSpeed: float = 5 # Speed of the enemy in seconds for a turn
@export var attacks: Dictionary[String,float]
@export var enemyName: String = "Enemy"
@export var battleName: String = "Enemy"
@export var maxHitpoints : float= 5.0
var loot: LootTable = null

signal died
func _ready() -> void:
	loot = get_node("LootTable")
	pass
	
	
func doDamage(damage: float) -> void:
	hitpoints -= damage
	
	if hitpoints <= 0:
		var lt = loot.getLoot()
		get_node("/root/Events").on_loot_generated(lt.type, lt.amount)
		died.emit()
		get_parent().remove_child(self)
		self.queue_free()
	pass
	
	
func attack() -> void:
	#get random attack
		
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var attack = attacks.keys()[rng.randi() % attacks.size()]
	
	get_node("/root/Events").on_damage_player(attacks[attack])
	pass
