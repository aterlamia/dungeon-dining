extends CanvasLayer

@export var menu: CanvasLayer = null
@export var ingredients: CanvasLayer = null
@export var moneyLabel: Label = null
var but: TextureButton
func _ready() -> void:
	but = get_node("OpenDiner")
	but.disabled = true
	get_node("/root/Events").recipe_added.connect(_on_recipe_added)
	get_node("/root/Events").gold_changed.connect(_on_gold_changed)
	pass
	
func _on_menu_button_pressed() -> void:
	menu.visible = true
	get_node("/root/Events").on_in_menu(true)
	pass
	
func _on_gold_changed(currentAmount) -> void:
	moneyLabel.text = str(currentAmount)
	pass
	
func _on_recipe_added(recipe: String, amount:int) -> void:
	if get_node("/root/Global").chosen_dishes.size() > 0:
		but.disabled = false
	
func _on_open_diner_pressed() -> void:
	but.disabled = true
	get_node("/root/Global").part_state = "started"
	get_node("/root/Events").on_diner_opened(true)
	pass

func _on_ingredient_button_pressed() -> void:
	ingredients.visible = true
	get_node("/root/Events").on_in_menu(true)
	pass