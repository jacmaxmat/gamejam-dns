extends CharacterBody2D

@export var health := 3

var is_invincible = false

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var jump_component: JumpComponent
@export var shooting_component: ShootingComponent
@export var aim_component: AimComponent
@export var animation_component: AnimationComponent

func _ready() -> void:
	Global.player = self

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal)
	jump_component.handle_jump(self, input_component.get_jump_input(), input_component.get_jump_input_released())
	aim_component.handle_aim(get_global_mouse_position())
	animation_component.handle_animations(self, get_global_mouse_position(), input_component.get_shoot_input())
	shooting_component.handle_shoot(input_component.get_shoot_input())
	
	move_and_slide()

func hit(amount):
	if !is_invincible:
		$HurtSound.play()
		Global.shakecamera.screen_shake(8,.3)
		is_invincible = true
		$Invincibility.play("asdasd")
		Global.update_health(amount)
	

func _on_invincibility_animation_finished(anim_name: StringName) -> void:
	is_invincible = false
