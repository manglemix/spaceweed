# Provides an easy way to manage save and load save files
extends Node


# An array of names of files that have the same suffix as save_suffix
var saves_paths: PoolStringArray
# An internally managed File containing useful inter-save data
var game_config := ConfigFile.new()
# The directory where extra files are written (eg. saves)
var data_directory := Directory.new()

# the suffix of save files
var save_suffix := ".save"


func _ready():
	var err := data_directory.open("res://")
	if err != OK:
		printerr("Error opening data_directory: ", err)
		return
	
	if data_directory.file_exists("game_config.ini"):
		var err2 := game_config.load("game_config.ini")
		if err2 != OK:
			printerr("Error loading game_config.ini: ", err2)
			return
	
	update_saves_paths()


func _exit_tree():
	game_config.save("game_config.ini")


func update_saves_paths() -> void:
	# Iterates through the data_directory, looking for files that end with the save_suffix
	# nodes towards the end of the list are deeper in the hierarchy
	var err := data_directory.list_dir_begin(true, true)
	if err != OK:
		printerr("Error while updating save paths: ", err)
		return
	
	while true:
		var filename = data_directory.get_next()
		if filename.empty():
			break
		
		if filename.ends_with(save_suffix):
			saves_paths.append(filename.trim_suffix(save_suffix))
		
	data_directory.list_dir_end()


func read_save(save_name: String) -> SerialTree:
	# Reads a save file and returns the SerialTree stored
	var file := File.new()
	var err := file.open(save_name + save_suffix, File.READ)
	if err != OK:
		printerr("Error while opening save: ", save_name + save_suffix, ", Error Code: ", err)
		return null
	var serial_data: Array = file.get_var()
	file.close()
	var serial_tree := SerialTree.new()
	serial_tree.deserialize_self(serial_data)
	
	return serial_tree


func load_current_scene(save_name: String, loading_screen := "res://menus/loading_screen.tscn") -> void:
	# Changes the current scene to the scene stored in the save file
	# If a loading screen path is given, the loading progress will be shown through that scene
	var serial_tree: SerialTree = read_save(save_name)
	serial_tree.begin_deserial()
	
	if loading_screen.empty():
		var err := serial_tree.wait_deserial()
		if err != OK:
			printerr("Error while deserializing current scene: ", err)
		
	else:
		get_tree().change_scene(loading_screen)
		yield(get_tree(), "node_added")
		var poller: Poller = get_tree().current_scene.find_node("Poller")
		poller.begin_polling(serial_tree, "poll_deserial")
		yield(poller, "done")
	
	get_tree().root.add_child(serial_tree.root_node)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = serial_tree.root_node


func write_save(save_name: String, serial_tree: SerialTree) -> void:
	# Saves the SerialTree given to the save name given
	var file := File.new()
	var err := file.open(save_name + save_suffix, File.WRITE)
	if err != OK:
		printerr("Error writing a save file: ", err)
		return
		
	file.store_var(serial_tree.serialize_self())
	file.close()


func write_current_scene(save_name: String, loading_screen := "res://menus/loading_screen.tscn") -> void:
	# Saves the current scene to the save name given
	# If a loading screen path is given, the saving progress will be shown through that scene
	# Keep in mind if a loading screen is given, it will just be added next to the current scene
	# The SceneTree will also be paused until the poller is done
	var serial_tree := SerialTree.new()
	serial_tree.begin_serial(get_tree().current_scene)
	
	if loading_screen.empty():
		var err := serial_tree.wait_serial()
		if err != OK:
			printerr("Error while serializing current scene: ", err)
		
	else:
		get_tree().paused = true
		var loading_scene: Node = load(loading_screen).instance()
		get_tree().root.add_child(loading_scene)
		var poller: Poller = loading_scene.find_node("Poller")
		poller.begin_polling(serial_tree, "poll_serial")
		yield(poller, "done")
		get_tree().paused = false
	
	write_save(save_name, serial_tree)
