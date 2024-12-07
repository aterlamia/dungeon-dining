extends Node3D

var lootName: String = "test"
var amount: int = 0 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("/root/Events").loot_generated.connect(_loot_generated)
	get_node("PlayerLoc/Player").attackStance()
	pass # Replace with function body.

func _loot_generated(type: String, amount: int) -> void:
	lootName = type
	amount = amount
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_turns_battle_end():
	get_node("Result").visible = true
	pass
	
func _on_button_pressed() -> void:
	get_node("/root/Events").on_end_battle()
	pass # Replace with function body.


func _input(event):
	if Input.is_action_just_pressed("mouse_capture"):
		$BattlessCamera.make_current()