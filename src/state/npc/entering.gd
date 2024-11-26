extends BaseNpcState

func enter(previous_state_path: String, data := {}) -> void:
	npc._skin.position = Vector3(0, 0, 0)
	npc.velocity.x = 0.0
	npc.animation_player.play("Idle")
	npc.notifications.visible = false
	finished.emit(WALKING)
	pass
