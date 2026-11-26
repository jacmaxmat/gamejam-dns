extends Node2D

signal destroyed(file: Node2D)

@export var speed: float = 340.0
@export var health: int = 1
@export var screen_size: Vector2 = Vector2(1920.0, 1080.0)

var velocity: Vector2 = Vector2.ZERO
var is_merging: bool = false

func launch(direction: Vector2) -> void:
	velocity = direction.normalized() * speed

func _process(delta: float) -> void:
	if is_merging:
		return
		
	global_position += velocity * delta
	
	if global_position.x <= 0.0:
		global_position.x = 0.0
		velocity.x = absf(velocity.x)
	elif global_position.x >= screen_size.x:
		global_position.x = screen_size.x
		velocity.x = -absf(velocity.x)
		
	if global_position.y <= 0.0:
		global_position.y = 0.0
		velocity.y = absf(velocity.y)
	elif global_position.y >= screen_size.y:
		global_position.y = screen_size.y
		velocity.y = -absf(velocity.y)

func hit(damage: int = 1) -> void:
	if is_merging:
		return
	health -= damage
	if health <= 0:
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		$AnimationPlayer.play("kablow")
		await $AnimationPlayer.animation_finished
		destroyed.emit(self)
		queue_free()

func start_merge(target_pos: Vector2, duration: float = 0.25) -> void:
	is_merging = true
	if has_node("Area2D/CollisionShape2D"):
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
