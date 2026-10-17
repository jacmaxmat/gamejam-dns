extends CharacterBody2D

@onready var bar = $Bar
@export var smoothing = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.window = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	move_and_slide()

func move(direction, speed):
	velocity = direction.normalized() * speed
