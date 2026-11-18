extends CharacterBody2D

@export var health := 3

var is_invincible = false
var is_dropping = false

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var jump_component: JumpComponent
@export var shooting_component: ShootingComponent
@export var aim_component: AimComponent
@export var animation_component: AnimationComponent

@export var dash_component: Node

func _ready() -> void:
	pass
	Global.player = self

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		velocity.y = 0
		is_dropping = true
		set_collision_mask_value(3, false)
		await get_tree().create_timer(.2).timeout
		is_dropping = false
		set_collision_mask_value(3, true)
		
	$VisualLayer.position = Global.LEVEL_OFFSET

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal)
	jump_component.handle_jump(self, input_component.get_jump_input(), input_component.get_jump_input_released())
	aim_component.handle_aim(Global.mouse_position)
	animation_component.handle_animations(self, Global.mouse_position, input_component.get_shoot_input())
	#shooting_component.handle_shoot(input_component.get_shoot_input())
	
	dash_component.handle_dash(self)
	
	move_and_slide()

func hit(amount):
	if !is_invincible:
		$HurtSound.play()
		#Global.shakecamera.screen_shake(8,.3)
		is_invincible = true
		$Invincibility.play("asdasd")
		Global.update_health(amount)

func _on_invincibility_animation_finished(anim_name: StringName) -> void:
	is_invincible = false

func _on_window_detection_area_entered(area: Area2D) -> void:
	if !is_dropping:
		set_collision_mask_value(3, true)
	set_collision_mask_value(4, true)

func _on_window_detection_area_exited(area: Area2D) -> void:
	if $WindowDetection.get_overlapping_areas().size() == 0:
		set_collision_mask_value(3, false)
		set_collision_mask_value(4, false)
