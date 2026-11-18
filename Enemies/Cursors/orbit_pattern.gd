class_name OrbitPattern
extends FormationPattern

@export var radius: float = 200.0
@export var speed: float = 2.0

func get_offset(index: int, total_enemies: int, time_passed: float) -> Vector2:
	var angle_step = TAU / total_enemies
	var current_angle = (time_passed * speed) + (index * angle_step)
	return Vector2(cos(current_angle), sin(current_angle)) * radius
