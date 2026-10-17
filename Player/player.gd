extends CharacterBody2D

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var jump_component: JumpComponent
@export var shooting_component: ShootingComponent
@export var aim_component: AimComponent
@export var animation_component: AnimationComponent

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal)
	jump_component.handle_jump(self, input_component.get_jump_input(), input_component.get_jump_input_released())
	animation_component.handle_animations(self, get_global_mouse_position())
	shooting_component.handle_shoot(input_component.get_shoot_input())
	
	move_and_slide()
