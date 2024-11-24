extends BaseNpcState

func enter(previous_state_path: String, data := {}) -> void:
	npc._skin.position = Vector3(0, 0, 0)
	npc.velocity.x = 0.0
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if rng.randf() > 0.5:
		npc.position = npc.targetTable.chair1.global_transform.origin
		var look_dir = (npc.targetTable.global_transform.origin - npc.position).normalized()
		npc.look_at(npc.position + look_dir)
	else:
		npc.position = npc.targetTable.chair2.global_transform.origin
		var look_dir = (npc.targetTable.global_transform.origin - npc.position).normalized()
		npc.look_at(npc.position + look_dir)
		
	npc.animation_player.play("Sit")
	await npc.animation_player.animation_finished
	finished.emit(IDLE)
	pass

	