extends State


export var acceleration: float
export var fast_speed: float
export var normal_speed: float
export var slow_speed: float


func _process(delta):
	var direction := Vector3(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_up") - Input.get_action_strength("move_down"),
			0
		)
	
	if not is_zero_approx(direction.length_squared()):
		direction = direction.normalized()
		
		if Input.is_action_pressed("move_fast"):
			direction *= fast_speed
		
		elif Input.is_action_pressed("move_slow"):
			direction *= slow_speed
		
		else:
			direction *= normal_speed
		
	root.linear_velocity = root.linear_velocity.linear_interpolate(direction, acceleration * delta)
