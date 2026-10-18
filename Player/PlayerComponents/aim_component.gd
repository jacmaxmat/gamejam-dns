class_name AimComponent
extends Node

@export_subgroup("nodes")
@export var gun_barrel: Marker2D

func handle_aim(target_position: Vector2) -> void:
	if gun_barrel == null:
		return
	gun_barrel.look_at(target_position)
