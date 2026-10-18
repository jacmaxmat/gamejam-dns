extends Node2D

var target
@export var move_speed := 200
var health := 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = Global.player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

func hit(damage):
	health -= damage
	if health <= 0:
		Global.add_score(50)
		queue_free()
