extends Node2D

var cursor_instance = preload("res://cursor_dragging.tscn")

@export var move_speed := 100
var is_dragging = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_dragging:
		global_position = global_position.move_toward(Global.window.bar.global_position, move_speed * delta)

func _on_area_2d_area_entered(area: Area2D) -> void:
	is_dragging = true
	Global.cursors_dragging += 1
	var cursor_dragging = cursor_instance.instantiate()
	cursor_dragging.global_position = self.global_position - Global.window.global_position
	Global.window.add_child(cursor_dragging)
	print(cursor_dragging.global_position)
	queue_free()
