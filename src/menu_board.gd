extends Node3D
var global: GlobalState = null
var menu_items:Array[Sprite3D] = []
func _ready() -> void:
	global = get_node("/root/Global")
	for child in get_children():
		if child.name.find("Menu") == 0:
			menu_items.append(child)
			child.visible = false
	get_node("/root/Events").recipe_added.connect(_on_recipe_added)
	get_node("/root/Events").availability_updated.connect(_on_availability_updated)
	add_recipe_to_board("coffee", 9999999999999, 0)
	pass

func _on_availability_updated() -> void:
	for item in menu_items:
		item.visible = false
	pass
		
	add_recipe_to_board("coffee", 9999999999999, 0)
	for i in range(global.chosen_dishes.size()):
			add_recipe_to_board(global.chosen_dishes[i]["dish"], global.chosen_dishes[i]["count"], i+1)
	pass

func add_recipe_to_board(recipe: String, amount:int, index: int) -> void:
	var recipe2 = global.availableRecipies[recipe]
	menu_items[index].visible = true
	var texture = load(recipe2["image"])
	menu_items[index].texture = texture
	if(amount == 9999999999999):
		menu_items[index].get_node("Label3D").text = "∞"
	else:
		menu_items[index].get_node("Label3D").text = str(amount)
	pass
	
func _on_recipe_added(recipe: String, amount:int) -> void:
	_on_availability_updated()
	pass
	
	
