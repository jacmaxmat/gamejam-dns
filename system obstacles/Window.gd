extends CharacterBody2D

@onready var bar: Marker2D = $MarkerForCursor
@onready var frame: Sprite2D = $WindowSprite
@onready var left_jump_area: Area2D = $LeftJumpArea
@onready var right_jump_area: Area2D = $RightJumpArea

@onready var left_wall: CollisionShape2D = $LeftWall
@onready var right_wall: CollisionShape2D = $RightWall
@onready var top_wall: CollisionShape2D = $TopWall

@export var smoothing: float = 20.0
@export var inner_half_width: float = 215.0
@export var outer_half_width: float = 250.0
@export var screen_size: Vector2 = Vector2(1920, 1080)

var is_player_inside: bool = false
var is_jumping_out: bool = false
var was_on_floor: bool = false

func _ready() -> void:
	if Global.window == null:
		Global.window = self
	set_walls_enabled(false)

func get_frame_size() -> Vector2:
	return frame.texture.get_size() * frame.scale

var drag_velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if Global.cursors_dragging <= 0:
		drag_velocity = Vector2.ZERO
		
	var collision = move_and_collide(drag_velocity * delta)
	if collision:
		drag_velocity = drag_velocity.bounce(collision.get_normal()) * 0.5
		Global.drag_direction = drag_velocity
		
	velocity = Vector2.ZERO
	clamp_to_screen()
	update_player_walls()

func move(direction: Vector2, speed: float, _delta: float) -> void:
	if Global.cursors_dragging <= 0:
		drag_velocity = Vector2.ZERO
	else:
		drag_velocity = direction.normalized() * speed

func clamp_to_screen() -> void:
	var half_size: Vector2 = get_frame_size() * 0.5
	global_position.x = clampf(global_position.x, half_size.x, screen_size.x - half_size.x)
	global_position.y = clampf(global_position.y, half_size.y, screen_size.y - half_size.y)

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
