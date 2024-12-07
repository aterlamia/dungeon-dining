extends BasePlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0.0
	player.animation_player.play("IdleServing")
	var anim : Animation= player.animation_player.get_animation("IdleServing")
	anim.loop_mode =(Animation.LOOP_LINEAR)
	
func update(_delta: float) -> void:
	if(player.velocity.length() > 0.1):
		if player.carringOrder:
			finished.emit(SERVING)
		else:
			print("Walking255")
			finished.emit(WALKING)
	else:
		if !player.carringOrder:
			finished.emit(IDLE)
	pass
	if Input.is_action_just_pressed("action"):
		print("Serving")
		get_node("/root/Events").on_deliver_attempt(player.carringOrder)
		finished.emit(IDLE)
