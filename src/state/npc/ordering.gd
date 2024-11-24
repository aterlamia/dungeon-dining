extends BaseNpcState

func enter(previous_state_path: String, data := {}) -> void:
	npc._skin.position = Vector3(0.09, 0, 0)
	npc.animation_player.play("Order")
	npc.want = npc.wantsManager.getRandomWant()
	npc.notifications.setWant(npc.want)
	npc.notifications.visible = true
	npc.notifications.startTimer()
	events.on_customer_seated(npc)
	# Wait for the animation to finish
	await npc.animation_player.animation_finished
	finished.emit(IDLE)
	pass
