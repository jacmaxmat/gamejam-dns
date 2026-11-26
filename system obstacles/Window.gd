extends CharacterBody2D

signal obstacle_hit(normal: Vector2)

@onready var bar: Marker2D = $MarkerForCursor
@onready var frame: Sprite2D = $WindowSprite
@onready var left_jump_area: Area2D = $LeftJumpArea
@onready var right_jump_area: Area2D = $RightJumpArea

@onready var left_wall: CollisionShape2D = $PlayerBounds/LeftWall
@onready var right_wall: CollisionShape2D = $PlayerBounds/RightWall
@onready var top_wall: CollisionShape2D = $PlayerBounds/TopWall

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
	set_walls_enabled(false)

func get_frame_size() -> Vector2:
	return frame.texture.get_size() * frame.scale

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
	update_player_walls()

func update_player_walls() -> void:
	if not Global.get("player") or not is_instance_valid(Global.player):
		return
		
	var player = Global.player
	var local_pos: Vector2 = to_local(player.global_position)
	var on_floor: bool = player.is_on_floor()
	
	var inside_inner: bool = absf(local_pos.x) < inner_half_width and local_pos.y > -120.0 and local_pos.y < 85.0
	var inside_outer: bool = absf(local_pos.x) < outer_half_width and local_pos.y > -145.0 and local_pos.y < 140.0
	
	if not is_player_inside:
		if inside_inner:
			is_player_inside = true
			is_jumping_out = false
			Global.window = self
		set_walls_enabled(is_player_inside)
		was_on_floor = on_floor
		return

	if Global.window != self:
		Global.window = self
	
	if not inside_outer:
		if is_jumping_out:
			is_player_inside = false
			is_jumping_out = false
			set_walls_enabled(false)
			if player.get_parent() == self:
				player.attach_to_parent(player.default_parent)
			was_on_floor = on_floor
			return
		else:
			local_pos.x = clampf(local_pos.x, -inner_half_width, inner_half_width)
			local_pos.y = clampf(local_pos.y, -115.0, 55.0)
			player.global_position = to_global(local_pos)
			player.velocity = Vector2.ZERO
	
	var in_jump_zone: bool = is_point_in_area(left_jump_area, player.global_position) or is_point_in_area(right_jump_area, player.global_position)
	
	if on_floor and player.velocity.y >= 0.0:
		is_jumping_out = false
	elif not is_jumping_out and (was_on_floor or on_floor) and in_jump_zone and player.velocity.y < -10.0:
		is_jumping_out = true
		
	set_walls_enabled(not is_jumping_out)
	was_on_floor = on_floor

func is_point_in_area(area: Area2D, world_pos: Vector2) -> bool:
	var shape_node: CollisionShape2D = area.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if not shape_node or not (shape_node.shape is RectangleShape2D):
		return false
	var rect_size: Vector2 = (shape_node.shape as RectangleShape2D).size
	var local_p: Vector2 = shape_node.to_local(world_pos)
	return absf(local_p.x) <= rect_size.x * 0.5 and absf(local_p.y) <= rect_size.y * 0.5

func set_walls_enabled(enabled: bool) -> void:
	left_wall.disabled = not enabled
	right_wall.disabled = not enabled
	top_wall.disabled = not enabled
