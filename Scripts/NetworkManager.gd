extends Node

var serverIP: String
var isJoiningGame: bool = false
var downloadFile: String
@onready var httpRequest: HTTPRequest = HTTPRequest.new()
@onready var updatePlayerHttpRequest: HTTPRequest = HTTPRequest.new()
@onready var downloadRequest: HTTPRequest = HTTPRequest.new()

func _setup(ip: String):
	if not httpRequest.is_inside_tree():
		add_child(httpRequest)
		httpRequest.request_completed.connect(_request_completed)
	if not updatePlayerHttpRequest.is_inside_tree():
		add_child(updatePlayerHttpRequest)
		updatePlayerHttpRequest.request_completed.connect(_request_completed)
	if not downloadRequest.is_inside_tree():
		add_child(downloadRequest)
		downloadRequest.request_completed.connect(_download_completed)
	serverIP = ip

func _request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var bodyString = body.get_string_from_utf8()
		var split = bodyString.split(":")
		var whatRequest = split[0]
		if whatRequest == "join":
			print("Connected to " + split[1])
			isJoiningGame = true
			var mapPathOnClient = split[2] + ":" + split[3]
			var mapPathOnServer = split[4]
			GameServer._setup(serverIP, mapPathOnClient, split[7])
			if not FileAccess.file_exists(mapPathOnClient):
				print("Downloading Map")
				_downloadMap(mapPathOnServer, mapPathOnClient)
			else:
				GameServer._loadIntoGame()
	elif response_code == 400:
		print("Either server issue or request issue")
		
func _download_completed(result, _response_code, _headers, body):
	if result != OK:
		print("Download failed")
	# How to save file we have the bytes under the body arg and you can convert it to String with get_string_from_utf8()
	if isJoiningGame:
		GameServer._loadIntoGame()

func _connect():
	print("Connecting to " + serverIP)
	httpRequest.request("http://" + serverIP + "/join?name=" + Global.playerName)

func _leave():
	print("Disconnecting from " + serverIP)
	httpRequest.request("http://" + serverIP + "/leave?id=" + GameServer.playerID)

func _sendRequest(data: String):
	if "updatePlayer" in data:
		updatePlayerHttpRequest.request("http://" + data)
	else:
		httpRequest.request("http://" + data)
		
func _downloadMap(mapPath, savePath):
	downloadFile = savePath
	downloadRequest.request("http://" + serverIP + "/map?mapPath=" + mapPath)
