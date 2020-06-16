extends State


export var max_speed := 50.0
export var acceleration := 25.0
export var turn_weight := 6.0
export var max_distance := 2.0

var dont_save := ["target_node"]
var speed: float
var target: Vector3
var target_node: Spatial

onready var drone: KinematicPlus = get_parent().get_parent()


func _ready():
	move_to_node(get_node("../../../Atlas"))


func move_to(position: Vector3) -> void:
	target = position
	target_node = null
	set_physics_process(true)


func move_to_node(node: Spatial) -> void:
	target_node = node
	set_physics_process(true)


func _physics_process(delta):
	if target_node != null:
		target = target_node.global_transform.origin
	
	var distance := drone.global_transform.origin.distance_to(target)
	var target_speed := clamp(sqrt(2 * acceleration * distance), 0, max_speed)
	
	if distance < max_distance:
		speed = 0
		set_physics_process(false)
		target_node = null
	
	else:
		if speed < target_speed:
			speed += acceleration * delta
		
		speed = clamp(speed, 0, target_speed)
	
	drone.global_transform = drone.global_transform.interpolate_with(drone.global_transform.looking_at(target, Vector3.BACK), turn_weight * delta)
	drone.linear_velocity = - speed * drone.global_transform.basis.z
