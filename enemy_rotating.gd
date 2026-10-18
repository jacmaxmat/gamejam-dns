extends "res://enemy.gd"

var preload_projectile = preload("uid://bvjf0dgwdip2s")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = Global.player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.is_game_over:
		queue_free()
	if global_position.distance_to(Global.player.global_position + Vector2(240,135)) < 300:
		if $ShootTimer.is_stopped():
			$ShootTimer.start()
		global_position= global_position.move_toward(target.global_position + Vector2(240,135), move_speed/10 * delta)
	else:
		global_position= global_position.move_toward(target.global_position + Vector2(240,135), move_speed * delta)
		$ShootTimer.stop()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	#if body.has_method("hit"):
		#body.hit(1)
	#queue_free()
	#
func hit(damage):
	health -= damage
	if health <= 0:
		Global.add_score(50)
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	pass
	#if area.has_method("hit"):
		#area.hit(1)
	#queue_free()


func _on_shoot_timer_timeout() -> void:
	var projectile_instance = preload_projectile.instantiate()
	projectile_instance.global_position = global_position
	projectile_instance.dir = global_position.direction_to(target.global_position + Vector2(240,135))
	get_tree().get_root().add_child(projectile_instance)
