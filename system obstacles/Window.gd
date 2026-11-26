extends CharacterBody2D

signal obstacle_hit(normal: Vector2)

@onready var bar: Marker2D = $MarkerForCursor
@onready var frame: Sprite2D = $WindowSprite

@export var inner_half_width: float = 215.0
@export var outer_half_width: float = 250.0
@export var screen_size: Vector2 = Vector2(1920, 1080)
@export var friction: float = 800.0

var is_player_inside: bool = false
var is_jumping_out: bool = false
var was_on_floor: bool = false

var drag_velocity: Vector2 = Vector2.ZERO
var pending_drag_sum: Vector2 = Vector2.ZERO
var pending_drag_count: int = 0

func _ready() -> void:
	add_to_group("windows")
	if Global.window == null:
		Global.window = self

func get_frame_size() -> Vector2:
	return frame.texture.get_size() * frame.global_scale.abs()

func apply_drag(vel: Vector2) -> void:
	pending_drag_sum += vel
	pending_drag_count += 1

func _physics_process(delta: float) -> void:
	if pending_drag_count > 0:
		var speed_mult: float = 10.0 + (pending_drag_count - 1) * 3
		drag_velocity = pending_drag_sum.normalized() * speed_mult
		Global.drag_direction = drag_velocity
	else:
		drag_velocity = drag_velocity.move_toward(Vector2.ZERO, friction * delta)
		
	pending_drag_sum = Vector2.ZERO
	pending_drag_count = 0
	if drag_velocity.length_squared() > 0.1:
		var collision:= move_and_collide(drag_velocity * delta)
		if collision:
			var normal: Vector2 = collision.get_normal()
			var slide_motion: Vector2 = collision.get_remainder().slide(normal)
			move_and_collide(slide_motion)
			drag_velocity = drag_velocity.bounce(normal) * 0.6
			obstacle_hit.emit(normal)
			
	velocity = Vector2.ZERO

func is_point_in_area(area: Area2D, world_pos: Vector2) -> bool:
	var shape_node: CollisionShape2D = area.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if not shape_node or not (shape_node.shape is RectangleShape2D):
		return false
	var rect_size: Vector2 = (shape_node.shape as RectangleShape2D).size
	var local_p: Vector2 = shape_node.to_local(world_pos)
	return absf(local_p.x) <= rect_size.x * 0.5 and absf(local_p.y) <= rect_size.y * 0.5
