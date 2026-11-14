extends Area2D

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$CollisionShape2D.disabled = false
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$CollisionShape2D.disabled = true
