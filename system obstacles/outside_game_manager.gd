extends Node2D

var events = ["cursor"]
var current_event = "none"
@export var active = true

var popup_preload = preload("uid://dfyfwjfuri5wl")
var cursor_preload = preload("uid://dohkivpoc06r6")
var push_preload = preload("uid://b4ttwoadwy288")

@export var drag_speed := 130

func _ready() -> void:
	if active:
		$EventTimer.start()

func _process(delta: float) -> void:
	if Global.cursors_dragging > 0:
		if $DragTimer.is_stopped():
			$DragTimer.start()
			Global.drag_direction = Vector2(randf_range(0,1),randf_range(0,1)).normalized()
		if Global.cursors_dragging > 0:
			move_window(delta)
	else:
		Global.window.velocity = Vector2.ZERO
		if !$DragTimer.is_stopped():
			$DragTimer.stop()


func move_window(delta):
	Global.window.move(Global.drag_direction, drag_speed * Global.cursors_dragging, delta)

func _on_timer_timeout() -> void:
	current_event = events[randi_range(0, events.size()-1)]
	match current_event:
		"popup":
			var popup_instance = popup_preload.instantiate()
			get_tree().get_root().add_child(popup_instance)
		"cursor":
			var cursor_instance = cursor_preload.instantiate()
			cursor_instance.global_position = Vector2(randi_range(20,1132), 30)
			get_tree().get_root().add_child(cursor_instance)
		"push":
			var push_instance = push_preload.instantiate()
			get_tree().get_root().add_child(push_instance)


func _on_drag_timer_timeout() -> void:
	Global.drag_direction = Vector2(randf_range(0,1),randf_range(0,1)).normalized()
