extends Control
@onready var TextBox: TextEdit = $TextEdit

func _on_button_pressed():
	NetworkManager._setup(TextBox.get_line(0))
	NetworkManager._connect()
