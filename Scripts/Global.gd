extends Node

var data
var playerName: String
var gameServer: GameServer

func _loadSettings():
	var file = FileAccess.open("res://settings.json", FileAccess.READ_WRITE)
	data = JSON.parse_string(file.get_as_text())
	file.close()
	playerName = getConfigData()["settings"]["name"]
	
func getConfigData():
	return data
