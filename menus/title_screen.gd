extends Control

func _ready() -> void:
	Global.title_screen = self
	$VBoxContainer/StartGameButton.grab_focus()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_start_game_button_pressed() -> void:
	Global.initialize()
	$AnimationPlayer.play("start")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://main.tscn")
