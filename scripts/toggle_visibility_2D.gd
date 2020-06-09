class_name toggle_visibility_2D
extends VisibilityNotifier2D


func _ready():
	connect("screen_entered", get_parent(), "show")
	connect("screen_exited", get_parent(), "hide")
