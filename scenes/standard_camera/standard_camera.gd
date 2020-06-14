extends Camera


export var controller_path := NodePath("../CameraController")

var selected: CollisionObject
var map_plane := Plane(Vector3.BACK, 0)
var dont_save := ["controller"]

onready var controller: StateMachine = get_node(controller_path)


func mouse_raycast() -> Dictionary:
	return get_world().direct_space_state.intersect_ray(global_transform.origin, project_ray_normal(get_viewport().get_mouse_position()) * far + global_transform.origin, [get_parent()])


func map_raycast() -> Vector3:
	return map_plane.intersects_ray(global_transform.origin, project_ray_normal(get_viewport().get_mouse_position()))


func move_to(target: Transform) -> void:
	controller.change_to("MoveTo", {"target": target})


func highlight_selected(value: bool) -> void:
	if selected != null and selected.has_node("Body"):
		var body = selected.get_node("Body")
		
		if "highlight" in body:
			body.highlight = value


func _input(event):
	if event.is_action_pressed("select"):
		highlight_selected(false)
		
		var result := mouse_raycast()
		
		if result.empty():
			selected = null
		
		else:
			selected = result["collider"]
			highlight_selected(true)
