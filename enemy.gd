extends Node2D

@export var health := 6

var target
@export var move_speed := 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = Global.player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position= global_position.move_toward(target.global_position + Vector2(240,135), move_speed * delta)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	if body.has_method("hit"):
		body.hit(1)
	queue_free()
	
func hit(damage):
	health -= damage
	if health <= 0:
		Global.add_score(50)
		queue_free()
