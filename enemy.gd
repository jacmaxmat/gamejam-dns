extends Node2D

var target
@export var move_speed := 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = Global.player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.move_toward(target.global_position, move_speed * delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
