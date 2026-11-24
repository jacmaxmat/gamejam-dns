extends Node2D

@export var health: int = 5
@export var move_speed: float = 200.0
@export var drag_speed: float = 130.0

enum State { APPROACHING, DRAGGING }
var current_state = State.APPROACHING

var target_offset_x: float = 0.0
var pull_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	target_offset_x = randf_range(-120.0, 120.0)

func _process(delta: float) -> void:
	if Global.is_game_over or not is_instance_valid(Global.window):
		if current_state == State.DRAGGING:
			Global.cursors_dragging = max(0, Global.cursors_dragging - 1)
		queue_free()
		return
		
	match current_state:
		State.APPROACHING:
			var target_pos: Vector2 = Global.window.bar.global_position + Vector2(target_offset_x, 0.0)
			scale.x = 1 if global_position.x < target_pos.x else -1
			
			if global_position.distance_to(target_pos) > 10.0:
				pull_direction = target_pos.direction_to(global_position)
				global_position = global_position.move_toward(target_pos, move_speed * delta)
			else:
				current_state = State.DRAGGING
				Global.cursors_dragging += 1
				
		State.DRAGGING:
			global_position = Global.window.bar.global_position + Vector2(target_offset_x, 0.0)
			Global.window.move(pull_direction, drag_speed, delta)

func hit(damage: int) -> void:
	health -= damage
	if has_node("bialykursor"):
		$bialykursor.visible = true
	
	if health <= 0:
		if current_state == State.DRAGGING:
			Global.cursors_dragging = max(0, Global.cursors_dragging - 1)
		Global.add_score(30)
		queue_free()
		return
		
	await get_tree().create_timer(0.1).timeout
	if is_instance_valid(self) and has_node("bialykursor"):
		$bialykursor.visible = false
