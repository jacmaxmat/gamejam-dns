extends Node2D

var pusher_instance = preload("res://system obstacles/pusher_pushing.tscn")

var direction = Vector2.ZERO
@export var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position.x = 1202
	global_position.y = randi_range(50,598)
	direction = Vector2(-1,0)
	#global_position.x = -100
	#global_position.y = randi_range(50,598)
	#direction = Vector2(1,0)
	#var spawn_side = randi_range(1,2)
	#match spawn_side:
		#1: #right
			#global_position.x = -100
			#global_position.y = randi_range(50,598)
			#direction = Vector2(1,0)
		#2: #left
			#global_position.x = 1202
			#global_position.y = randi_range(50,598)
			#direction = Vector2(-1,0)
	#var spawn_side = randi_range(1,4)
	#match spawn_side:
		#1: #right
			#global_position.x = -100
			#global_position.y = randi_range(50,598)
			#direction = Vector2(1,0)
		#2: #left
			#global_position.x = 1202
			#global_position.y = randi_range(50,598)
			#direction = Vector2(-1,0)
		#3: #up
			#global_position.y = 698
			#global_position.x = randi_range(50,1102)
			#direction = Vector2(0,-1)
		#4: #down
			#global_position.y = -100
			#global_position.x = randi_range(50,1102)
			#direction = Vector2(0,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.is_game_over:
		queue_free()
	global_position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	var pusher_pushing = pusher_instance.instantiate()
	pusher_pushing.global_position = self.global_position - Global.window.global_position
	pusher_pushing.shrink_direction = direction
	Global.window.add_child(pusher_pushing)
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	var pusher_pushing = pusher_instance.instantiate()
	pusher_pushing.global_position = self.global_position - Global.window.global_position
	pusher_pushing.shrink_direction = direction
	Global.window.add_child(pusher_pushing)
	queue_free()
