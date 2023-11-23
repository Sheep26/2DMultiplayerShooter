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
	serverIP = ip

func _connect():
	httpRequest.request(serverIP + "/join?name=" + Global.playerName)
