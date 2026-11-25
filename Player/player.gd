extends CharacterBody2D
class_name Player

@export var health := 10

var is_topdown = false
var is_invincible = false
var is_dropping = false
var default_parent: Node = null
var pending_parent: Node = null
var is_reparenting: bool = false

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var jump_component: JumpComponent
@export var shooting_component: ShootingComponent
@export var aim_component: AimComponent
@export var animation_component: AnimationComponent
@export var hook_component: HookComponent

func _ready() -> void:
	Global.player = self
	default_parent = get_parent()
	platform_floor_layers = 0

func attach_to_parent(new_parent: Node) -> void:
	if not is_instance_valid(new_parent):
		return
	if get_parent() == new_parent and pending_parent == null:
		return
	pending_parent = new_parent
	_apply_reparent.call_deferred()

func _apply_reparent() -> void:
	var target: Node = pending_parent
	pending_parent = null
	if not is_instance_valid(target) or get_parent() == target:
		return
	is_reparenting = true
	reparent(target, true) # true = zachowuje dokładną global_position
	is_reparenting = false

func _process(delta: float) -> void:
	is_invincible = hook_component.is_hooked
	if Input.is_action_just_pressed("tab"):
		is_topdown = !is_topdown
		if is_topdown:
			motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
		else:
			motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	#if Input.is_action_just_pressed("down"):
		#velocity.y = 0
		#is_dropping = true
		#set_collision_mask_value(3, false)
		#await get_tree().create_timer(.2).timeout
		#is_dropping = false
		#set_collision_mask_value(3, true)

func _physics_process(delta: float) -> void:
	if !is_topdown:
		gravity_component.handle_gravity(self, delta)
		jump_component.handle_jump(self, input_component.get_jump_input(), input_component.get_jump_input_released())
	movement_component.handle_horizontal_movement(self, Vector2(input_component.input_horizontal,input_component.input_vertical))
	aim_component.handle_aim(get_global_mouse_position())
	animation_component.handle_animations(self, get_global_mouse_position(), input_component.get_shoot_input())
	#shooting_component.handle_shoot(input_component.get_shoot_input())
	hook_component.handle_hook(self)
	
	move_and_slide()

func hit(amount):
	if !is_invincible:
		#$HurtSound.play()
		#Global.shakecamera.screen_shake(8,.3)
		is_invincible = true
		$Invincibility.play("asdasd")
		Global.update_health(amount)

func _on_invincibility_animation_finished(anim_name: StringName) -> void:
	is_invincible = false

func _on_window_detection_area_entered(area: Area2D) -> void:
	is_topdown = true
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

func _on_window_detection_area_exited(area: Area2D) -> void:
	if !$WindowDetection.has_overlapping_areas():
		is_topdown = false
		motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
