class_name Notification
extends Node2D

var progressBar: TextureProgressBar

var spawnTimer: Timer
var logger
signal wait_expired
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progressBar = get_node("HungerTimerProgress")
	spawnTimer = Timer.new()
	spawnTimer.set_wait_time(0.2)
	spawnTimer.set_one_shot(false)
	spawnTimer.connect("timeout", Callable(self, "_on_spawnTimer_timeout"))
	add_child(spawnTimer)
	logger = get_node("/root/Log")
	pass

func setAction(action: String) -> void:
	var holder: Sprite2D = get_node("Sprite2D/fooditem")
	
	if(action == "pickup"):
		var texture = load("res://assets/images/food/pickuplate.png")
		holder.texture = texture
	if(action == "deliver"):
		var texture = load("res://assets/images/food/deliverplate.png")
		holder.texture = texture
	if(action == "down"):
		var texture = load("res://assets/images/food/downstairs.png")
		holder.texture = texture
	if(action == "up"):
		var texture = load("res://assets/images/food/upstairs.png")
		holder.texture = texture
	if(action == "search"):
		var texture = load("res://assets/images/food/search.png")
		holder.texture = texture
	pass
	
	
func setWant(want: String) -> void:
	var holder: Sprite2D = get_node("Sprite2D/fooditem")
	
	if want == "":
		set_customer_angry()
		return
		
	var man: WantsManager = get_node("/root/Wants")
	var data = man.getWantData(want)
	
	
	# set the texture of the sprite based on the filename (a png) in the data["image"]
	var texture = load(data["image"])
	holder.texture = texture
	pass
	
func startTimer() -> void:
	spawnTimer.start()
	pass
	
func stopTimer() -> void:
	spawnTimer.stop()
	pass
	
	
func set_customer_angry() -> void:
	var holder: Sprite2D = get_node("Sprite2D/fooditem")
	var texture = load("res://assets/ui/angry.png")
	holder.texture = texture
	pass

func _on_spawnTimer_timeout() -> void:
	if progressBar.value < 100:
		progressBar.value += 0.3
		var progress_ratio = (progressBar.value - 50) / 50.0 if progressBar.value >= 50 else 0
		progressBar.tint_progress = Color(1 * progress_ratio, 1 * (1 - progress_ratio), 0)
	else:
		set_customer_angry()
		wait_expired.emit()
		spawnTimer.stop()
		
	pass
