extends Node2D

var preload_bullet_destroy = preload("uid://c0ajdb5n0h87e")

@export var speed: float = 800.0
@onready var hitbox = $BulletHitbox

func _process(delta: float) -> void:
	position += hitbox.transform.x * speed * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_bullet_hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("hit"):
		area.hit(1)
	var bullet_destroy_instance = preload_bullet_destroy.instantiate()
	bullet_destroy_instance.global_position = global_position
	get_tree().get_root().add_child(bullet_destroy_instance)
	queue_free()
