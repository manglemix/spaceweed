extends Area


var active := false setget set_active


func set_active(value: bool):
	active = value
	monitoring = active
	set_physics_process(value)
	
	if not value:
		transform = Transform.IDENTITY


func _ready():
	# export vars will call setter before _ready
	# however, set_physics_process must be called during or after _ready
	# so we recall the setter here
	set_active(active)


func fit_between(first: Vector3, second: Vector3) -> void:
	# move Area to midpoint
	global_transform.origin = first.linear_interpolate(second, 0.5)
	
	# fit within the points
	# since the area is between the points, only one of the points needs to be used
	first = to_local(first)
	$CollisionShape.shape.extents.x = abs(first.x)
	$CollisionShape.shape.extents.y = abs(first.y)


func _physics_process(_delta):
	fit_between(get_parent().first_click, get_parent().map_raycast())
