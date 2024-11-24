extends BaseNpcState

var eatTimer: Timer
func enter(previous_state_path: String, data := {}) -> void:
	npc._skin.position = Vector3(0.09, 0, 0)
	npc.velocity.x = 0.0
	npc.animation_player.play("SitIdle")
	var anim : Animation= npc.animation_player.get_animation("SitIdle")
	anim.loop_mode =(Animation.LOOP_LINEAR)
	if npc.want != "":
		return
	
	get_node("/root/Events").pauze.connect(_on_pauze)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var waitTime = rng.randf_range(2.0, 5.0)
	
	eatTimer = Timer.new()
	eatTimer.set_wait_time(waitTime)
	eatTimer.set_one_shot(true)
	eatTimer.connect("timeout", Callable(self, "_on_eatTimer_timeout"))
	add_child(eatTimer)
	eatTimer.start()
	
func _on_eatTimer_timeout() -> void:
	finished.emit(ORDERING)
	pass
	

func _on_pauze(pauzed:bool) -> void:
	eatTimer.paused = pauzed