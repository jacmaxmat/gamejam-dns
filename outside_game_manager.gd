extends Node2D

var events = ["popup", "cursor", "resize"]
var current_event = "none"


var drag_direction = Vector2.ZERO
@export var drag_speed := 25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$EventTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.cursors_dragging > 0:
		if $DragTimer.is_stopped():
			$DragTimer.start()
			drag_direction = Vector2(randf_range(0,1),randf_range(0,1)).normalized()
		move_window(delta)
	elif !$DragTimer.is_stopped():
		$DragTimer.stop()

func move_window(delta):
	Global.window.move(drag_direction, drag_speed * Global.cursors_dragging)

func _on_timer_timeout() -> void:
	current_event = events[randi_range(0, events.size()-1)]
	match current_event:
		"popup":
			pass
		"cursor":
			pass
		"resize":
			pass


func _on_drag_timer_timeout() -> void:
	drag_direction = Vector2(randf_range(0,1),randf_range(0,1)).normalized()
