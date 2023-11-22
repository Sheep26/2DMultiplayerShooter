extends Node

@onready var httpClient: HTTPRequest = $HTTPRequest

func _ready():
	httpClient.request_completed.connect(_request_completed)

func _connect(ip: String):
	httpClient.request(ip + "/join")
	
func _request_completed(result, response_code, headers, body):
	pass
