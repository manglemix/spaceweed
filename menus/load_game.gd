extends BaseButton


export var save_name: String


func _ready():
	connect("pressed", self, "load_game")


func load_game():
	Saves.load_current_scene(save_name)
