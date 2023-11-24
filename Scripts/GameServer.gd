extends Node

@onready var bullet = preload("res://Objects/Bullet.tscn")
var serverIP: String
var mapPath: String
var otherPlayers: String
var bullets: PackedScene
var gunID: int
var playerID: String

func _setup(serverIPArg: String, mapPathArg: String, playerIDArg: String, gunIDArg: int):
	self.serverIP = serverIPArg
	self.mapPath = mapPathArg
	self.playerID = playerIDArg
	self.gunID = gunIDArg

func _loadIntoGame():
	NetworkManager.isJoiningGame = false
	get_tree().current_scene.queue_free()
	var s = ResourceLoader.load(mapPath)
	var new = s.instantiate()
	get_tree().root.add_child(new)
	get_tree().current_scene = new

func _sendRequest(data):
	NetworkManager._sendRequest(serverIP + "/" + data)
