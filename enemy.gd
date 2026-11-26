extends Node2D


var explosion = preload("uid://bti1l04bfnwm7")
@export var health := 6

var target
@export var move_speed := 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = Global.player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.is_game_over:
		queue_free()
	global_position= global_position.move_toward(target.global_position, move_speed * delta)
	$Sprite2D.look_at(target.global_position)
	$Sprite2D.rotation_degrees += 90

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !Global.player.is_invincible:
		if !Global.player.is_topdown:
			Global.player.velocity = Vector2(sign(Global.player.scale.x)*150,-200)
		Global.player.hit(1)
	else:
		if !Global.player.is_topdown:
			Global.player.velocity = Vector2(sign(Global.player.scale.x)*150,-500)
		var explosion_instance = explosion.instantiate()
		explosion_instance.global_position = self.global_position
		get_tree().root.add_child(explosion_instance)
	queue_free()
	#if body.has_method("hit"):
		#body.hit(1)
	#queue_free()
	#
func hit(damage):
	$Sprite2D.modulate = Color(18.892, 18.892, 18.892)
	health -= damage
	if health <= 0:
		Global.add_score(50)
		queue_free()
	await get_tree().create_timer(.1).timeout
	$Sprite2D.modulate =Color(1.0, 1.0, 1.0)
func _on_area_2d_area_entered(area: Area2D) -> void:
	pass
	#if area.has_method("hit"):
		#area.hit(1)
	#queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$Sprite2D/Area2D.set_collision_layer_value(4,true)
	$Sprite2D/Area2D.set_collision_mask_value(2,true)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$Sprite2D/Area2D.set_collision_layer_value(4,false)
	$Sprite2D/Area2D.set_collision_mask_value(2,false)
