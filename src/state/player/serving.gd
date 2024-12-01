extends BasePlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.animation_player.play("Serve")
	var anim : Animation= player.animation_player.get_animation("Serve")
	anim.loop_mode =(Animation.LOOP_LINEAR)
	player.animation_player.speed_scale = 1.5
	
func update(_delta: float) -> void:
	if(player.velocity.length() <= 0.1):
		if(player.carringOrder):
			finished.emit(IDLEHOLD)
		else:
			finished.emit(IDLE)
	pass
