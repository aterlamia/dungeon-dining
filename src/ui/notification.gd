class_name Notification
extends Node2D

var progressBar: TextureProgressBar

var spawnTimer: Timer
var logger
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

func setWant(want: String) -> void:
	var man: WantsManager = get_node("/root/Wants")
	var data = man.getWantData(want)
	
	var holder: Polygon2D = get_node("Sprite2D/placeholder")
	holder.color = data.color
	pass
	
func startTimer() -> void:
	spawnTimer.start()
	pass
	
func stopTimer() -> void:
	spawnTimer.stop()
	pass
	
func _on_spawnTimer_timeout() -> void:
	if progressBar.value < 100:
		progressBar.value += 0.3
		var progress_ratio = (progressBar.value - 50) / 50.0 if progressBar.value >= 50 else 0
		progressBar.tint_progress = Color(1 * progress_ratio, 1 * (1 - progress_ratio), 0)
	else:
		spawnTimer.stop()
		
	pass
