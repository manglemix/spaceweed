class_name StateMachine
extends Node


signal transitioned

export var _initial_state: NodePath
export var max_last_states := 1

var current_state: Node
var last_states: Array


func _ready():
	transition_exact(_initial_state)


func transition(state: Node, log_last_state := true) -> int:
	var err: int = state._can_activate()
	if err != OK:
		return err
	
	err = state._can_deactivate()
	if err != OK:
		return err
	
	if is_instance_valid(current_state):
		current_state._deactivate()
		
		if log_last_state:
			last_states.append(current_state)
			if last_states.size() > max_last_states:
				last_states.erase(0)
	
	state._activate()
	current_state = state
	
	return OK


func transition_to(name: String, log_last_state := true) -> int:
	var state := find_node(name)
	if state == null:
		return ERR_DOES_NOT_EXIST
	
	return transition(state, log_last_state)


func transition_exact(path: NodePath, log_last_state := true) -> int:
	var state := get_node(path)
	if state == null:
		return ERR_DOES_NOT_EXIST
	
	return transition(state, log_last_state)


func revert_state() -> int:
	if not is_instance_valid(last_states.back()):
		return ERR_DOES_NOT_EXIST
	
	return transition(last_states.pop_back(), false)
