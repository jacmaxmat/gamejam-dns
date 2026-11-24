extends SubViewportContainer

@onready var cam = $SubViewport/Camera2D

@export var target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	$SubViewport.world_2d = get_tree().root.world_2d
	if !target:
		target = get_parent()

func _physics_process(delta: float) -> void:
	global_position = target.global_position- size/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	cam.global_position = target.global_position
	
	if Input.is_action_pressed("ui_up"):
		resize(Vector2(0,4))
	if Input.is_action_pressed("ui_right"):
		resize(Vector2(4,0))
	if Input.is_action_pressed("ui_down"):
		resize(Vector2(0,-4))
	if Input.is_action_pressed("ui_left"):
		resize(Vector2(-4,0))

func resize(difference: Vector2):
	size += difference
	global_position = target.global_position - size/2
	cam.global_position = target.global_position
