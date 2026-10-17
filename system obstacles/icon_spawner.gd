extends Node2D

var icon_preload = preload("uid://tlauidkrriq1")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_icon():
	var posx = 44 + randi_range(0,12) * 88
	var posy = 26 + randi_range(0,6) * 85
	var icon_instance = icon_preload.instantiate()
	icon_instance.global_position = Vector2(posx, posy)
	get_tree().get_root().add_child(icon_instance)
	

func _on_spawn_timer_timeout() -> void:
	print("spawn")
	spawn_icon()
