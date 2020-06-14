class_name State
extends Node


var root: StateMachine


func _enter_tree():
	if get_parent() is StateMachine:
		root = get_parent()
	
	elif "root" in get_parent():
		root = get_parent().root


func _ready():
	set_processing(false)


func enter(msg := {}) -> void:
	return


func exit(msg := {}) -> void:
	return


func set_processing(value: bool) -> void:
	set_process(value)
	set_process_input(value)
	set_physics_process(value)
