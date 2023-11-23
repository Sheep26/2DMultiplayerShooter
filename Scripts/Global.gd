extends Node

var data
var playerName: String

func _loadSettings():
	var file = FileAccess.open("res://settings.json", FileAccess.READ_WRITE)
	data = JSON.parse_string(file.get_as_text())
	file.close()
	
func getData():
	return data
