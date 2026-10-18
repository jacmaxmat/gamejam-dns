extends CharacterBody2D

@onready var bar = $Bar
@export var smoothing = 20
@onready var frame = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.window = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_for_bounds()
	
	#global_position = get_global_mouse_position()
	$Bar/CollisionShape2D.shape.extents.x = $Sprite2D.size.x/2
	$Bar.position.x = $Sprite2D.size.x/2
	$CollisionShape2D.shape.extents = $Sprite2D.size/2
	$CollisionShape2D.position = $Sprite2D.size/2
	Global.view.size = $Sprite2D.size
	
	#$SubViewportContainer.global_position = global_position
	#$SubViewportContainer/SubViewport.size = Vector2(480*$Sprite2D.scale.x, 270*$Sprite2D.scale.y)
	$WindowView.size = $Sprite2D.size
	
	
	if Input.is_action_pressed("ui_left"):
		resize(Vector2(1,0), 3)
	if Input.is_action_pressed("ui_right"):
		resize(Vector2(-1,0), 3)

func resize(dir, resize_speed):
	pass
	#match dir:
		#Vector2(1,0):
			#print("lewo")
			#var start_size = $Sprite2D.size.x
			#$Sprite2D.size.x = max($Sprite2D.size.x - (resize_speed * 2), 200)
			#var dif = start_size - $Sprite2D.size.x
			#print(dif)
			#$WindowView/SubViewport/TextureRect.global_position.x += dif
			##$Sprite2D.size.x -= resize_speed * 2
			##global_position.x += resize_speed*2
			#
			#global_position.x += dif
			##Global.cam.offset.x += dif
		#Vector2(-1,0):
			#var start_size = $Sprite2D.size.x
			#$Sprite2D.size.x = max($Sprite2D.size.x - (resize_speed), 200)
			#var dif = start_size - $Sprite2D.size.x
			#print(dif)
			#$WindowView/SubViewport/TextureRect.global_position.x -= 3
			##Global.cam.offset.x += dif
			##$Sprite2D.size.x -= resize_speed
		#Vector2(0,1):
			#var start_size = $Sprite2D.size.y
			#$Sprite2D.size.y = max($Sprite2D.size.y - (resize_speed * 2), 200)
			#var dif = start_size - $Sprite2D.size.y
			#global_position.y += dif
			##Global.cam.offset.y -= dif
			##$Sprite2D.size.y -= resize_speed * 2
			##global_position.y += resize_speed*2
		#Vector2(0,-1):
			#var start_size = $Sprite2D.size.y
			#$Sprite2D.size.y = max($Sprite2D.size.y - (resize_speed), 200)
			#var dif = start_size - $Sprite2D.size.y
			#Global.cam.offset.y += dif
	#if Input.is_action_pressed("ui_left"):
		#$Sprite2D.size.x -= resize_speed
	#elif Input.is_action_pressed("ui_right"):
		#$Sprite2D.size.x -= resize_speed * 2
		#global_position.x += resize_speed*2
	#elif Input.is_action_pressed("ui_up"):
		#$Sprite2D.size.y -= resize_speed
	#elif Input.is_action_pressed("ui_down"):
		#$Sprite2D.size.y -= resize_speed * 2
		#global_position.y += resize_speed*2

func _physics_process(delta: float) -> void:
	if Global.cursors_dragging ==0:
		velocity = Vector2.ZERO
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal()) *.5
		Global.drag_direction = velocity
	#move_and_slide()
	#if get_slide_collision_count() > 0:
		#print("hmm")
		#var collision = get_slide_collision(0)
		#velocity.bounce(collision.get_normal().normalized() * velocity)

func move(direction, speed, delta):
	if Global.cursors_dragging == 0:
		velocity = Vector2.ZERO
	else:
		velocity = direction.normalized() * speed

func check_for_bounds():
	var p_pos = Global.player.global_position
	if p_pos.x > Global.window.global_position.x + 245:
		print("R")
		Global.player.velocity = Vector2(-250,-350)
	elif p_pos.x < Global.window.global_position.x - 245:
		print("L")
		Global.player.velocity = Vector2(250,-350)
	elif p_pos.y < Global.window.global_position.y - 155:
		print("U")
		Global.player.set_collision_mask_value(3, false)
		Global.player.velocity = Vector2(Global.player.velocity.x,50)
		await get_tree().create_timer(.25).timeout
		Global.player.set_collision_mask_value(3, true)
	elif p_pos.y > Global.window.global_position.y + 145:
		print("D")
		Global.player.velocity = Vector2(Global.player.velocity.x,-650)
