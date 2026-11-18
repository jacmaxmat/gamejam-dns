extends Node2D

@export var health := 5
@export var move_speed := 200

enum State { APPROACHING, DRAGGING }
var current_state = State.APPROACHING

var target_offset_x = 0
var offset_scale = 0.
var pull_direction := Vector2.ZERO 

func _ready() -> void:
	target_offset_x = randi_range(-120, 120)

func _process(delta: float) -> void:
	if Global.is_game_over:
		if current_state == State.DRAGGING:
			Global.cursors_dragging = max(0, Global.cursors_dragging - 1)
		queue_free()
		return
		
	match current_state:
		State.APPROACHING:
			if global_position.x < Global.window.bar.global_position.x:
				scale.x = 1
			else:
				scale.x = -1
				
			var target_pos = Global.window.bar.global_position + Vector2(target_offset_x, 0)
			if global_position.distance_to(target_pos) > 10.0:
				pull_direction = target_pos.direction_to(global_position)
				
			global_position = global_position.move_toward(target_pos, move_speed * delta)
			
		State.DRAGGING:
			global_position.x = Global.window.global_position.x + (Global.window.frame.size.x * offset_scale)
			Global.window.move(-pull_direction, 130, delta)

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

func _on_area_2d_area_entered(area: Area2D) -> void:
	if current_state == State.DRAGGING:
		return
		
	current_state = State.DRAGGING
	Global.cursors_dragging += 1
	offset_scale = (global_position.x - Global.window.global_position.x) / Global.window.frame.size.x
