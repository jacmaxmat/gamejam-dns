class_name AnimationComponent
extends Node

@export_subgroup("nodes")
@export var animation_tree: AnimationTree
@export var visuals_node: Node2D

var legs_playback: AnimationNodeStateMachinePlayback

func _ready() -> void:
	if animation_tree:
		legs_playback = animation_tree.get("parameters/LegsStateMachine/playback")

func handle_animations(body: CharacterBody2D, target_position: Vector2, is_shooting_input: bool) -> void:
	if animation_tree == null or visuals_node == null:
		return
	
	var is_aiming_left: bool = target_position.x < visuals_node.global_position.x
	visuals_node.scale.x = -1 if is_aiming_left else 1
	
	var is_moving: bool = abs(body.velocity.x)
	var is_grounded: bool = body.is_on_floor()
	var is_jumping: bool = not is_grounded and body.velocity.y < 0
	var is_falling: bool = not is_grounded and body.velocity.y >= 0

	animation_tree["parameters/LegsStateMachine/conditions/is_moving"] = is_moving
	animation_tree["parameters/LegsStateMachine/conditions/is_idle"] = not is_moving
	animation_tree["parameters/LegsStateMachine/conditions/is_grounded"] = is_grounded
	animation_tree["parameters/LegsStateMachine/conditions/is_jumping"] = is_jumping
	animation_tree["parameters/LegsStateMachine/conditions/is_falling"] = is_falling
	
	animation_tree["parameters/UpperBodyStateMachine/conditions/is_shooting"] = is_shooting_input
	animation_tree["parameters/UpperBodyStateMachine/conditions/is_not_shooting"] = not is_shooting_input
	var local_mouse: Vector2 = visuals_node.get_local_mouse_position()
	var aim_direction: Vector2 = local_mouse.normalized()
	animation_tree["parameters/UpperBodyStateMachine/AimSpace/blend_position"] = aim_direction
	animation_tree["parameters/UpperBodyStateMachine/ShootSpace/blend_position"] = aim_direction
