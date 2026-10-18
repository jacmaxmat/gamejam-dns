extends Area2D

@export var falling_speed := 60

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.y += falling_speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("hit"):
		area.hit(1)
	queue_free()
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		body.hit(1)
	queue_free()
