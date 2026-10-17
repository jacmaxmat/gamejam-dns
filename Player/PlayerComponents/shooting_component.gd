class_name ShootingComponent
extends Node

@export var bullet_scene: PackedScene
@export var spawn_point: Node2D
@export var fire_rate: float = 0.2

var can_shoot: bool = true

func shoot() -> void:
	if not can_shoot or bullet_scene == null or spawn_point == null:
		return
	
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_position = spawn_point.global_position
	bullet.global_rotation = spawn_point.global_rotation
	
	can_shoot = false
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
	
func handle_shoot(want_to_shoot: bool) -> void:
	if (want_to_shoot):
		shoot()
