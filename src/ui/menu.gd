extends Panel

@export var baseMenuGroup: PackedScene = null
@export var baseMenuItem: PackedScene = null
@export var menuSlots: Dictionary[String, MenuItemGroup]
var activeGroups : Dictionary = {}
func _ready() -> void:
	get_node("/root/Events").recipe_added.connect(_on_selected)
	pass # Replace with function body.
	
	

func _on_selected(recipe: String, amount: int) -> void:
	var group: MenuItemGroup = null 
	var rec: Recipe = get_node("/root/Global").availableRecipies[recipe]
	if(activeGroups.has(rec.group)):
		group = activeGroups[rec.group]
	else:
		group = baseMenuGroup.instantiate()
		activeGroups[rec.group] = group
		%MenuRows.add_child(group)	
	
	var item = baseMenuItem.instantiate()
	group.group_name = recipe
	group.get_node("MarginContainer/VBoxContainer/Items").add_child(item)
	pass
	
func _process(delta: float) -> void:
	pass
