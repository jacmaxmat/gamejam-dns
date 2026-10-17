extends Node


var player
var title_screen
var cam
var window
var view
var final_screen
var cursors_dragging: int = 0
var drag_direction: Vector2 = Vector2.ZERO
var is_game_over = false
# Called when the node enters the scene tree for the first time.

var score := 0
var icons = []

func _ready() -> void:
	pass # Replace with function body.

func initialize():
	score = 0
	is_game_over = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("ui_left"):
		#game_over()
	if is_game_over:
		window.global_position = window.global_position.move_toward(Vector2(334.0,187.0), 10)
		window.frame.size = window.frame.size.move_toward(Vector2(480,270), 10)
		if window.global_position == Vector2(334.0,187.0) and window.frame.size == Vector2(480,270):
			print("!!!")
			final_screen.visible = true
		


func game_over():
	print("?")
	get_tree().paused = true
	is_game_over = true
