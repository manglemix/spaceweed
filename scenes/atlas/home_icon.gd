extends MoveToIcon


func _input(event):
	if event.is_action_pressed("recentre"):
		move_to()
