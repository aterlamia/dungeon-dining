@tool
class_name MenuItemGroup

extends BoxContainer

@export var group_name: String = "name":
	set(value):
		group_name = value
		setTitle()
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setTitle()
		
		
func setTitle() -> void:
	var title_label = get_node("MarginContainer/VBoxContainer/Title")
	title_label.text = "[center][b]" + group_name + "[/b][/center]"
	pass