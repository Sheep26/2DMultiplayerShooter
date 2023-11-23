extends Control

func _ready():
	Global._loadSettings()
	Global.playerName = Global.getData()["settings"]["name"]

func _process(_delta):
	pass

func _on_singleplayer_button_pressed():
	get_tree().current_scene.queue_free()
	var s = ResourceLoader.load("res://Scenes/Levels/Level1.tscn")
	var new = s.instantiate()
	get_tree().root.add_child(new)
	get_tree().current_scene = new

func _on_multiplayer_button_pressed():
	get_tree().current_scene.queue_free()
	var s = ResourceLoader.load("res://Scenes/MainMenu/Multiplayer/MultiplayerUI.tscn")
	var new = s.instantiate()
	get_tree().root.add_child(new)
	get_tree().current_scene = new

func _on_settings_button_pressed():
	get_tree().current_scene.queue_free()
	var s = ResourceLoader.load("res://Scenes/MainMenu/Settings/Settings.tscn")
	var new = s.instantiate()
	get_tree().root.add_child(new)
	get_tree().current_scene = new
