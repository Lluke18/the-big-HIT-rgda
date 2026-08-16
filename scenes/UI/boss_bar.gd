extends SuspicionBar



func _process(delta: float) -> void:
	if !multiplayer.is_server():
		return
	
	if is_increasing:
		value += increase_rate 
		if value == max_value:
			print("DETECTED INTRUDER!")
			detected_player.emit()
			#await get_tree().create_timer(0.2).timeout
			#freeze or maybe delete the bar
			self.process_mode = Node.PROCESS_MODE_DISABLED
