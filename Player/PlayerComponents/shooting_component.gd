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
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_position = gun_barrel.global_position
	bullet.rotation = gun_barrel.global_rotation
	bullet.direction = Vector2.RIGHT.rotated(gun_barrel.global_rotation)
	
func handle_shoot(want_to_shoot: bool) -> void:
	if (want_to_shoot):
		shoot()
