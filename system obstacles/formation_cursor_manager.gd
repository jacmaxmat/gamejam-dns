extends Node2D
class_name FormationController

@export var pattern: FormationPattern
@export var enemy_count: int = 5

@export var fly_in_time: float = 2.0
@export var wait_time: float = 1.0

const CursorScene = preload("res://system obstacles/cursor.tscn")
var cursors: Array[Node2D]
var time_passed: float = 0.0

enum State { FLYING_IN, WAITING, STRIKING }
var current_state: State = State.FLYING_IN

var squad_direction: Vector2 = Vector2.ZERO 

func _ready() -> void:
	var player = Global.player
	var spawn_center = player.global_position if player else Vector2.ZERO
	var random_angle = randf() * TAU
	var spawn_offset = Vector2(cos(random_angle), sin(random_angle))
	squad_direction = -spawn_offset 
	
	for i in range(enemy_count):
		var cursor = CursorScene.instantiate()
		cursor.global_position = spawn_center + (spawn_offset * 1500.0)
		get_tree().current_scene.call_deferred("add_child", cursor)
		cursors.append(cursor)
		
	$PrepareTimer.wait_time = fly_in_time
	$StrikeTimer.wait_time = fly_in_time + wait_time
	
	$PrepareTimer.start()
	$StrikeTimer.start()

func prepare_squad() -> void:
	current_state = State.WAITING
	var player = Global.player
	var player_pos = player.global_position if player else Vector2.ZERO
	
	for cursor in cursors:
		if is_instance_valid(cursor) and cursor.has_method("prepare_strike"):
			var strike_dir = Vector2.ZERO
			if pattern is LinePattern:
				if player_pos.y > cursor.global_position.y:
					strike_dir = Vector2(0, 1)
				else:
					strike_dir = Vector2(0, -1)
			else:
				strike_dir = cursor.global_position.direction_to(player_pos)
				
			cursor.prepare_strike(strike_dir)

func strike_squad() -> void:
	current_state = State.STRIKING
	for cursor in cursors:
		if is_instance_valid(cursor) and cursor.has_method("start_strike"):
			cursor.start_strike()

func _process(delta: float) -> void:
	if current_state != State.FLYING_IN:
		return
		
	if not pattern:
		return
		
	cursors = cursors.filter(func(enemy): return is_instance_valid(enemy))
	if cursors.is_empty():
		queue_free()
		return
		
	var player = Global.player
	if not player:
		return
		
	time_passed += delta
	var active_count = cursors.size()
	
	for i in range(active_count):
		var cursor = cursors[i]
		var offset = pattern.get_offset(i, active_count, time_passed)
		var target_pos = player.global_position + offset
		
		if cursor.has_method("set_target_position"):
			cursor.set_target_position(target_pos)

func _on_prepare_timer_timeout() -> void:
	prepare_squad()

func _on_strike_timer_timeout() -> void:
	strike_squad()
