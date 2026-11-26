extends Node2D

@export var health: int = 5
@export var move_speed: float = 200.0
@export var drag_speed: float = 150.0
@export var drag_steering: float = 500.0
@export var screen_margin: float = 40.0

enum State { APPROACHING, DRAGGING }
var current_state: State = State.APPROACHING

var target_offset_x: float = 0.0
var target_window: CharacterBody2D = null
var is_attached: bool = false

var drag_target: Vector2 = Vector2.ZERO
var current_drag_velocity: Vector2 = Vector2.ZERO
var retarget_timer: float = 0.0

func _ready() -> void:
	if Global.window:
		target_offset_x = randf_range(-Global.window.get_frame_size().x/2, Global.window.get_frame_size().x/2)

func _exit_tree() -> void:
	detach_from_window()

func attach_to_window(win: CharacterBody2D) -> void:
	target_window = win
	current_state = State.DRAGGING
	is_attached = true
	Global.cursors_dragging += 1
	
	if not target_window.obstacle_hit.is_connected(_on_window_obstacle_hit):
		target_window.obstacle_hit.connect(_on_window_obstacle_hit)
		
	pick_new_drag_target()

func detach_from_window() -> void:
	if is_attached:
		is_attached = false
		Global.cursors_dragging = maxi(0, Global.cursors_dragging - 1)
		if is_instance_valid(target_window) and target_window.obstacle_hit.is_connected(_on_window_obstacle_hit):
			target_window.obstacle_hit.disconnect(_on_window_obstacle_hit)

func pick_new_drag_target(avoid_normal: Vector2 = Vector2.ZERO) -> void:
	if not is_instance_valid(target_window):
		return
		
	var half: Vector2 = target_window.get_frame_size() * 0.5
	var screen: Vector2 = target_window.screen_size
	var min_x: float = half.x + screen_margin
	var max_x: float = screen.x - half.x - screen_margin
	var min_y: float = half.y + screen_margin
	var max_y: float = screen.y - half.y - screen_margin
	
	var best_point: Vector2 = Vector2(randf_range(min_x, max_x), randf_range(min_y, max_y))
	if avoid_normal != Vector2.ZERO:
		for i in 5:
			var candidate: Vector2 = Vector2(randf_range(min_x, max_x), randf_range(min_y, max_y))
			if target_window.global_position.direction_to(candidate).dot(avoid_normal) > 0.2:
				best_point = candidate
				break
				
	drag_target = best_point
	retarget_timer = randf_range(1.5, 3.5)

func _on_window_obstacle_hit(normal: Vector2) -> void:
	current_drag_velocity = current_drag_velocity.bounce(normal) * 0.6
	pick_new_drag_target(normal)

func _physics_process(delta: float) -> void:
	if Global.is_game_over:
		detach_from_window()
		queue_free()
		return
		
	match current_state:
		State.APPROACHING:
			if not is_instance_valid(Global.window):
				return
			var grab_pos: Vector2 = Global.window.bar.global_position + Vector2(target_offset_x, 0.0)
			scale.x = 1 if global_position.x < grab_pos.x else -1
			
			if global_position.distance_to(grab_pos) > 12.0:
				global_position = global_position.move_toward(grab_pos, move_speed * delta)
			else:
				attach_to_window(Global.window)
				
		State.DRAGGING:
			if not is_instance_valid(target_window):
				detach_from_window()
				queue_free()
				return
				
			retarget_timer -= delta
			if retarget_timer <= 0.0 or target_window.global_position.distance_to(drag_target) < 30.0:
				pick_new_drag_target()
				
			var desired_vel: Vector2 = target_window.global_position.direction_to(drag_target) * drag_speed
			current_drag_velocity = current_drag_velocity.move_toward(desired_vel, drag_steering * delta)
			target_window.apply_drag(current_drag_velocity)

func _process(_delta: float) -> void:
	if current_state == State.DRAGGING and is_instance_valid(target_window):
		global_position = target_window.bar.global_position + Vector2(target_offset_x, 0.0)

func hit(damage: int) -> void:
	health -= damage
	if health <= 0:
		detach_from_window()
		Global.add_score(30)
		queue_free()
		return
	await get_tree().create_timer(0.1).timeout
