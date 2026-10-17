extends Node

var title_screen
var cam
var window
var view
var cursors_dragging: int = 0
var drag_direction: Vector2 = Vector2.ZERO
var is_game_over = false
# Called when the node enters the scene tree for the first time.

var score := 0

func _ready() -> void:
	pass # Replace with function body.

func initialize():
	score = 0
	is_game_over = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		game_over()
	if is_game_over:
		print("asdasd")
		while window.global_position != Vector2(574,322):
			window.global_position = window.global_position.move_toward(Vector2(574,322), 10)


func game_over():
	print("?")
	get_tree().paused = true
	is_game_over = true
