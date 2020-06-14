extends State


export var max_speed := 50.0
export var acceleration := 25.0
export var turn_weight := 6.0
export var max_distance := 2.0

var speed: float
var target: Vector3

onready var drone: KinematicPlus = get_parent().get_parent()


func _ready():
	move_to(Vector3(100, 100, 0))


func move_to(position: Vector3) -> void:
	target = position
	set_physics_process(true)


func _physics_process(delta):
	var distance := drone.global_transform.origin.distance_to(target)
	var target_speed := clamp(sqrt(2 * acceleration * distance), 0, max_speed)
	
	if distance < max_distance:
		speed = 0
		set_physics_process(false)
	
	else:
		if speed < target_speed:
			speed += acceleration * delta
		
		speed = clamp(speed, 0, target_speed)
	
	drone.global_transform = drone.global_transform.interpolate_with(drone.global_transform.looking_at(target, Vector3.BACK), turn_weight * delta)
	drone.linear_velocity = - speed * drone.global_transform.basis.z
	

