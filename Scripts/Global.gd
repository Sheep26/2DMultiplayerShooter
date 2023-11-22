extends Node

static var data
static var playerName: String
static var networkManager = load("res://Scripts/NetworkManager.gd")

func _ready():
	pass

func _process(_delta):
	pass

static func _loadSettings():
	var file = FileAccess.open("res://settings.json", FileAccess.READ_WRITE)
	data = JSON.parse_string(file.get_as_text())
	file.close()
	
static func getData():
	return data
