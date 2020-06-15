extends Camera


export var controller_path := NodePath("../CameraController")

var selected: Array
var selecting := false		# when monitoring on the Area turns off, it emits body_exited for all overlaping node, however we want to keep those nodes in the selected array
var map_plane := Plane(Vector3.BACK, 0)
var first_click: Vector3

var dont_save := ["controller", "map_plane", "selected", "first_click", "second_click"]

onready var controller: StateMachine = get_node(controller_path)


func _ready():
	$Selector.connect("body_entered", self, "add_selected")
	$Selector.connect("body_exited", self, "remove_selected")


func mouse_raycast() -> Dictionary:
	return get_world().direct_space_state.intersect_ray(global_transform.origin, project_ray_normal(get_viewport().get_mouse_position()) * far + global_transform.origin, [get_parent()])


func map_raycast() -> Vector3:
	return map_plane.intersects_ray(global_transform.origin, project_ray_normal(get_viewport().get_mouse_position()))


func move_to(target: Transform) -> void:
	controller.change_to("MoveTo", {"target": target})


func add_selected(body: Node) -> void:
	if selecting:
		selected.append(body)
		highlight_node(body, true)


func remove_selected(body: Node) -> void:
	# (REFER TO selecting COMMENT) so to prevent those nodes being removed, this node will not remove nodes after the selecting process is over
	if selecting:
		selected.erase(body)
		highlight_node(body, false)


func highlight_node(node: CollisionObject, value: bool) -> void:
	if node.has_node("Body"):
		var body = node.get_node("Body")
		
		if "highlight" in body:
			body.highlight = value


func highlight_all(value: bool) -> void:
	for node in selected:
		highlight_node(node, value)


func _input(event):
	if event.is_action_pressed("select"):
		highlight_all(false)
		selected.clear()
		first_click = map_raycast()
		selecting = true
		$DrawBox.active = true
		$Selector.active = true
	
	elif event.is_action_released("select"):
		selecting = false
		$DrawBox.active = false
		$Selector.active = false
