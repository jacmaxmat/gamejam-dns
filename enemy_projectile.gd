extends Node2D

var preload_bullet_destroy = preload("uid://c0ajdb5n0h87e")

var dir

@export var speed: float = 400.0
@onready var hitbox = $Area2D

func _process(delta: float) -> void:
	if Global.is_game_over:
		queue_free()
	position += dir * speed * delta
	if global_position.distance_to(Global.player.global_position + Vector2(240,135)) < 32:
		Global.player.velocity = Vector2(sign(Global.player.scale.x)*150,-200)
		Global.player.hit(1)
		queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_bullet_hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("hit"):
		area.hit(1)
	var bullet_destroy_instance = preload_bullet_destroy.instantiate()
	bullet_destroy_instance.global_position = global_position
	get_tree().get_root().add_child(bullet_destroy_instance)
	queue_free()
