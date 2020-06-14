extends MeshInstance


export var highlighted_surface := 0
export var highlight := false setget set_highlight

onready var default_thickness: float = get_surface_material(highlighted_surface).next_pass.params_grow


func set_highlight(value: bool):
	if value:
		get_surface_material(highlighted_surface).next_pass.params_grow = default_thickness
	
	else:
		get_surface_material(highlighted_surface).next_pass.params_grow = 0
	
	highlight = value


func _ready():
	set_highlight(highlight)
