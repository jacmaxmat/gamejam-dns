class_name ShootingComponent
extends Node

@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.2
@export var gun_barrel: Node2D

var can_shoot: bool = true

func shoot() -> void:
	if not can_shoot or bullet_scene == null or gun_barrel == null:
		return
	
	var bullet = bullet_scene.instantiate()

	bullet.global_position = gun_barrel.global_position
	get_tree().get_root().add_child(bullet)
	bullet.look_at(bullet.get_global_mouse_position())
	bullet.global_rotation_degrees += randi_range(-3, 3)
	
	can_shoot = false
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
	
func handle_shoot(want_to_shoot: bool) -> void:
	if (want_to_shoot):
		shoot()
