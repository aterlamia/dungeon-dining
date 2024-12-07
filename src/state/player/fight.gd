# see a differnt solution ofr the camera / becauseof duplication this probbaly is not the best way
extends BasePlayerState
var _camera_input_direction := Vector2.ZERO
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
@export_group("Camera")
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 8.0

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0.0
	player.animation_player.play("Attack")
	await player.animation_player.animation_finished
	finished.emit(FIGHTINGIDLE)