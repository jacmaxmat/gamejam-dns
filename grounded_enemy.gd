extends "res://enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.is_game_over:
		queue_free()
	if target==$Right or target ==$Left:
		global_position = global_position.move_toward(Vector2(target.global_position.x, global_position.y), move_speed * delta)
		if global_position.x == target.global_position.x:
			if target ==$Right:
				target = $Left
				scale.x *= -1
			else:
				target = $Right
				scale.x *= -1
	if global_position.distance_to(Global.player.global_position + Vector2(240,135)) < 32:
		Global.player.velocity = Vector2(sign(Global.player.scale.x)*150,-200)
		Global.player.hit(1)
		queue_free()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	#if body.has_method("hit"):
		#body.hit(1)
	#queue_free()
	#
func hit(damage):
	health -= damage
	if health <= 0:
		Global.add_score(70)
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	pass
	#if area.has_method("hit"):
		#area.hit(1)
	#queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	target = $Right
