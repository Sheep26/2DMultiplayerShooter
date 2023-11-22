extends Control
@onready var TextBox: TextEdit = $TextEdit

var globalScript = load("res://Scripts/Global.gd")

func _on_button_pressed():
	globalScript._connect()
