extends CharacterBody2D

var component
var target
var target_offset: Vector2 = Vector2.ZERO
var is_hooked = false
var is_retracting = false
var collision_position: Vector2 = Vector2.ZERO
var range: int = 300
var start_position: Vector2
var is_pausing = false


@export var speed: float = 800.0
@onready var hitbox = $RayCast2D
@export var folder_break_distance: float = 65.0

func _ready() -> void:
	start_position = global_position

func _physics_process(delta: float) -> void:
	if not is_instance_valid(component):
		queue_free()
		return

	if is_retracting:
		global_position = global_position.move_toward(component.hook_line.global_position, speed * delta)
		if global_position.distance_to(component.hook_line.global_position) < 15.0:
			handle_unhook()
		return

	if is_hooked:
		if is_instance_valid(target):
			global_position = target.global_position - target_offset
		else:
			handle_unhook()
		return

	if is_pausing:
		return

	global_position += Vector2.RIGHT.rotated(hitbox.rotation) * speed * delta
	hitbox.force_raycast_update()

	if hitbox.is_colliding():
		handle_hook(hitbox.get_collider())
	elif global_position.distance_to(start_position) >= range:
		_start_retract()

func _start_retract() -> void:
	is_pausing = true
	await get_tree().create_timer(0.05).timeout
	if is_instance_valid(self) and not is_hooked:
		is_retracting = true

func handle_hook(node):
	if target == null:
		var folder: Node2D = null
		if node.has_method("break_folder"):
			folder = node
		elif node is Node and node.get_parent() and node.get_parent().has_method("break_folder"):
			folder = node.get_parent()
		global_position = hitbox.get_collision_point()
		Global.shakecamera.screen_shake(10, .1)
		is_hooked = true
		if folder != null:
			target = folder
			component.hooked_folder = folder
		else:
			target = node
		#global_position = target.global_position
		if target:
			target_offset = target.global_position - global_position
		component.bounce_timer.start()
		component.is_hooked = is_hooked

func handle_unhook():
	is_hooked = false
	target = null
	target_offset = Vector2.ZERO
	if is_instance_valid(component):
		component.unhook()
