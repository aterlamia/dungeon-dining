class_name LootTable
extends Node

var loot: Array[Loot] = []
func _ready() -> void:
	for loot_node: Loot in find_children("*", "Loot"):
		loot.append(loot_node)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getLoot() -> Dictionary:
	var lootDict = {
		"amount": 0,
		"type": ""
	}
	var minLoot = null
	var minchance = 2000
		
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rand = rng.randf()
	for loot_node: Loot in loot:
		print( str(loot_node.chance) + " - " + str(minchance) + " - " + str(rand))
		if  rand < loot_node.chance:
			if(loot_node.chance < minchance):
				print("found loot")
				minchance = loot_node.chance
				minLoot = loot_node
	if minLoot == null:
		print("no loot")
		return lootDict
		
	lootDict["amount"] = rng.randi_range(minLoot.minAmount, minLoot.maxAmount)
	lootDict["type"] = minLoot.lootName
	return lootDict
	
