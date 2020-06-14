extends Control


export var max_screen_fraction: float


func _ready():
	assert(get_parent() is Spatial)


func _process(delta):
	var cam := get_viewport().get_camera()
	var screen_centre := get_viewport().size / 2
	
	if cam.is_position_behind(get_parent().global_transform.origin) or get_parent().visible:
		hide()
	
	else:
		show()
		if is_zero_approx(max_screen_fraction):
			rect_global_position = cam.unproject_position(get_parent().global_transform.origin)
		
		else:
			var global_pos := cam.unproject_position(get_parent().global_transform.origin)
			var offset := global_pos - screen_centre
			
			var max_length: float
			if screen_centre.x < screen_centre.y:
				max_length = screen_centre.x * max_screen_fraction
			else:
				max_length = screen_centre.y * max_screen_fraction
			
			if offset.length() > max_length:
				rect_global_position = offset.clamped(max_length) + screen_centre
			
			else:
				rect_global_position = global_pos
