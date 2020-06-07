# An easy way to show the progress of any object which can be polled
# the polled object must also have get_stage() and get_stage_count() to be able to get the progress
# connect the progressed signal to the desired method
# eg. to make a progress bar, connect the progressed signal to the set_value method of ProgressBar
# FYI, the progress value is a float between 0 and 1, so ProgressBar max_value has to be 1
class_name Poller
extends Node


signal done
signal progressed(progress)

# The name of the method to be called when polling
var method_name: String
# The object which has the above method
var polled_object
# The error code from the last poll call
var last_error := OK

var _thread := Thread.new()


func begin_polling(object, poll_method := "poll") -> void:
	# Prepare this node to poll the object given
	# The poll_method is the name of the method to be called repeatedly in object
	method_name = poll_method
	polled_object = object
	_thread.start(self, "poll_object")


func poll_object(_u) -> void:
	while last_error == OK:
		last_error = polled_object.call(method_name)
	emit_signal("done")


func _exit_tree():
	_thread.wait_to_finish()


func _process(_delta):
	emit_signal("progressed", polled_object.get_stage() as float / polled_object.get_stage_count())
