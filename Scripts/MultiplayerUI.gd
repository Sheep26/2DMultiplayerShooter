extends Control
@onready var TextBox: TextEdit = $TextEdit

var globalScript = load("res://Scripts/Global.gd")

func _on_button_pressed():
	globalScript.networkManager._connect(TextBox.get_line(0))
