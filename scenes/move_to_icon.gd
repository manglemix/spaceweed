class_name MoveToIcon
extends Rect2Button


export var target_path: NodePath

var dont_save := ["target"]

onready var target: Spatial = get_node(target_path)
onready var camera := get_viewport().get_camera()


func _ready():
	connect("clicked", self, "move_to")


func move_to() -> void:
	var tmp_transform := target.global_transform
	tmp_transform.origin.z = camera.get_parent().global_transform.origin.z
	camera.move_to(tmp_transform)
