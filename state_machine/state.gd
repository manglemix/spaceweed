class_name State
extends Node


var root: StateMachine


func _enter_tree():
	if get_parent() is StateMachine:
		root = get_parent()

	else:
		root = get_parent().root


func _ready():
	set_processing(false)


func _can_activate() -> int:
	return OK


func _activate() -> void:
	set_processing(true)


func _can_deactivate() -> int:
	return OK


func _deactivate() -> void:
	set_processing(false)


func set_processing(value: bool) -> void:
	set_process(value)
	set_physics_process(value)
	set_process_input(value)
	set_process_unhandled_input(value)


func get_sibling(name: String) -> Node:
	return get_parent().get_node(name)
