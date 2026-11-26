extends CharacterBody2D

var component
var target
var target_offset: Vector2 = Vector2.ZERO
var is_hooked = false
var is_retracting = false
var collision_position: Vector2 = Vector2.ZERO
var range: int = 300
var start_position: Vector2

@export var speed: float = 800.0
@onready var hitbox = $RayCast2D

func _ready() -> void:
	start_position = global_position

func _process(delta: float) -> void:
	if global_position.distance_to(start_position) >= range:
		velocity = Vector2.ZERO
		await get_tree().create_timer(0.05).timeout
		is_retracting = true
	if is_retracting:
		global_position = global_position.move_toward(component.hook_line.global_position, speed*delta)
		if global_position.distance_to(component.hook_line.global_position) < 15:
			handle_unhook(target)
	else:
		if !is_hooked:
			velocity = Vector2.RIGHT.rotated(hitbox.rotation) * speed
			if hitbox.is_colliding():
				handle_hook(hitbox.get_collider())
				
			#global_position += hitbox.transform.x * speed * delta
		else:
			velocity = Vector2.ZERO
			if target:
				global_position = target.global_position - target_offset
			else:
				handle_unhook(target)

func _physics_process(delta: float) -> void:
	move_and_slide()

func handle_hook(node):
	if target == null:
		global_position = hitbox.get_collision_point()
		Global.shakecamera.screen_shake(10, .1)
		is_hooked = true
		target = node
		#global_position = target.global_position
		target_offset = target.global_position - global_position
		component.bounce_timer.start()
		component.is_hooked = is_hooked

func handle_unhook(node):
	if node==target:
		is_hooked = false
		target = null
		target_offset = Vector2.ZERO
		component.can_shoot = true
		component.unhook()
