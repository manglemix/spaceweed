extends BaseButton


export(String, FILE, "*.tscn") var scene_path: String


func _ready():
	connect("pressed", self, "start_game")


func start_game():
	get_tree().change_scene(scene_path)
