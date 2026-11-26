extends AnimatedSprite2D

var direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += direction * delta * 10

func _on_timer_timeout() -> void:
	direction *= -1
