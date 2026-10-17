extends Node2D

var popup_preload = preload("uid://dfyfwjfuri5wl")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	var popup_instance = popup_preload.instantiate()
	popup_instance.global_position = self.global_position
	get_tree().get_root().add_child(popup_instance)
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	var popup_instance = popup_preload.instantiate()
	popup_instance.global_position = self.global_position
	get_tree().get_root().add_child(popup_instance)
	queue_free()
