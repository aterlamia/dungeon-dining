extends BaseNpcState
var eatTimer: Timer
func enter(previous_state_path: String, data := {}) -> void:
	npc._skin.position = Vector3(0.09, 0, 0)
	npc.notifications.visible = false
	get_node("/root/Events").pauze.connect(_on_pauze)
	npc.animation_player.play("Eat")
	var anim : Animation= npc.animation_player.get_animation("Eat")
	anim.loop_mode =(Animation.LOOP_LINEAR)
	npc.animation_player.speed_scale = 2
	eatTimer = Timer.new()
	eatTimer.set_wait_time(10.0) # Set the eating duration
	eatTimer.set_one_shot(true)
	eatTimer.connect("timeout", Callable(self, "_on_eatTimer_timeout"))
	add_child(eatTimer)
	eatTimer.start()
	
func _on_eatTimer_timeout() -> void:
	npc.finished = true
	npc.agent.set_target_position(npc.returnPosition)
	finished.emit(WALKING)
	
	global.money = global.money + npc.wantsManager.getWantData(npc.want).cost
	get_node("/root/Events").on_money_changed(global.money)
	pass


func _on_pauze(pauzed:bool) -> void:
	eatTimer.paused = pauzed
