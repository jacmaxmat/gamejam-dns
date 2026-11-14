extends Node2D

@export var speed: float = 1600
@onready var hitbox : Area2D = $Hitbox

var target = null
var target_offset : Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and target==null:
		if hitbox.has_overlapping_areas():
			grab(hitbox.get_overlapping_areas()[0])
	elif Input.is_action_just_released("shoot") and target != null:
		target = null
		target_offset = Vector2.ZERO

	global_position = Global.mouse_position
	if target:
		target.global_position = global_position + target_offset
	#if target == null:
		#global_position = Global.mouse_position
	#else:
		#global_position = global_position.move_toward(Global.mouse_position, speed*.75*delta)
		#target.global_position = global_position + target_offset
	

func grab(area):
	target = area
	target_offset = target.global_position - global_position
