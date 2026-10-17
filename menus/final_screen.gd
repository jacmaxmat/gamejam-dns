extends Control

@onready var hs_1 = $Scores/Score1

@export var a_player: AnimationPlayer

func _ready():
	Global.final_screen = self
	get_tree().paused = true
	if Global.score > SaveManager.highscore:
		SaveManager.highscore = Global.score
		SaveManager.save_data(SaveManager.highscore)
	$Scores/MyScore.text = "Score: " + str(Global.score)
	$Scores/Highscore.text = "Highscore: " + str(SaveManager.highscore)
	#initialize_your_stats()

func _process(delta):
	pass

#func _on_retry_pressed() -> void:
	#get_tree().paused = false
	#get_tree().reload_current_scene()


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
