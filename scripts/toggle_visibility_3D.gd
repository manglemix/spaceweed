class_name ToggleVisibility3D
extends VisibilityNotifier


func _ready():
	connect("screen_entered", get_parent(), "show")
	connect("screen_exited", get_parent(), "hide")
