extends Node2D

var events = ["cursor"]
var current_event = "none"
@export var active = true

# Variables for projectile cursors
@export var projectile_cursor_controller: PackedScene
@export var available_formations: Array[FormationPattern] = []
@export var spawn_interval: float = 12.0
@export var min_formation_enemies: int = 2
@export var max_formation_enemies: int = 4

var popup_preload = preload("uid://dfyfwjfuri5wl")
var push_preload = preload("uid://b4ttwoadwy288")
const cursor_dragger_preload = preload("res://Enemies/Cursors/cursor_dragging.tscn")

@export var drag_speed := 130

func _ready() -> void:
	if active:
		$EventTimer.start()
	$ProjectileTimer.wait_time = spawn_interval
	$ProjectileTimer.start()
	$DragTimer.start()
		
func spawn_random_formation() -> void:
	if not available_formations.is_empty():
		var random_pattern = available_formations.pick_random()
		var new_cursor_controller = projectile_cursor_controller.instantiate() as FormationController
		new_cursor_controller.pattern = random_pattern
		new_cursor_controller.enemy_count = randi_range(min_formation_enemies, max_formation_enemies)
		add_child(new_cursor_controller)
		
func spawn_window_dragger() -> void:
	if not Global.window or not is_instance_valid(Global.window):
		return
	var dragger = cursor_dragger_preload.instantiate()
	var spawn_x = 0.0
	if randf() > 0.5:
		spawn_x = Global.window.global_position.x - 600 
	else:
		var frame_width = Global.window.frame.texture.get_size().x * Global.window.frame.scale.x
		spawn_x = Global.window.global_position.x + frame_width + 600 
	var spawn_y = Global.window.global_position.y + randf_range(-150, 150)
	dragger.global_position = Vector2(spawn_x, spawn_y)
	add_child(dragger)

func _on_timer_timeout() -> void:
	current_event = events[randi_range(0, events.size()-1)]
	match current_event:
		"popup":
			var popup_instance = popup_preload.instantiate()
			get_tree().get_root().add_child(popup_instance)
		"push":
			var push_instance = push_preload.instantiate()
			get_tree().get_root().add_child(push_instance)


func _on_drag_timer_timeout() -> void:
	spawn_window_dragger()

func _on_projectile_timer_timeout() -> void:
	spawn_random_formation()
