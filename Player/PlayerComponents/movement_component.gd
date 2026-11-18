class_name MovementComponent
extends Node

@export_subgroup("settings")
@export var speed: float = 100;
@export var ground_accel_speed: float = 6.0
@export var ground_decel_speed: float = 8.0
@export var air_accel_speed: float = 10.0
@export var air_decel_speed: float = 3.0

func handle_horizontal_movement(body: CharacterBody2D, direction: Vector2) -> void:
	if !body.is_topdown:
		var velocity_change_speed: float = 0.0
		if body.is_on_floor():
			velocity_change_speed = ground_accel_speed if direction.x != 0 else ground_decel_speed
		else:
			velocity_change_speed = air_accel_speed if direction.x != 0 else air_decel_speed
		body.velocity.x = move_toward(body.velocity.x, direction.x * speed, velocity_change_speed)
	else:
		var velocity_change_speed: float = 0.0
		velocity_change_speed = ground_accel_speed if direction != Vector2.ZERO else ground_decel_speed*2
		body.velocity = body.velocity.move_toward(direction*speed, velocity_change_speed)
