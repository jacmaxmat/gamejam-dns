class_name LinePattern
extends FormationPattern

@export var spacing: float = 100.0
@export var y_offset: float = -300.0

func get_offset(index: int, total_enemies: int, time_passed: float) -> Vector2:
	var x = (index - (total_enemies - 1) / 2.0) * spacing
	return Vector2(x, y_offset)
