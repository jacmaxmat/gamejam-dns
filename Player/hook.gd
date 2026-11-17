extends Node2D

var component
var target
var target_offset: Vector2 = Vector2.ZERO
var is_hooked = false

@export var speed: float = 800.0
@onready var hitbox = $Area2D

func _process(delta: float) -> void:
	$Sprite2D.position = Global.LEVEL_OFFSET
	if !is_hooked:
		global_position += hitbox.transform.x * speed * delta
	else:
		global_position = target.global_position - target_offset

func _on_area_2d_body_entered(body: Node2D) -> void:
	is_hooked = true
	target = body
	target_offset = target.global_position - global_position
	component.is_hooked = is_hooked
