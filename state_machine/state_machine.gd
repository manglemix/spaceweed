class_name StateMachine
extends Node


# the max number of nodepaths that can be in max_history
export var max_history := 3
# Easy way to add a few variables without extending the script
export var properties: Dictionary

# can't use State type hint, frequently causes cyclic dependency errors
var current: Node setget change
var history := []


func _ready():
	# Set the initial current to the first child node
	current = get_child(0)
	current.enter()


func change(state: Node, msg := {}, add_to_history := true):
	if add_to_history and max_history > 0:
		history.append(get_path_to(current))
		if history.size() > max_history:
			history.remove(0)
	
	current.exit()
	
	current = state
	current.enter(msg)


func change_to(path: NodePath, msg := {}, add_to_history := true):
	change(get_node(path), msg, add_to_history)


func revert_state(msg := {}):
	change_to(history.pop_back(), msg, false)
