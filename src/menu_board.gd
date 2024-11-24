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
	pass


func _on_recipe_added(recipe: String, amount:int) -> void:
	print('added' + str(global.chosen_dishes))
	#hide all menu_items
	for item in menu_items:
		item.visible = false
		
	#loop ovcer global.save_state.chosenRecipies and update the sprite3d with the texture from the recipe
	for i in range(global.chosen_dishes.size()):
		var recipe2 = global.availableRecipies[global.chosen_dishes[i]["dish"]]
		menu_items[i].visible = true
		var texture = load(recipe2["image"])
		menu_items[i].texture = texture
		menu_items[i].get_node("Label3D").text = str(global.chosen_dishes[i]["count"])
	
	pass
	
	
