class_name TableManager
extends Node

@export var templates: Array[Table] = []

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func getRandomFreeTable() -> Table:
	var rng = RandomNumberGenerator.new()
	var freeTables = []
	for template in templates:
		if template.occupied == false:
			freeTables.append(template)
	if freeTables.size() > 0:
		return freeTables[rng.randi() % freeTables.size()]
	return null

func getTable(nr: int) -> Table:
	return templates[nr]
