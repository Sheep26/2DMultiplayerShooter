extends Node

var data
var playerName: String
var isMultiplayer: bool = false

func _loadSettings():
	var file = FileAccess.open("res://settings.json", FileAccess.READ_WRITE)
	data = JSON.parse_string(file.get_as_text())
	file.close()
	playerName = getConfigData()["settings"]["name"]
	
func getConfigData():
	return data

func _getIsMultiplayer() -> bool:
	return isMultiplayer

func _setIsMultiplayer(arg):
	isMultiplayer = arg
	
func _handleGameQuit():
	if _getIsMultiplayer():
		NetworkManager._leave()
	print("Quitting")
