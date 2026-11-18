class_name InputComponent
extends Node

var input_horizontal: float = 0.0
var input_vertical: float = 0.0

func _process(delta: float) -> void:
	input_horizontal = Input.get_axis("move_left", "move_right")
	input_vertical = Input.get_axis("move_up", "move_down")
	
func get_jump_input() -> bool:
	return Input.is_action_just_pressed("jump")

func get_jump_input_released() -> bool:
	return Input.is_action_just_released("jump")
	
func get_shoot_input() -> bool:
	return Input.is_action_pressed("shoot")
