extends StaticBody2D

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	set_collision_layer_value(3,true)
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	set_collision_layer_value(3,false)
