extends Node

var serverIP: String
@onready var httpRequest: HTTPRequest = HTTPRequest.new()

func _get_authorization_header() -> String:
	return ""

func _get_headers():
	var headers = PackedStringArray()
	headers.append("Authorization: Bearer " + _get_authorization_header())
	return headers

func _setup(ip: String):
	if not httpRequest.is_inside_tree():
		add_child(httpRequest)
		httpRequest.request_completed.connect(_request_completed)
	serverIP = ip
	
func _request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var bodyString = body.get_string_from_utf8()
		print(bodyString)
		var split = bodyString.split(":")
		var whatRequest = split[0]
		if whatRequest == "join":
			print("Joined game " + split[1])
			Global.gameServer = GameServer.new(serverIP, split[2])
			Global.gameServer._loadIntoGame()
	elif response_code == 400:
		print("Invalid request")

func _connect():
	httpRequest.request("http://" + serverIP + "/join?name=" + Global.playerName)
