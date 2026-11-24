class_name AnimationComponent
extends Node

@export_subgroup("nodes")
@export var animation_tree: AnimationTree
@export var visuals_node: Node2D

var legs_playback: AnimationNodeStateMachinePlayback
var upper_body_playback: AnimationNodeStateMachinePlayback

func _ready() -> void:
	if animation_tree:
		legs_playback = animation_tree.get("parameters/LegsStateMachine/playback")
		animation_tree.active = true
		animation_tree["parameters/Blend2/blend_amount"] = 1.0
		upper_body_playback = animation_tree["parameters/UpperBodyStateMachine/playback"]
		if upper_body_playback != null:
			upper_body_playback.start("AimSpace")

func handle_animations(body: CharacterBody2D, target_position: Vector2, want_to_shoot: bool) -> void:
	if animation_tree == null or visuals_node == null:
		return

	var local_mouse: Vector2 = body.get_local_mouse_position()
	var aim_direction: Vector2 = local_mouse.normalized()
	if local_mouse.x < 0:
		visuals_node.scale.x = -1
	else:
		visuals_node.scale.x = 1
	
	# Sztywne strefy celowania
	var blend_val: float = 0.0
	if aim_direction.y < -0.75:
		blend_val = -1.0
	elif aim_direction.y < -0.25:
		blend_val = -0.5
	elif aim_direction.y < 0.25:
		blend_val = 0.0
	elif aim_direction.y < 0.75:
		blend_val = 0.5
	else:
		blend_val = 1.0

	var is_moving: bool = abs(body.velocity.x) > 0
	var is_grounded: bool = body.is_on_floor()
	var is_jumping: bool = not is_grounded and body.velocity.y < 0
	var is_falling: bool = not is_grounded and body.velocity.y >= 0

	animation_tree["parameters/LegsStateMachine/conditions/is_moving"] = is_moving
	animation_tree["parameters/LegsStateMachine/conditions/is_idle"] = not is_moving
	animation_tree["parameters/LegsStateMachine/conditions/is_grounded"] = is_grounded
	animation_tree["parameters/LegsStateMachine/conditions/is_jumping"] = is_jumping
	animation_tree["parameters/LegsStateMachine/conditions/is_falling"] = is_falling
	
	animation_tree["parameters/UpperBodyStateMachine/conditions/is_shooting"] = want_to_shoot
	animation_tree["parameters/UpperBodyStateMachine/conditions/is_not_shooting"] = not want_to_shoot
	animation_tree["parameters/UpperBodyStateMachine/AimSpace/blend_position"] = blend_val
	animation_tree["parameters/UpperBodyStateMachine/ShootSpace/blend_position"] = blend_val
