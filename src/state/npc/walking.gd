extends BaseNpcState

@export var SPEED = 4.0
var is_stuck = false
var stuck_time_threshold: float = 1.0 
var stuck_timer: float = 0.0
var original_collision_mask: int
var original_collision_layer: int
func enter(previous_state_path: String, data := {}) -> void:
	npc._skin.position = Vector3(0, 0, 0)
	npc.velocity.x = 0.0
	npc.animation_player.play("Walk")
	var anim : Animation= npc.animation_player.get_animation("Walk")
	anim.loop_mode =(Animation.LOOP_LINEAR)
	npc.animation_player.speed_scale = 1.3
	pass

func physics_update(_delta: float) -> void:
	if npc.position.distance_to(npc.agent.target_position) <= 1:
		if npc.finished:
			npc.deleting = true
			npc.get_parent().remove_child(npc)
			npc.queue_free()
			return
		finished.emit(SEATING)
		return

		
	var curLoc = npc.global_transform.origin
	var nexLoc = npc.agent.get_next_path_position()
	var newVel = (nexLoc - curLoc).normalized() * SPEED
	npc.velocity = newVel
	
	var ground_speed := npc.velocity.length()
	if ground_speed > 0.0:
		npc._last_movement_direction = npc.velocity.normalized()
			
	npc.move_and_slide()
	
	var look_target = npc.global_transform.origin + npc.velocity.normalized()
	look_target.y = npc.global_transform.origin.y

	if not npc.global_transform.origin.is_equal_approx(look_target):
		npc.look_at(look_target)
	else:
		print('stuck')
		#npc is stuck, turn off collision for a bit
		npc.collision_layer = 0
		
	#sometimes a npc is stuck print a warning
	if npc.velocity.length() < 0.1:
		stuck_timer += _delta
		if stuck_timer >= stuck_time_threshold:
			handle_stuck()
	else:
		# Reset stuck timer if we're moving
		stuck_timer = 0
		if is_stuck:
			# If we were stuck but now moving, restore collisions
			restore_collisions()
			is_stuck = false
	pass

func handle_stuck():
	if !is_stuck:
		print("NPC is stuck! Temporarily disabling collisions...")
		is_stuck = true
		disable_collisions()
		# Optional: Start a timer to re-enable collisions
		get_tree().create_timer(5.0).timeout.connect(restore_collisions)
	pass
		
func disable_collisions():
	original_collision_mask = npc.collision_mask
	original_collision_layer = npc.collision_layer
	
	npc.collision_mask = 0  # Disable all collisions
	npc.collision_layer = 0
	pass

func restore_collisions():
	if is_stuck:
		print("Restoring collisions...")
		npc.collision_mask = original_collision_mask
		is_stuck = false
		stuck_timer = 0
	pass
