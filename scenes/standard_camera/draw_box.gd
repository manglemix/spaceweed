extends Control


var active := false setget set_active


func set_active(value: bool):
	active = value
	set_process(value)
	
	if value:
		show()
	else:
		hide()


func _ready():
	# export vars will call setter before _ready
	# however, set_physics_process must be called during or after _ready
	# so we recall the setter here
	set_active(active)


func _process(_delta):
	update()


func _draw():
	var position: Vector2 = get_parent().unproject_position(get_parent().first_click)
	
	draw_rect(Rect2(position, get_global_mouse_position() - position), Color.white, false)
