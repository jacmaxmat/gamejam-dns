extends CharacterBody2D

@export var speed = 50

func _ready() -> void:
	global_position.x = randi_range(100, 1820)
	global_position.y = randi_range(100, 980)
	var direction = Vector2(randf_range(-1,1),randf_range(-1,1))
	velocity = speed * direction

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
