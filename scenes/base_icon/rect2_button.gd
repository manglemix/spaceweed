class_name Rect2Button
extends Node2D


signal clicked

export var rect: Rect2


func _input(event):
	if event.is_action_pressed("select") and rect.has_point(to_local(get_global_mouse_position())):
		emit_signal("clicked")
