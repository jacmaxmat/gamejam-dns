extends CharacterBody2D

var component
var target
var target_offset: Vector2 = Vector2.ZERO
var is_hooked = false

@export var speed: float = 800.0
@onready var hitbox = $Area2D

func _process(delta: float) -> void:
	if !is_hooked:
		velocity = Vector2.RIGHT.rotated(hitbox.rotation) * speed
		#global_position += hitbox.transform.x * speed * delta
	else:
		velocity = Vector2.ZERO
		global_position = target.global_position - target_offset

func _physics_process(delta: float) -> void:
	move_and_slide()

func handle_hook(node):
	if target == null:
		is_hooked = true
		target = node
		#global_position = target.global_position
		target_offset = target.global_position - global_position
		component.is_hooked = is_hooked

func handle_unhook(node):
	if node==target:
		is_hooked = false
		target = null
		target_offset = Vector2.ZERO
		component.unhook()
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	handle_hook(body)
func _on_area_2d_body_exited(body: Node2D) -> void:
	handle_unhook(body)
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	handle_hook(area)
func _on_area_2d_area_exited(area: Area2D) -> void:
	handle_unhook(area)
