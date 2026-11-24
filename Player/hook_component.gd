class_name HookComponent
extends Node

@export var hook_scene: PackedScene
@export var gun_barrel: Node2D
@export var hook_line: Line2D
@export var HOOK_SPEED: int = 450
var is_hooked = false
var can_shoot = true
var dir = Vector2.ZERO
var hook = null

func handle_hook(body):
	hook_line.set_point_position(0,gun_barrel.position)
	if hook:
		if hook_line.visible == false:
			hook_line.visible = true
		hook_line.set_point_position(1,hook_line.to_local(hook.global_position))

	if is_hooked and dir != Vector2.ZERO and hook:
		if body.global_position.distance_to(hook.global_position) > 20:
			body.velocity = body.global_position.direction_to(hook.global_position) * HOOK_SPEED
		else:
			body.velocity = Vector2.ZERO
			if Input.is_action_just_pressed("jump"):
				if !body.is_topdown:
					body.jump_component.jump(body)
				unhook()
	if Input.is_action_just_pressed("dash") and can_shoot:
		dir = (Global.mouse_position - body.global_position).normalized()
		hook = hook_scene.instantiate()
		hook.component = self
		hook.global_position = body.global_position
		get_tree().get_root().add_child(hook)
		hook.hitbox.look_at(Global.mouse_position)
		can_shoot = false
		$Timer.start()
	if Input.is_action_just_released("dash"):
		unhook()

func unhook():
	is_hooked = false
	if hook:
		hook.queue_free()
	hook = null
	can_shoot = true
	hook_line.visible = false
	hook_line.set_point_position(1,Vector2.ZERO)

func _on_timer_timeout() -> void:
	if !is_hooked:
		can_shoot = true
