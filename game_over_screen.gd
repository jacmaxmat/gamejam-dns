extends CanvasLayer

func _ready() -> void:
	Global.final_screen = self

func game_over():
	visible=true
	$VBoxContainer/Score.text ="Score: "+ str(Global.score)
	$AnimationPlayer.play("reveal")

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menus/title_screen.tscn")
