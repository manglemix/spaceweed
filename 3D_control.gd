extends Control


func _ready():
	assert(get_parent() is Spatial)


func _process(delta):
	var cam := get_viewport().get_camera()
	
	if cam.is_position_behind(get_parent().global_transform.origin):
		hide()
	
	else:
		show()
