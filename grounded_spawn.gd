extends Node2D

var grounded_preload = preload("uid://djbggeigias6l")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var platforms = get_parent().get_node("Platforms")
	var enemy_instance =grounded_preload.instantiate()
	var platform = platforms.get_child(randi_range(0, platforms.get_child_count()-1)).get_child(0)
	enemy_instance.global_position = platform.global_position + Vector2(0,-20)
	get_tree().get_root().add_child(enemy_instance)
