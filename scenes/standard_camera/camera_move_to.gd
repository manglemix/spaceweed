extends State


export var move_weight := 6.0
export var min_distance := 5.0

var target_transform: Transform
var last_transform: Transform
var dont_save := ["player"]

onready var player: KinematicPlus = get_parent().get_parent()


func enter(msg := {}) -> void:
	target_transform = msg["target"]
	last_transform = player.global_transform


func revert():
	target_transform = last_transform


func _input(event):
	if event.is_action_pressed("move_down") or event.is_action_pressed("move_left") \
	or event.is_action_pressed("move_right") or event.is_action_pressed("move_up") \
	or event.is_action_pressed("zoom_in") or event.is_action_pressed("zoom_out"):
		root.change_to("Move")


func _physics_process(delta):
	# this will only interpolate rotation
	var tmp_origin := player.global_transform.origin
	var target_vector := target_transform.origin - tmp_origin
	
	if target_vector.length() < min_distance:
		root.change_to("Move")
	
	player.global_transform = player.global_transform.interpolate_with(target_transform, move_weight * delta)
	player.global_transform.origin = tmp_origin
	
	player.linear_velocity = target_vector * move_weight
