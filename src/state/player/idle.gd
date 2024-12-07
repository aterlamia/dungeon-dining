extends BasePlayerState

var dispencer: Dispencer 
var bone_attachment_dish
var skeleton: Skeleton3D

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0.0
	player.animation_player.play("Idle")
	var anim : Animation= player.animation_player.get_animation("Idle")
	anim.loop_mode =(Animation.LOOP_LINEAR)
	dispencer = player.get_node("%Dispencer")
	skeleton = player._skin.get_node("Armature/Skeleton3D")
	
## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	if(player.inAttackForm):
		finished.emit(FIGHTINGIDLE)
		return
	if(player.velocity.length() > 0.1):
		if(player.in3thPerson):
			print("Walking")
			finished.emit(WALKING3TH)
		else:
			print("Walking2")
			finished.emit(WALKING)
		return
	if(player.in3thPerson):
		print("Walking")
		finished.emit(WALKING3TH)
	elif(player.carringOrder):
		print("Serving")
		finished.emit(IDLEHOLD)
		return
	pass

	if player.gettingFood && Input.is_action_just_pressed("action") && player.carringOrder == null: 
		var boneName = "Bone.003"
		var meal = dispencer.pickup()
		if meal == null:
			return
		player.carringOrder = meal 
		var order_scene = load(player.carringOrder['model'])
		var dish: Node3D = order_scene.instantiate()
		var boneId = skeleton.find_bone(boneName)
		bone_attachment_dish = BoneAttachment3D.new()
		skeleton.add_child(bone_attachment_dish)
		bone_attachment_dish.bone_name = boneName
		bone_attachment_dish.add_child(dish)
		var rotation_offset := Vector3(-6, 97.3, -91)
		var position_offset := Vector3(0, 0.15, 0) 
		dish.rotation_degrees = rotation_offset
		dish.position = position_offset 
			   
		player._skin.get_node("Armature/Skeleton3D/ServePlate").visible = true
		finished.emit(IDLEHOLD)
		return
	if(bone_attachment_dish):
		skeleton.remove_child(bone_attachment_dish)
		bone_attachment_dish.queue_free()
		bone_attachment_dish = null
		player._skin.get_node("Armature/Skeleton3D/ServePlate").visible = false