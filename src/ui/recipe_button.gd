class_name RecipeButton

extends TextureButton

var item: String = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setTitle(title: String) -> void:
	var title_label = get_node("Title")
	title_label.text = title
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	get_node("/root/Events").on_recipe_selected(item)
	pass