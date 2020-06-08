extends State


export var acceleration: float
export var fast_speed: float
export var normal_speed: float
export var slow_speed: float


func _process(delta):
	var direction: Vector3
	
	if Input.is_action_pressed("move_up"):
		direction.y += 1
	
	if Input.is_action_pressed("move_down"):
		direction.y -= 1
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	
	if not is_zero_approx(direction.length_squared()):
		direction = direction.normalized()
		
		if Input.is_action_pressed("move_fast"):
			direction *= fast_speed
		
		elif Input.is_action_pressed("move_slow"):
			direction *= slow_speed
		
		else:
			direction *= normal_speed
		
	root.linear_velocity = root.linear_velocity.linear_interpolate(direction, acceleration * delta)
