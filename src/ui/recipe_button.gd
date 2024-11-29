class_name RecipeButton

extends TextureButton

var item: String = ""
func _ready() -> void:
	pass

func setTitle(title: String) -> void:
	var title_label = get_node("Title")
	title_label.text = title
	pass

func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	if get_node("/root/Global").inTutorial:
		if  get_node("/root/Global").game_state["tutorialStep"] == 4 && item == "burger":	
			get_node("/root/Events").on_tutorial_switch(5)
		elif item == "milkshake" and get_node("/root/Global").game_state["tutorialStep"] == 6:
			get_node("/root/Events").on_tutorial_switch(7)
		
	get_node("/root/Events").on_recipe_selected(item)
	pass
