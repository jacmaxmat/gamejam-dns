class_name AnimationComponent
extends Node

@export_subgroup("nodes")
@export var animation_tree: AnimationTree
@export var visuals_node: Node2D

var legs_playback: AnimationNodeStateMachinePlayback

func _ready() -> void:
	if animation_tree:
		legs_playback = animation_tree.get("parameters/playback")

func handle_animations(body: CharacterBody2D, target_position: Vector2) -> void:
	if animation_tree == null or visuals_node == null:
		return
	
	var is_aiming_left: bool = target_position.x < visuals_node.global_position.x
	visuals_node.scale.x = -1 if is_aiming_left else 1
	
	if not body.is_on_floor():
		if body.velocity.y < 0:
			legs_playback.travel("jump")
		#else:
			#legs_playback.travel("fall")
	else:
		if not abs(body.velocity.x) > 10:
			#legs_playback.travel("walk")
		#else:
			legs_playback.travel("legs_idle")
