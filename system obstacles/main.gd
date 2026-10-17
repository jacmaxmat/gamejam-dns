extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("start")
	
	
