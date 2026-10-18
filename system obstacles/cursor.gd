extends Node2D

var cursor_instance = preload("res://system obstacles/cursor_dragging.tscn")

@export var health := 5

@export var move_speed := 200
var is_dragging = false
var target_offset_x = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_offset_x += randi_range(-120, 120)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.is_game_over:
		queue_free()
	if global_position.x < Global.window.bar.global_position.x:
		scale.x = 1
	else:
		scale.x = -1
		
	if !is_dragging:
		global_position = global_position.move_toward(Global.window.bar.global_position + Vector2(target_offset_x,0), move_speed * delta)

func hit(damage):
	health -= damage
	if health <= 0:
		Global.add_score(30)
		queue_free()
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	is_dragging = true
	Global.cursors_dragging += 1
	var cursor_dragging = cursor_instance.instantiate()
	cursor_dragging.global_position = self.global_position - Global.window.global_position
	cursor_dragging.scale.x = scale.x
	cursor_dragging.health = health
	Global.window.add_child(cursor_dragging)
	queue_free()
