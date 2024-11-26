extends BaseNpcState

func enter(previous_state_path: String, data := {}) -> void:
	npc._skin.position = Vector3(0.09, 0, 0)
	npc.animation_player.play("Order")
	npc.want = npc.wantsManager.getRandomWant()
	npc.notifications.setWant(npc.want)
	npc.notifications.visible = true
	# make own state for this
	if npc.want == "":
		npc.finished = true
		npc.agent.set_target_position(npc.returnPosition)
		finished.emit(WALKING)
		return
	npc.notifications.startTimer()
	events.on_customer_seated(npc)
	# Wait for the animation to finish
	await npc.animation_player.animation_finished
	finished.emit(IDLE)
	pass
