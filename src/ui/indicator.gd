extends TextureRect

func _process(delta: float) -> void:
	#boucnce the indicator
	var pos = get_position()
	pos.y = 10 + sin(Time.get_ticks_msec() / 100) * 2
	set_position(pos)
	
	pass