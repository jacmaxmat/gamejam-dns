extends Control

@onready var hs_1 = $Scores/Score1

@export var a_player: AnimationPlayer
var sound_played = false

func _ready():
	sound_played = false
	Global.final_screen = self
	get_tree().paused = true
	if Global.score > SaveManager.highscore:
		SaveManager.highscore = Global.score
		SaveManager.save_data(SaveManager.highscore)
	$Scores/MyScore.text = "Score: " + str(Global.score)
	$Scores/Highscore.text = "Highscore: " + str(SaveManager.highscore)
	#initialize_your_stats()

func _process(delta):
	if Global.is_game_over:
		game_over()

#func _on_retry_pressed() -> void:
	#get_tree().paused = false
	#get_tree().reload_current_scene()

func game_over():
	if !sound_played:
		sound_played = true
		$AudioStreamPlayer.play()
	Global.window.global_position = Global.window.global_position.move_toward(Vector2(334.0,187.0), 10)
	Global.window.frame.size = Global.window.frame.size.move_toward(Vector2(480,270), 10)
	if Global.window.global_position == Vector2(334.0,187.0) and Global.window.frame.size == Vector2(480,270):
		$Menu.grab_focus()
		$Scores/MyScore.text = "Score: " + str(Global.score)
		$Scores/Highscore.text = "Highscore: " + str(SaveManager.highscore)
		visible = true
		

func _on_menu_pressed() -> void:
	get_tree().paused = false
	a_player.play_backwards("start")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if Global.is_game_over:
		Global.is_game_over = false
		get_tree().reload_current_scene()
		visible = false
		Global.title_screen.visible = true
		#get_tree().paused = false
