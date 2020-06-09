extends StateMachine


var linear_velocity: Vector3


func _physics_process(delta):
	get_parent().global_transform.origin += linear_velocity * delta
