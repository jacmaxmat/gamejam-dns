class_name AimComponent
extends Node

@export_subgroup("nodes")
@export var upper_body_node: Node2D

func handle_aim(body: CharacterBody2D, target_position: Vector2):
	if upper_body_node == null:
		return
	upper_body_node.look_at(target_position)
	var is_aiming_left: bool = target_position.x < upper_body_node.global_position.x
	if is_aiming_left:
		upper_body_node.scale.y = -1
	else:
		upper_body_node.scale.y = 1
