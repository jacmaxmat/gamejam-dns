extends Node

var is_dashing = false
@export var DASH_SPEED: int = 600
var dir = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func handle_dash(body):
	if Input.is_action_just_pressed("dash") and !is_dashing:
		dir = (Global.mouse_position - body.global_position).normalized()
		if dir != Vector2.ZERO:
			body.velocity = dir * DASH_SPEED
			is_dashing = true
			$Timer.start()
	elif is_dashing:
		for i in body.get_slide_collision_count():
			var collision = body.get_slide_collision(i)
			if collision.get_collider():
				
				if collision.get_collider().name=="WindowBounds":
					Global.main_window.moving_direction = dir * 4
		
func _on_timer_timeout() -> void:
	is_dashing = false
