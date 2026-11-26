extends Node2D

var explosion = preload("uid://bti1l04bfnwm7")
@onready var falling_projectile_preload = preload("uid://h4t5f8dv7rut")

@export var health := 3

var target
@export var move_speed := 100
var target_offset : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_offset = Vector2(0, randi_range(-100, -120))
	target = Global.player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.is_game_over:
		queue_free()
	global_position= global_position.move_toward(target.global_position + target_offset, move_speed * delta)
	if global_position.distance_to(target.global_position + target_offset) < 100:
		if $ShootTimer.is_stopped():
			$ShootTimer.start()

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

func hit(damage):
	$Sprite2D.modulate = Color(18.892, 18.892, 18.892)
	health -= damage
	if health <= 0:
		Global.add_score(50)
		var explosion_instance = explosion.instantiate()
		explosion_instance.global_position = self.global_position
		get_tree().root.add_child(explosion_instance)
		queue_free()
	await get_tree().create_timer(.1).timeout
	$Sprite2D.modulate =Color(1.0, 1.0, 1.0)

func _on_shoot_timer_timeout() -> void:
	$Sprite2D.play("shoot")
	var falling_projectile_instance = falling_projectile_preload.instantiate()
	falling_projectile_instance.global_position = $ShootMarker.global_position
	get_tree().get_root().add_child(falling_projectile_instance)


func _on_sprite_2d_animation_finished() -> void:
	$Sprite2D.play("default")


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$Sprite2D/Area2D.set_collision_layer_value(4,true)
	$Sprite2D/Area2D.set_collision_mask_value(2,true)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$Sprite2D/Area2D.set_collision_layer_value(4,false)
	$Sprite2D/Area2D.set_collision_mask_value(2,false)
