extends CanvasLayer

@export var createButton: TextureButton = null
@export var buyIngredientsButton: TextureButton = null
@export var openButton: TextureButton = null

func _ready() -> void:
	get_node("/root/Events").tutorial_switch.connect(_on_tutorial_switch)
	
func _on_tutorial_switch(nr: int) -> void:
	## hide all children
	for child in get_children():
		child.visible = false
		
	match nr:
		1:
			$Intro.visible = true
			return
		2:
			$Recipies.visible = true
			return		
		3:
			$Menu.visible = true
			return
		4:
			$Burger.visible = true
			return
		5:
			$Ingredients.visible = true
			return
		6:
			$Added.visible = true
			return
		7:
			$MilkshakeOpen.visible = true
			return
		8:
			$Ingre.visible = true
			return
		9:
			$MilkshakeIng.visible = true
			return
		10:
			$MilkshakeIngOpen.visible = true
			return
		11: 
			$MilkshakeBought.visible = true
			return
		12: 
			$AddMore.visible = true
			return
		13:
			$Finish.visible = true
			return
		14:
			return
		15:
			$Customer.visible = true
			return
		16:
			$Customer2.visible = true
			return
		17:
			$Customer3.visible = true
			return
		18:
			return
	pass

func _on_texture_button_pressed() -> void:
	get_node("/root/Events").on_tutorial_switch(2)
	pass # Replace with function body.

func _on_menu_button_pressed() -> void:
	get_node("/root/Events").on_tutorial_switch(4)
	pass # Replace with function body.

func _on_finish_button_pressed() -> void:
	get_node("/root/Events").on_tutorial_switch(18)
	pass # Replace with function body.

func _on_skip_pressed() -> void:
	get_node("/root/Events").on_tutorial_switch(18)
	pass # Replace with function body.
