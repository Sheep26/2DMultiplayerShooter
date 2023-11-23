extends Node

var serverIP: String
@onready var httpRequest: HTTPRequest = HTTPRequest.new()
@onready var updatePlayerHttpRequest: HTTPRequest = HTTPRequest.new()

func _setup(ip: String):
	if not httpRequest.is_inside_tree():
		add_child(httpRequest)
		httpRequest.request_completed.connect(_request_completed)
		add_child(updatePlayerHttpRequest)
		updatePlayerHttpRequest.request_completed.connect(_request_completed)
	serverIP = ip
	
func _request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var bodyString = body.get_string_from_utf8()
		print(bodyString)
		var split = bodyString.split(":")
		var whatRequest = split[0]
		if whatRequest == "join":
			print("Joined game " + split[1])
			var level = split[2] + ":" + split[3]
			print(level)
			GameServer._setup(serverIP, level, split[6])
			GameServer._loadIntoGame()
	elif response_code == 400:
		print("Either server issue or request issue")

func _connect():
	httpRequest.request("http://" + serverIP + "/join?name=" + Global.playerName)

func _sendRequest(data: String):
	if data.begins_with("updatePlayer"):
		updatePlayerHttpRequest.request("http://" + data)
	else:
		httpRequest.request("http://" + data)
