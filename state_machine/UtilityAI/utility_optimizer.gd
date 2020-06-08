class_name UtilityOptimizer
extends UtilityState


var _max_node: UtilityState


func _ready():
	root.connect("transitioned", self, "_null_max_node")
	set_processing(false)


func _get_score() -> float:
	var max_score := 0.0
	
	for child in get_children():
		if child is UtilityState:
			var score: float = child._get_score()
			
			if score > max_score:
				max_score = score
				_max_node = child
			
			if is_inf(score):
				break
	
	return max_score


func _activate() -> void:
	if _max_node == null:
		_get_score()
	
	root.transition(_max_node)


func _null_max_node() -> void:
	_max_node = null
