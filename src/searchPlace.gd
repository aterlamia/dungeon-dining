extends Area3D


var hasBeenSearched: bool = false
@export var dialog: CanvasLayer = null

var inSearchArea: bool = false
var player = null
func _on_area_entered(body:Area3D):
	inSearchArea = true
	if body.name == "ColDetectorPlayer" and !hasBeenSearched:
		player = body.get_parent()
	
		if (player != null):
			player.nots.setAction("search")
			player.bubble.visible = true
	pass
	

func _on_area_exited(body:Area3D):
	inSearchArea = false
	if body.name == "ColDetectorPlayer" and !hasBeenSearched:
		if (player != null):
			player.bubble.visible = false
			player = null
	
	pass	
	
func _input(event: InputEvent) -> void:	
	if (player == null):
		return
	if !inSearchArea:
		return
	if event.is_action_pressed("action"):
		if(name != "BoxesWall"):
			hasBeenSearched = true
			dialog.visible = true
			dialog.switch(1)
			player.bubble.visible = false
			player = null
		else:
			hasBeenSearched = true
			dialog.visible = true
			dialog.switch(2)
			player.bubble.visible = false
			player = null
			
	pass
	
