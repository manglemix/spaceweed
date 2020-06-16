extends State


export var fast_speed := 300.0
export var normal_speed := 150.0
export var slow_speed := 75.0
export var move_weight := 6.0

export var min_z := 20.0
export var max_z := 300.0
export var zoom_step := 20.0

export var drag_sensitivity := 0.5

var target_z: float
var dont_save := ["player", "dragging"]
var last_mouse_position: Vector2

onready var player: KinematicPlus = get_parent().get_parent()


func enter(msg := {}) -> void:
	set_processing(true)
	target_z = player.global_transform.origin.z


func exit(msg := {}) -> void:
	set_processing(false)


func _process(delta):
	if Input.is_action_pressed("drag_camera"):
		var tmp: Vector2 = get_viewport().get_mouse_position()
		var tmp_velocity: Vector2 = (last_mouse_position - tmp) / delta * drag_sensitivity
		player.linear_velocity.x = tmp_velocity.x
		player.linear_velocity.y = - tmp_velocity.y
		last_mouse_position = tmp
	
	else:
		var direction := Vector3(
				Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
				Input.get_action_strength("move_up") - Input.get_action_strength("move_down"),
				0
			)
		
		if Input.is_action_pressed("move_fast"):
			direction *= fast_speed
		
		elif Input.is_action_pressed("move_slow"):
			direction *= slow_speed
		
		else:
			direction *= normal_speed
			
		player.linear_velocity = player.linear_velocity.linear_interpolate(direction, move_weight * delta)
	
	player.global_transform.origin.z = lerp(player.global_transform.origin.z, target_z, move_weight * delta)


func _input(event):
	if event.is_action_pressed("zoom_in"):
		target_z -= zoom_step
		
		if target_z < min_z:
			target_z = min_z
	
	elif event.is_action_pressed("zoom_out"):
		target_z += zoom_step
		
		if target_z > max_z:
			target_z = max_z
	
	elif event.is_action_pressed("drag_camera"):
		last_mouse_position = get_viewport().get_mouse_position()
