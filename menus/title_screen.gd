extends Control

func _ready() -> void:
	Global.title_screen = self

func _on_quit_button_pressed():
	get_tree().quit()

func _on_start_game_button_pressed() -> void:
	Global.score = 0
	get_tree().paused = false
	self.visible = false
