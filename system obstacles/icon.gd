extends Node2D

var popup_preload = preload("uid://dfyfwjfuri5wl")

var slotx
var sloty

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.frame = randi_range(1,6)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.is_game_over:
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	var popup_instance = popup_preload.instantiate()
	popup_instance.global_position = self.global_position
	get_tree().get_root().add_child(popup_instance)
	Global.icons.erase([slotx,sloty])
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	$Area2D.monitorable = false

func _on_area_2d_body_exited(body: Node2D) -> void:
	$Area2D.monitorable = true
