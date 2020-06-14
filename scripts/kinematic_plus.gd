class_name KinematicPlus
extends KinematicBody


var linear_velocity: Vector3


func _physics_process(delta):
	move_and_slide(linear_velocity, Vector3.BACK)
