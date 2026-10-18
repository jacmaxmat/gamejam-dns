extends CharacterBody2D

@export var health := 6

@export var sprite1: Texture
@export var sprite2: Texture
@export var sprite3: Texture
@export var sprite4: Texture

@onready var sprites = [sprite1, sprite2, sprite3, sprite4]

@export var speed = 15

func _ready() -> void:
	$Sprite2D.texture = sprites[randi_range(0, sprites.size()-1)]
	#global_position.x = randi_range(100, 1820)
	#global_position.y = randi_range(100, 980)
	var direction = global_position.direction_to(Global.window.global_position)
	velocity = speed * direction

func _process(delta: float) -> void:
	if Global.is_game_over:
		queue_free()

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())

func hit(amount):
	$bialyok.visible = true
	health-=amount
	if health <= 0:
		queue_free()
	await get_tree().create_timer(.1).timeout
	$bialyok.visible=false
	
