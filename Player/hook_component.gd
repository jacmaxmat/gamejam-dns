class_name HookComponent
extends Node

@export var hook_scene: PackedScene
@export var bounce_timer: Timer
@export var gun_barrel: Node2D
@export var hook_line: Line2D
@export var aim_indicator: Line2D
@export var visual_layer: Node2D
@export var player: CharacterBody2D
@export var HOOK_SPEED: int = 450
@export var HOOK_BOUNCE_VECTOR = Vector2(250,-475)
@export var HOOK_RANGE: int= 700
var is_hooked = false
var can_bounce = false
var can_shoot = true
var dir = Vector2.ZERO
var hook = null

func handle_hook(body):
	if is_hooked and can_bounce and (body.is_on_wall() or body.is_on_ceiling()):
		bounce(body)
	aim_indicator.set_point_position(0,gun_barrel.position)
	aim_indicator.set_point_position(1,aim_indicator.global_position.direction_to(body.get_global_mouse_position())*HOOK_RANGE*Vector2(sign(visual_layer.scale.x),1))
	hook_line.set_point_position(0,gun_barrel.position)
	if hook:
		if hook_line.visible == false:
			hook_line.visible = true
		hook_line.set_point_position(1,hook_line.to_local(hook.global_position))
	if is_hooked and dir != Vector2.ZERO and hook:
		if body.global_position.distance_to(hook.global_position) > 25:
			body.velocity = body.global_position.direction_to(hook.global_position) * HOOK_SPEED
		elif body.is_on_floor():
			unhook()
	if Input.is_action_just_pressed("dash"):
		aim_indicator.visible = true
	if Input.is_action_just_released("dash") and can_shoot:
		can_bounce = false
		aim_indicator.visible = false
		dir = (body.get_global_mouse_position() - body.global_position).normalized()
		hook = hook_scene.instantiate()
		hook.range = HOOK_RANGE
		hook.component = self
		hook.global_position = body.global_position
		get_tree().get_root().add_child(hook)
		hook.hitbox.look_at(body.get_global_mouse_position())
		can_shoot = false
	#if Input.is_action_just_released("dash"):
		#unhook()

func bounce(body: CharacterBody2D):
	var horizontal_dir: int
	if body.is_on_wall():
		horizontal_dir = -1
	else:
		horizontal_dir = 1
	if hook:
		body.velocity.x =  HOOK_BOUNCE_VECTOR.x * horizontal_dir*sign(body.velocity.x)
		body.velocity.y = HOOK_BOUNCE_VECTOR.y
		unhook()

func unhook():
	if player.is_on_floor():
		player.velocity.x *= .6
	is_hooked = false
	if hook:
		hook.queue_free()
	hook = null
	can_shoot = true
	hook_line.visible = false
	hook_line.set_point_position(1,Vector2.ZERO)

func _on_timer_timeout() -> void:
	can_bounce = true
