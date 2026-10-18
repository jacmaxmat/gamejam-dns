extends Node2D

@export var speed: float = 800.0
@onready var hitbox = $BulletHitbox

func _process(delta: float) -> void:
	position += transform.x * speed * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_bullet_hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("hit"):
		area.hit(1)
		queue_free()
