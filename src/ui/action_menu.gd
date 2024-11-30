extends CanvasLayer

@export var menu: CanvasLayer = null
@export var ingredients: CanvasLayer = null
@export var moneyLabel: Label = null
var but: TextureButton

var global: GlobalState = null
var events: EventManager = null
func _ready() -> void:
	but = get_node("OpenDiner")
	events = get_node("/root/Events")
	global = get_node("/root/Global")
	events.recipe_added.connect(_on_recipe_added)
	events.gold_changed.connect(_on_gold_changed)
	pass
	
func _on_menu_button_pressed() -> void:
	if(global.inTutorial && global.game_state["tutorialStep"] < 3):
		events.on_tutorial_switch(3)
	menu.visible = true
	events.on_in_menu(true)
	pass
	
func _on_gold_changed(currentAmount) -> void:
	moneyLabel.text = str(currentAmount)
	pass
	
func _on_recipe_added(recipe: String, amount:int) -> void:
	if global.chosen_dishes.size() > 0:
		but.disabled = false
	
func _on_open_diner_pressed() -> void:
	but.disabled = true
	global.part_state = "started"
	events.on_diner_opened(true)
	if get_node("/root/Global").inTutorial:
		get_node("/root/Events").on_tutorial_switch(14)
	pass

func _on_ingredient_button_pressed() -> void:
	if(global.inTutorial && global.game_state["tutorialStep"] < 9):
		events.on_tutorial_switch(9)
	ingredients.visible = true
	events.on_in_menu(true)
	pass