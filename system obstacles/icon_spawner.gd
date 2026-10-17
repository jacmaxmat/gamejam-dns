extends Node2D

var icon_preload = preload("uid://tlauidkrriq1")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_icon():
	var slotx = randi_range(0,12)
	var sloty = randi_range(0,6)
	while Global.icons.has([slotx,sloty]):
		slotx = randi_range(0,12)
		sloty = randi_range(0,6)
	var posx = 44 + slotx * 88
	var posy = 26 + sloty * 85
	var icon_instance = icon_preload.instantiate()
	icon_instance.global_position = Vector2(posx, posy)
	icon_instance.slotx = slotx
	icon_instance.sloty = sloty
	get_tree().get_root().add_child(icon_instance)
	Global.icons.append([slotx,sloty])
	
func _on_spawn_timer_timeout() -> void:
	spawn_icon()
