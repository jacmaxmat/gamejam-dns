extends Node2D

@onready var falling_projectile_preload = preload("uid://h4t5f8dv7rut")

@export var health := 3

var target
@export var move_speed := 100
var target_offset : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_offset = Vector2(randi_range(200, 280), randi_range(-100, -120))
	target = Global.player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.is_game_over:
		queue_free()
	global_position= global_position.move_toward(target.global_position + target_offset, move_speed * delta)
	if global_position.distance_to(target.global_position + target_offset) < 100:
		if $ShootTimer.is_stopped():
			$ShootTimer.start()
	if global_position.distance_to(Global.player.global_position + Vector2(240,135)) < 32:
		Global.player.velocity = Vector2(sign(Global.player.scale.x)*150,-200)
		Global.player.hit(1)
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		body.hit(1)
	queue_free()

func hit(damage):
	health -= damage
	if health <= 0:
		Global.add_score(50)
		queue_free()

func _on_shoot_timer_timeout() -> void:
	var falling_projectile_instance = falling_projectile_preload.instantiate()
	falling_projectile_instance.global_position = $ShootMarker.global_position
	get_tree().get_root().add_child(falling_projectile_instance)
