extends CharacterBody2D

@export var speed = 50

func _ready() -> void:
	global_position.x = randi_range(100, 1820)
	global_position.y = randi_range(100, 980)
	var direction = global_position.direction_to(Global.window.global_position)
	velocity = speed * direction

func _physics_process(delta: float) -> void:
	if Global.is_game_over:
		queue_free()
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
