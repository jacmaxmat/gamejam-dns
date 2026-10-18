extends Node2D

@export var health := 5
var offset_scale = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offset_scale = (global_position.x - Global.window.global_position.x)/Global.window.frame.size.x

func hit(damage):
	health -= damage
	$bialykursor.visible = true
	if health <= 0:
		Global.add_score(30)
		queue_free()
	await get_tree().create_timer(.1).timeout
	$bialykursor.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.is_game_over:
		queue_free()
	global_position.x = Global.window.global_position.x + (Global.window.frame.size.x * offset_scale)
	#global_position.x = clamp(global_position.x, Global.window.global_position.x, Global.window.global_position.x + Global.window.frame.size.x)
