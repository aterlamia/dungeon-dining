class_name Table

extends Node3D

@export var chair1: Marker3D
@export var chair2: Marker3D

var occupied = false

func setOccupied(value: bool) -> void:
	occupied = value
	
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
