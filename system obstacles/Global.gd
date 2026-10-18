extends Node


var shakecamera
var hud
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
	cursors_dragging = 0
	score = 0
	is_game_over = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		game_over()
	pass
		

func add_score(amount):
	score += amount
	hud.update_score(amount)

func update_health(amount):
	player.health = max(0, player.health-amount)
	hud.update_health(player.health)
	if player.health <= 0:
		game_over()
	
func game_over():
	final_screen.game_over()
	is_game_over = true
	await get_tree().create_timer(.1).timeout
	get_tree().paused = true
	
