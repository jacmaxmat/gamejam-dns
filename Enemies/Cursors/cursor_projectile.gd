extends CharacterBody2D
class_name ProjectileCursor

@export var smoothing_speed: float = 4.0 
@export var strike_speed: float = 600.0
@export var damage: int = 1

enum State { FLYING_IN, WAITING, STRIKING }
var current_state: State = State.FLYING_IN

var target_position: Vector2 = Vector2.INF
var strike_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$Area2D.set_deferred("monitoring", false)
	$Area2D.set_deferred("monitorable", false)

func set_target_position(new_pos: Vector2) -> void:
	if current_state == State.FLYING_IN:
		target_position = new_pos

func prepare_strike(direction: Vector2) -> void:
	current_state = State.WAITING
	strike_direction = direction 

# 2. POPRAWKA: Włączamy wszystko dopiero w momencie ataku
func start_strike() -> void:
	current_state = State.STRIKING
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	$Area2D.set_deferred("monitoring", true)
	$Area2D.set_deferred("monitorable", true)
	if not $Sprite2D/VisibleOnScreenNotifier2D.screen_exited.is_connected(die):
		$Sprite2D/VisibleOnScreenNotifier2D.screen_exited.connect(die)

func _physics_process(delta: float) -> void:
	match current_state:
		State.FLYING_IN:
			if target_position != Vector2.INF:
				velocity = (target_position - global_position) * smoothing_speed
		State.WAITING:
			velocity = Vector2.ZERO
		State.STRIKING:
			velocity = strike_direction * strike_speed
	global_position += velocity * delta
	check_hit()

func _process(delta: float) -> void:
	$Sprite2D.global_position = global_position + Global.LEVEL_OFFSET
	if current_state == State.FLYING_IN and velocity.length() > 10.0:
		$Sprite2D.global_rotation = velocity.angle()
	elif current_state == State.WAITING or current_state == State.STRIKING:
		$Sprite2D.global_rotation = strike_direction.angle()

func die() -> void:
	queue_free()

func check_hit() -> void:
	if current_state != State.STRIKING:
		return
		
	if Global.player and is_instance_valid(Global.player):
		if global_position.distance_to(Global.player.global_position) < 40.0:
			Global.player.hit(damage)
			die()
