extends Node

var serverIP: String
var isJoiningGame: bool = false
var downloadFile: String
@onready var httpRequest: HTTPRequest = HTTPRequest.new()
@onready var joinHttpRequest: HTTPRequest = HTTPRequest.new()
@onready var leaveHttpRequest: HTTPRequest = HTTPRequest.new()
@onready var updatePlayerHttpRequest: HTTPRequest = HTTPRequest.new()
@onready var downloadMapRequest: HTTPRequest = HTTPRequest.new()
@onready var getPlayerHttpReqiest: HTTPRequest = HTTPRequest.new()
@onready var getBulletHttpReqiest: HTTPRequest = HTTPRequest.new()

func _setup(ip: String):
	if not httpRequest.is_inside_tree():
		add_child(httpRequest)
		httpRequest.request_completed.connect(_request_completed)
	if not leaveHttpRequest.is_inside_tree():
		add_child(leaveHttpRequest)
	if not joinHttpRequest.is_inside_tree():
		add_child(joinHttpRequest)
		joinHttpRequest.request_completed.connect(_join_request_completed)
	if not updatePlayerHttpRequest.is_inside_tree():
		add_child(updatePlayerHttpRequest)
	if not downloadMapRequest.is_inside_tree():
		add_child(downloadMapRequest)
		downloadMapRequest.request_completed.connect(_downloadMap_completed)
	if not getPlayerHttpReqiest.is_inside_tree():
		add_child(getPlayerHttpReqiest)
		getPlayerHttpReqiest.request_completed.connect(_get_player_request_completed)
	if not getBulletHttpReqiest.is_inside_tree():
		add_child(getBulletHttpReqiest)
		getBulletHttpReqiest.request_completed.connect(_get_bullet_request_completed)
	serverIP = ip

func _request_completed(_result, response_code, _headers, _body):
	pass
	
func _get_player_request_completed(_result, response_code, _headers, _body):
	pass

func _get_bullet_request_completed(_result, response_code, _headers, _body):
	pass

func _join_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var bodyString = body.get_string_from_utf8()
		var split = bodyString.split(":")
		print("Connected to " + split[0])
		isJoiningGame = true
		var mapPathOnClient = split[1] + ":" + split[2]
		var mapPathOnServer = split[3]
		GameServer._setup(serverIP, mapPathOnClient, split[6], int(split[9]))
		if not FileAccess.file_exists(mapPathOnClient):
			print("Downloading Map")
			_downloadMap(mapPathOnServer, mapPathOnClient)
		else:
			GameServer._loadIntoGame()
	elif response_code == 400:
		print("Either server issue or request issue")

func _downloadMap_completed(result, _response_code, _headers, body):
	if result != OK:
		print("Download failed")
	if not DirAccess.dir_exists_absolute(Global.mapsFolder):
		DirAccess.make_dir_absolute(Global.mapsFolder)
	var file: FileAccess = FileAccess.open(downloadFile, FileAccess.WRITE)
	file.store_string(body.get_string_from_utf8())
	file.close()
	if isJoiningGame:
		GameServer._loadIntoGame()

func _connect():
	print("Connecting to " + serverIP)
	joinHttpRequest.request("http://" + serverIP + "/join?name=" + Global.playerName)

func _leave():
	print("Disconnecting from " + serverIP)
	leaveHttpRequest.request("http://" + serverIP + "/leave?id=" + GameServer.playerID)

func _sendRequest(data: String):
	if "updatePlayer" in data:
		updatePlayerHttpRequest.request("http://" + data)
	else:
		httpRequest.request("http://" + data)

func _downloadMap(mapPath, savePath):
	downloadFile = savePath
	downloadMapRequest.request("http://" + serverIP + "/map?mapPath=" + mapPath)
