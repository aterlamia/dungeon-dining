extends BasePlayerState

func enter(previous_state_path: String, data := {}) -> void:
	print("Prev" + previous_state_path)
	player.animation_player.play("Walk")
	var anim : Animation= player.animation_player.get_animation("Walk")
	anim.loop_mode =(Animation.LOOP_LINEAR)
	player.animation_player.speed_scale = 1.5
	
func update(_delta: float) -> void:
	if(player.velocity.length() <= 0.1):
		if(player.carringOrder):
			finished.emit(IDLEHOLD)
		else:
			finished.emit(IDLE)
		return
	else:
		if(player.carringOrder):
			finished.emit(SERVING)
		return
	pass
