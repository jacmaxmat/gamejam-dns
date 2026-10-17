extends Node2D

var offset_scale_x = 0
var offset_scale_y = 0
var shrink_direction = Vector2.ZERO
var shrink_speed = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("?")
	offset_scale_y = (abs(global_position.y - Global.window.global_position.y))/Global.window.frame.size.y
	offset_scale_x = (global_position.x - Global.window.global_position.x)/Global.window.frame.size.x


func _process(delta: float) -> void:
	global_position.y = Global.window.global_position.y + (Global.window.frame.size.y * offset_scale_y)
	global_position.x = Global.window.global_position.x + (Global.window.frame.size.x * offset_scale_x)
		
	Global.window.resize(shrink_direction, shrink_speed * delta)
